import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// Farmer Flow Screens
import '../booking/screens/book_slot_step1_crop_screen.dart';
import '../booking/screens/booking_confirmed_screen.dart';
import '../booking/screens/deal_lock_screen.dart';
import '../booking/screens/quality_report_screen.dart';
import '../farmer_home/screens/farmer_home_screen.dart';
import '../queue/screens/live_queue_screen.dart';

// Officer Flow Screens
import '../officer/screens/live_procurement_monitor_screen.dart';
import '../officer/screens/officer_dashboard_screen.dart';
import '../officer/screens/quality_inspection_form_screen.dart';
import '../officer/screens/slot_verification_screen.dart';
import '../booking/screens/location_slot_selection_screen.dart';
import '../../services/session_service.dart';
class TestLauncherScreen extends StatelessWidget {
  const TestLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('KisanSetu - Screen Test Bench'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Farmer Persona Section
            _buildSectionHeader(
              title: 'Persona 1: Farmer Experience',
              subtitle: 'End-to-end procurement & slot booking journey',
              color: AppColors.primary,
            ),
            const SizedBox(height: 10),
            _buildTestTile(
              context,
              title: '1. Farmer Home Screen',
              subtitle: 'Main landing page with active slots & quick actions',
              target: const FarmerHomeScreen(),
            ),
            _buildTestTile(
              context,
              title: '2. Book Slot (Step 1)',
              subtitle: 'Start 6-step wizard (Crop & Quantity)',
              target: const BookSlotStep1CropScreen(),
            ),
            _buildTestTile(
  context,
  title: 'State & District Slot Selector',
  subtitle: 'Cascading dropdowns with Green/Red/Grey slots',
  target: LocationSlotSelectionScreen(
  uid: SessionService.instance.currentUser?.farmerId ?? '',
  farmerName: SessionService.instance.currentUser?.name ?? '',
)
),
            _buildTestTile(
              context,
              title: '3. Booking Confirmation',
              subtitle: 'Token QR Code & appointment receipt',
              target: const BookingConfirmedScreen(),
            ),
            _buildTestTile(
              context,
              title: '4. Live Queue Tracker',
              subtitle: 'Real-time vehicle position & process stepper',
              target: const LiveQueueScreen(),
            ),
            _buildTestTile(
              context,
              title: '5. Quality Assessment Report',
              subtitle: 'Moisture breakdown & grade status',
              target: const QualityReportScreen(),
            ),
            _buildTestTile(
              context,
              title: '6. Deal Lock & Payout',
              subtitle: 'Final pricing breakdown & payment confirmation',
              target: const DealLockScreen(),
            ),

            const SizedBox(height: 24),

            // Procurement Officer Persona Section
            _buildSectionHeader(
              title: 'Persona 2: Center Officer',
              subtitle: 'Center queue management & quality inspection',
              color: Colors.blue.shade800,
            ),
            const SizedBox(height: 10),
            _buildTestTile(
              context,
              title: '1. Officer Dashboard',
              subtitle: 'Daily center metrics & quick QR scanner launcher',
              target: const OfficerDashboardScreen(),
            ),
            _buildTestTile(
              context,
              title: '2. Token / QR Verification',
              subtitle: 'Scan farmer token QR or enter ID manually',
              target: const SlotVerificationScreen(),
            ),
            _buildTestTile(
              context,
              title: '3. Quality Inspection Form',
              subtitle: 'Input moisture %, foreign matter & assign grade',
              target: const QualityInspectionFormScreen(),
            ),
            _buildTestTile(
              context,
              title: '4. Live Procurement Monitor',
              subtitle: 'Live center vehicle queue & status tracker',
              target: const LiveProcurementMonitorScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget target,
  }) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
        },
      ),
    );
  }
}