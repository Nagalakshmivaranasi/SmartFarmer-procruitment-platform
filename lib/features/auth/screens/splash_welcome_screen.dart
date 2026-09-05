// lib/features/auth/screens/splash_welcome_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'farmer_auth_screen.dart';
import 'officer_auth_screen.dart';

class SplashWelcomeScreen extends StatelessWidget {
  const SplashWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Brand Identity & Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.eco, color: AppColors.primary, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'KisanSetu',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose your role to continue',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              ),
              const Spacer(),
              // Central Logo Illustrated Badge
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 3),
                ),
                child: const Icon(Icons.agriculture, size: 80, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Smart Farmer\nProcurement Platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'किसान का साथी, हर कदम पर साथ',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Spacer(),

              // Interactive Role Selection Container 1: Farmer
              _RoleCard(
                title: 'Farmer',
                subtitle: 'किसान',
                icon: Icons.person_outline,
                iconBgColor: AppColors.mintGreen,
                iconColor: AppColors.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FarmerAuthScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Interactive Role Selection Container 2: Officer
              _RoleCard(
                title: 'Officer',
                subtitle: 'अधिकारी',
                icon: Icons.shield_outlined,
                iconBgColor: const Color(0xFFE3F2FD),
                iconColor: AppColors.statusInfo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OfficerAuthScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Security Seal
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, size: 14, color: AppColors.statusSuccess),
                  SizedBox(width: 4),
                  Text(
                    'Secured & easy to use',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}