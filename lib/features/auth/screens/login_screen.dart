import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../farmer_home/screens/farmer_home_screen.dart';
import '../../officer/screens/officer_dashboard_screen.dart';
import '../../../services/auth_service.dart';
import '../../../services/session_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isFarmer;
  const LoginScreen({super.key, required this.isFarmer});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isOtpSent = false;
  bool _isLoading = false;
  final TextEditingController _idController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    _idController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFarmer ? 'Login with Aadhaar' : 'Officer Login'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isOtpSent ? _buildOtpView() : _buildLoginView(),
        ),
      ),
    );
  }

  Widget _buildLoginView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Aadhaar / Badge Icon Header
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            widget.isFarmer ? Icons.fingerprint : Icons.security,
            size: 50,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: _idController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.isFarmer ? 'Enter Aadhaar Number' : 'Enter Officer ID',
            hintText: widget.isFarmer ? 'XXXX XXXX XXXX' : 'OPF102',
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {
            if (_idController.text.isNotEmpty) {
              setState(() => _isOtpSent = true);
            }
          },
          child: const Text('Send OTP'),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegistrationScreen(isFarmer: widget.isFarmer),
            ),
          ),
          child: const Text('Create an account'),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline, size: 16, color: AppColors.textSecondary),
            SizedBox(width: 6),
            Text(
              'Your data is safe with us',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Verify OTP',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter the 6 digit OTP sent to\n+91 98XXXXX121',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        // 6-Digit Pin Input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 45,
              height: 55,
              child: TextField(
                controller: _otpControllers[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        TextButton(
          onPressed: () {},
          child: const Text('Resend OTP in 00:30'),
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          // Changed to async to support database lookup
          onPressed: _isLoading ? null : () async {
            final enteredId = _idController.text.trim();
            final otp = _otpControllers.map((controller) => controller.text).join();
            if (enteredId.isEmpty || otp.length != 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter your ID and 6-digit OTP.')),
              );
              return;
            }
            setState(() => _isLoading = true);

            final user = await AuthService().findUserForLogin(
              identifier: enteredId,
              role: widget.isFarmer ? UserRole.farmer : UserRole.officer,
            );

            if (!mounted) return;
            setState(() => _isLoading = false);

            if (user != null) {
              SessionService.instance.start(user);
              final nextPage = user.role == 'farmer'
                  ? const FarmerHomeScreen()
                  : const OfficerDashboardScreen();

              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => nextPage),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ID not found in local database.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Verify'),
        ),
      ],
    );
  }
}