import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../../services/local_database_service.dart';
import 'otp_verification_screen.dart';

class OfficerAuthScreen extends StatefulWidget {
  const OfficerAuthScreen({super.key});

  @override
  State<OfficerAuthScreen> createState() => _OfficerAuthScreenState();
}

class _OfficerAuthScreenState extends State<OfficerAuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _database = IsarDatabaseService();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _officerIdController = TextEditingController();

  String _selectedState = 'Madhya Pradesh';
  String _selectedDistrict = 'Shivpuri';
  String _selectedCentreId = 'CTR_SHIV_01';

  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _officerIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      await IsarDatabaseService.initialize();

      final officerId = _officerIdController.text.trim();
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();

      // Check if officer ID already exists
      final existing = await _database.findOfficerById(officerId);
      if (existing != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An officer with this Officer ID is already registered. Please log in.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => isLogin = true);
        return;
      }

      final newOfficer = UserModel(
        uid: 'officer_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        phoneNumber: phone,
        role: 'officer',
        officerId: officerId,
        centreId: _selectedCentreId,
        state: _selectedState,
        district: _selectedDistrict,
        createdAt: DateTime.now(),
      );

      await _database.saveUser(newOfficer);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Officer registered successfully! Please login with your Officer ID.',
          ),
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
      final officerId = _officerIdController.text.trim();
      final matchedOfficer = await _database.findOfficerById(officerId);

      if (!mounted) return;

      if (matchedOfficer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No officer found with this ID. Please check or register first.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: matchedOfficer.phoneNumber,
            targetRole: 'officer',
            matchedUser: matchedOfficer,
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
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isLogin ? 'Procurement Officer Login' : 'Officer Registration',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isLogin
                      ? 'Enter your Officer ID to authenticate'
                      : 'Register officer credentials and centre assignment',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Tab Switcher
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
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
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
                              color: !isLogin
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !isLogin
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
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
                      labelText: 'Officer Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter full name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().length < 10)
                            ? 'Enter valid phone number'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Madhya Pradesh',
                        child: Text('Madhya Pradesh'),
                      ),
                      DropdownMenuItem(
                        value: 'Punjab',
                        child: Text('Punjab'),
                      ),
                      DropdownMenuItem(
                        value: 'Haryana',
                        child: Text('Haryana'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedState = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedDistrict,
                    decoration: const InputDecoration(
                      labelText: 'District',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Shivpuri',
                        child: Text('Shivpuri'),
                      ),
                      DropdownMenuItem(
                        value: 'Gwalior',
                        child: Text('Gwalior'),
                      ),
                      DropdownMenuItem(
                        value: 'Indore',
                        child: Text('Indore'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedDistrict = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCentreId,
                    decoration: const InputDecoration(
                      labelText: 'Assigned Procurement Centre',
                      prefixIcon: Icon(Icons.store_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CTR_SHIV_01',
                        child: Text(
                          'Shivpuri Procurement Center (CTR_SHIV_01)',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'CTR_KOL_02',
                        child: Text('Kolaras Krishi Mandi (CTR_KOL_02)'),
                      ),
                      DropdownMenuItem(
                        value: 'CTR_POH_03',
                        child: Text(
                          'Pohari Grain Procurement Hub (CTR_POH_03)',
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedCentreId = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _officerIdController,
                  decoration: const InputDecoration(
                    labelText: 'Officer ID (e.g. OFF-101)',
                    hintText: 'Enter assigned Officer ID',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Enter your Officer ID'
                          : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : (isLogin ? _handleLoginSendOtp : _handleRegister),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(isLogin ? 'Send OTP' : 'Register'),
                ),
                const SizedBox(height: 16),
                Text(
                  isLogin
                      ? 'We will send a 6-digit verification code to your registered mobile'
                      : 'Officers are verified against central food & civil supply registries',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}