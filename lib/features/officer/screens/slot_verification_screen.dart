import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import 'gate_verification_screen.dart';

class SlotVerificationScreen extends StatefulWidget {
  const SlotVerificationScreen({super.key});

  @override
  State<SlotVerificationScreen> createState() => _SlotVerificationScreenState();
}

class _SlotVerificationScreenState extends State<SlotVerificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _database = IsarDatabaseService();
  final _tokenInputController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();

  bool _isSearching = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tokenInputController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processScannedData(String rawCode) async {
    if (_hasScanned || _isSearching) return;
    setState(() {
      _hasScanned = true;
      _isSearching = true;
    });

    String tokenOrId = rawCode.trim();
    if (tokenOrId.contains('|')) {
      final parts = tokenOrId.split('|');
      tokenOrId = parts.first;
    }

    await _lookupAndVerifyBooking(tokenOrId);
  }

  Future<void> _verifyManualToken() async {
    final rawInput = _tokenInputController.text.trim();
    if (rawInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a token or booking ID.')),
      );
      return;
    }

    setState(() => _isSearching = true);
    await _lookupAndVerifyBooking(rawInput);
  }

  Future<void> _lookupAndVerifyBooking(String query) async {
    final officer = SessionService.instance.currentUser;
    final officerCentreId = (officer?.centreId ?? 'CTR-01').trim().toLowerCase();

    // Strip '#' and whitespace for uniform comparison
    final cleanQuery = query.replaceAll('#', '').trim().toLowerCase();

    // 1. Fetch bookings for this officer's centre
    final centreBookings =
        await _database.bookingsForCentre(officer?.centreId ?? 'CTR-01');

    BookingModel? matchedBooking;

    for (final b in centreBookings) {
      final cleanToken = b.token.replaceAll('#', '').trim().toLowerCase();
      final cleanBookingId = b.bookingId.trim().toLowerCase();

      if (cleanToken == cleanQuery ||
          b.token.trim().toLowerCase() == query.trim().toLowerCase() ||
          cleanBookingId == cleanQuery) {
        matchedBooking = b;
        break;
      }
    }

    // 2. Check other centres to detect wrong-centre arrivals
    if (matchedBooking == null) {
      final allBookings = await _database.allBookings();
      for (final b in allBookings) {
        final cleanToken = b.token.replaceAll('#', '').trim().toLowerCase();
        final cleanBookingId = b.bookingId.trim().toLowerCase();

        if (cleanToken == cleanQuery ||
            b.token.trim().toLowerCase() == query.trim().toLowerCase() ||
            cleanBookingId == cleanQuery) {
          matchedBooking = b;
          break;
        }
      }

      if (matchedBooking != null &&
          matchedBooking.centreId.trim().toLowerCase() != officerCentreId) {
        if (!mounted) return;
        setState(() {
          _isSearching = false;
          _hasScanned = false;
        });
        _showErrorDialog(
          'Wrong Procurement Centre',
          'Token ${matchedBooking.token} is booked for ${matchedBooking.centreName} (${matchedBooking.centreId}), not your centre (${officer?.centreId ?? "CTR-01"}).',
        );
        return;
      }
    }

    if (!mounted) return;

    // 3. No match found
    if (matchedBooking == null) {
      setState(() {
        _isSearching = false;
        _hasScanned = false;
      });
      _showErrorDialog(
        'Token Not Found',
        'No appointment found matching "$query". Please check the token number.',
      );
      return;
    }

    setState(() => _isSearching = false);

    // 4. Open Gate Verification Screen (Farmer details + Mark Arrived button)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GateVerificationScreen(booking: matchedBooking!),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _hasScanned = false;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verify Farmer Slot'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.qr_code_scanner), text: 'Scan QR Code'),
            Tab(icon: Icon(Icons.dialpad), text: 'Enter Token No.'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQrScannerTab(),
          _buildManualEntryTab(),
        ],
      ),
    );
  }

  Widget _buildQrScannerTab() {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    final val = barcode.rawValue;
                    if (val != null && !_hasScanned) {
                      _processScannedData(val);
                      break;
                    }
                  }
                },
              ),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              if (_isSearching)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Point camera at the farmer\'s Token QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'The QR is available on the farmer\'s Booking Confirmation screen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flash_on, color: AppColors.primary),
                      onPressed: () => _scannerController.toggleTorch(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_android, color: AppColors.primary),
                      onPressed: () => _scannerController.switchCamera(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manual Token Verification',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter the sequence number or token ID given to the arriving farmer.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _tokenInputController,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Token / Sequence Number',
                    hintText: 'e.g. KST-1001 or 1001',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (_) => _verifyManualToken(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isSearching ? null : _verifyManualToken,
            icon: _isSearching
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(_isSearching ? 'Verifying...' : 'Verify Gate Arrival'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}