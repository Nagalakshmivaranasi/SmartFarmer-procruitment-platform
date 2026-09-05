import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../../services/local_database_service.dart';
import 'otp_verification_screen.dart';

class FarmerAuthScreen extends StatefulWidget {
  const FarmerAuthScreen({super.key});

  @override
  State<FarmerAuthScreen> createState() => _FarmerAuthScreenState();
}

class _FarmerAuthScreenState extends State<FarmerAuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _database = IsarDatabaseService();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadhaarController = TextEditingController();

  String? _selectedState = 'Madhya Pradesh';
  String? _selectedDistrict = 'Shivpuri';
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final aadhaar = _aadhaarController.text.trim();
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();

      await IsarDatabaseService.initialize();

      final existing = await _database.findFarmerByIdentity(aadhaar);
      if (existing != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A farmer with this Aadhaar number already exists. Please log in.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => isLogin = true);
        return;
      }

      final newFarmer = UserModel(
        uid: 'farmer_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        phoneNumber: phone,
        role: 'farmer',
        farmerId: aadhaar,
        state: _selectedState ?? 'Madhya Pradesh',
        district: _selectedDistrict ?? 'Shivpuri',
        createdAt: DateTime.now(),
      );

      await _database.saveUser(newFarmer);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login with your Aadhaar number.'),
          backgroundColor: AppColors.primary,
        ),
      );

      setState(() {
        isLogin = true;
        _nameController.clear();
        _phoneController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleLoginSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      await IsarDatabaseService.initialize();
      final aadhaar = _aadhaarController.text.trim();
      final matchedFarmer = await _database.findFarmerByIdentity(aadhaar);

      if (!mounted) return;

      if (matchedFarmer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No farmer found matching this Aadhaar number. Please register first.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: matchedFarmer.phoneNumber,
            targetRole: 'farmer',
            matchedUser: matchedFarmer,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.fingerprint, size: 40, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  isLogin ? 'Login with Aadhaar' : 'Farmer Registration',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  isLogin
                      ? 'Enter your registered Aadhaar to receive OTP'
                      : 'Fill details to create your digital Kisan identity',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (!isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name (पूरा नाम)',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter full name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (मोबाइल नंबर)',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().length < 10) ? 'Enter valid 10-digit phone number' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'State (राज्य)',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Madhya Pradesh', child: Text('Madhya Pradesh')),
                      DropdownMenuItem(value: 'Punjab', child: Text('Punjab')),
                      DropdownMenuItem(value: 'Haryana', child: Text('Haryana')),
                    ],
                    onChanged: (val) => setState(() => _selectedState = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedDistrict,
                    decoration: const InputDecoration(
                      labelText: 'District (जिला)',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Shivpuri', child: Text('Shivpuri')),
                      DropdownMenuItem(value: 'Gwalior', child: Text('Gwalior')),
                      DropdownMenuItem(value: 'Indore', child: Text('Indore')),
                    ],
                    onChanged: (val) => setState(() => _selectedDistrict = val),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _aadhaarController,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  decoration: const InputDecoration(
                    labelText: 'Aadhaar Number (आधार नंबर)',
                    hintText: '12-digit Aadhaar',
                    prefixIcon: Icon(Icons.badge_outlined),
                    counterText: '',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().length != 12) ? 'Enter valid 12-digit Aadhaar' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isProcessing ? null : (isLogin ? _handleLoginSendOtp : _handleRegister),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(isLogin ? 'Send OTP' : 'Register'),
                ),
                const SizedBox(height: 16),
                Text(
                  isLogin
                      ? 'We will send a 6-digit OTP to your registered phone number'
                      : 'Account information is secured locally in the procurement system',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}