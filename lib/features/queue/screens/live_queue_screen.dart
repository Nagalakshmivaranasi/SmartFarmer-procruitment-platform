import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../booking/screens/book_slot_step1_crop_screen.dart';

class LiveQueueScreen extends StatefulWidget {
  const LiveQueueScreen({super.key});

  @override
  State<LiveQueueScreen> createState() => _LiveQueueScreenState();
}

class _LiveQueueScreenState extends State<LiveQueueScreen> {
  final _database = IsarDatabaseService();
  BookingModel? _activeBooking;
  int _farmersAhead = 0;
  int _estimatedWaitMinutes = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQueueData();
  }

  Future<void> _loadQueueData() async {
    final user = SessionService.instance.currentUser;
    if (user != null) {
      final farmerId = user.farmerId ?? user.uid;
      final activeList = await _database.activeBookingsForFarmer(farmerId);

      if (activeList.isNotEmpty) {
        final booking = activeList.first;
        final position = await _database.queuePosition(booking);

        setState(() {
          _activeBooking = booking;
          _farmersAhead = position > 0 ? position - 1 : 0;
          _estimatedWaitMinutes = _farmersAhead * 15;
          _loading = false;
        });
        return;
      }
    }

    setState(() {
      _activeBooking = null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Today's Slots"),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _activeBooking == null
              ? _buildNoBookingView()
              : RefreshIndicator(
                  onRefresh: _loadQueueData,
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSlotHeroCard(),
                        const SizedBox(height: 16),
                        _buildQueueMetricsCard(),
                        const SizedBox(height: 24),
                        _buildCenterInfoCard(),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _loadQueueData,
                            icon: const Icon(Icons.sync, color: Colors.white),
                            label: const Text('Refresh Queue Status'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildNoBookingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No Active Queue For Today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You do not have any procurement slots scheduled for today. Book a slot to join the live gate queue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BookSlotStep1CropScreen()),
                );
              },
              child: const Text('Book Slot Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Slot',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      _activeBooking!.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _activeBooking!.token,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Scheduled Window: ${_activeBooking!.slotTime}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueMetricsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _metricRow(
            icon: Icons.people_outline,
            label: 'Farmers Ahead in Slot',
            value: '$_farmersAhead',
            valueColor: _farmersAhead == 0 ? AppColors.primary : AppColors.textPrimary,
          ),
          const Divider(height: 24, color: AppColors.border),
          _metricRow(
            icon: Icons.access_time,
            label: 'Estimated Waiting Time',
            value: _farmersAhead == 0 ? 'Ready for Entry' : '$_estimatedWaitMinutes mins',
            valueColor: _farmersAhead == 0 ? AppColors.primary : AppColors.statusOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildCenterInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Centre Verification Note',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please present your token at ${_activeBooking!.centreName}. Have your physical produce and registered identification ready for evaluation.',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _metricRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}