import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../../services/session_service.dart';
import '../../farmer_home/screens/farmer_home_dashboard.dart';
import '../../officer/screens/officer_dashboard_screen.dart';
import '../../../models/core_models.dart';
import 'package:provider/provider.dart';
import '../../../services/procurement_repository.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String targetRole; // 'farmer' or 'officer'
  final UserModel? matchedUser;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.targetRole,
    this.matchedUser,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

Future<void> _verifyOtp() async {
  final otp = _controllers.map((c) => c.text).join();
  if (otp.length != 6) return;

  setState(() => _isVerifying = true);

  if (widget.matchedUser != null) {
    await SessionService.instance.start(widget.matchedUser!);

    // Keep ProcurementRepository in sync with the logged-in user
    if (mounted) {
      final repo = Provider.of<ProcurementRepository>(context, listen: false);
        repo.setCurrentUser(
          AppUser(
            uid: widget.matchedUser!.uid,
            fullName: widget.matchedUser!.name,
            phoneNumber: widget.matchedUser!.phoneNumber,
            role: widget.targetRole == 'farmer' ? UserRole.farmer : UserRole.officer,
            aadhaarNumber: widget.matchedUser!.farmerId,
            state: widget.matchedUser!.state ?? 'Madhya Pradesh',
            district: widget.matchedUser!.district ?? 'Shivpuri',
          ),
        );
    }
  }

  setState(() => _isVerifying = false);

  if (!mounted) return;

  if (widget.targetRole == 'farmer') {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const FarmerHomeDashboard()),
      (route) => false,
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OfficerDashboardScreen()),
      (route) => false,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('Verify OTP', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Enter the 6 digit OTP sent to\n${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    height: 52,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_controllers.every((c) => c.text.isNotEmpty)) {
                          _verifyOtp();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Resend OTP in ', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  Text('00:30', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isVerifying ? null : _verifyOtp,
                child: _isVerifying
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}