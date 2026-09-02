import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/session_service.dart';
import '../../auth/screens/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isFarmer;

  const ProfileScreen({super.key, this.isFarmer = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final user = SessionService.instance.currentUser;
    final name = user?.name ?? 'Profile';
    final id = '${widget.isFarmer ? 'Farmer' : 'Officer'} ID: ${user?.farmerId ?? user?.officerId ?? user?.uid ?? 'Not available'}';
    final phone = user?.phoneNumber ?? 'Not available';
    final address = '${user?.district ?? 'District unavailable'}, ${user?.state ?? 'State unavailable'}';
    final aadhaar = user?.aadhaarNumber ?? 'Not available';
    const bank = 'Not available';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isFarmer ? 'My Profile' : 'Officer Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 34, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          id,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailCard('Full Name', name),
            _buildDetailCard('Phone Number', phone),
            _buildDetailCard('Address Details', address),
            _buildDetailCard('Aadhaar Number', aadhaar),
            _buildDetailCard('Bank Account Details', bank),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_outlined, color: AppColors.textPrimary),
              title: const Text(
                'Language',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                underline: const SizedBox(),
                items: <String>['English', 'Hindi (हिंदी)', 'Telugu (తెలుగు)']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14, color: AppColors.primary),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {},
            ),
            const Divider(height: 24),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: Colors.red.shade700,
              iconColor: Colors.red.shade700,
              onTap: () async {
                await SessionService.instance.clear();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color titleColor = AppColors.textPrimary,
    Color iconColor = AppColors.textPrimary,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      onTap: onTap,
    );
  }
}