import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  final bool isFarmer;

  const RegistrationScreen({super.key, this.isFarmer = true});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  bool _isFarmer = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _isFarmer = widget.isFarmer;
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _phoneController,
      _aadhaarController,
      _stateController,
      _districtController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final phone = _phoneController.text.trim();
    final identity = _aadhaarController.text.trim();
    final uid = identity;
    try {
      await AuthService().registerUser(
        uid: uid,
        name: _nameController.text.trim(),
        phoneNumber: phone,
        role: _isFarmer ? UserRole.farmer : UserRole.officer,
        aadhaarNumber: _isFarmer ? identity : null,
        state: _stateController.text.trim(),
        district: _districtController.text.trim(),
        farmerId: _isFarmer ? 'FMR_$identity' : null,
        officerId: _isFarmer ? null : identity,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please log in.')),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration could not be completed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_add_alt_1, size: 44, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              const Text(
                'Join KisanSetu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Create your local account to continue.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<bool>(
                initialValue: _isFarmer,
                decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.badge_outlined)),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Farmer')),
                  DropdownMenuItem(value: false, child: Text('Officer')),
                ],
                onChanged: (value) => setState(() => _isFarmer = value ?? true),
              ),
              const SizedBox(height: 14),
              _field(_nameController, 'Full Name', Icons.person_outline),
              _field(_phoneController, 'Phone Number', Icons.phone_outlined, keyboard: TextInputType.phone),
              _field(_aadhaarController, _isFarmer ? 'Aadhaar Number' : 'Officer ID', Icons.fingerprint, keyboard: TextInputType.text),
              _field(_stateController, 'State', Icons.map_outlined),
              _field(_districtController, 'District', Icons.location_city_outlined),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isSaving ? null : _register,
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
