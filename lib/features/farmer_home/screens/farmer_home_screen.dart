import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../booking/screens/book_slot_step1_crop_screen.dart';
import '../../booking/screens/farmer_bookings_screen.dart';
import '../../booking/screens/procurement_status_screen.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../payment/screens/payment_status_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';
import '../../../models/booking_model.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      FarmerBookingsScreen(uid: SessionService.instance.currentUser?.farmerId ?? ''),
      const NotificationsScreen(),
      const ProfileScreen(isFarmer: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'KisanSetu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen(isFarmer: true)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              setState(() => _currentNavIndex = 2);
            },
          ),
        ],
      ),
      body: pages[_currentNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Namaste, ${SessionService.instance.currentUser?.name ?? 'Farmer'}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Farmer ID: ${SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid ?? 'Not available'}',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildNextProcurement(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Best Deals & Upcoming Deals',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentOrange,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View All Deals >',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildBestDeal(),
          const SizedBox(height: 24),
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAccessTile(
                icon: Icons.calendar_month_outlined,
                label: 'Book Slot',
                bgColor: const Color(0xFFE8F5E9),
                iconColor: AppColors.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookSlotStep1CropScreen(),
                    ),
                  );
                },
              ),
              _buildQuickAccessTile(
                icon: Icons.assignment_outlined,
                label: 'My Bookings',
                bgColor: const Color(0xFFFFF3E0),
                iconColor: Colors.orange.shade800,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmerBookingsScreen(
                        uid: SessionService.instance.currentUser?.farmerId ?? '',
                      ),
                    ),
                  );
                },
              ),
              _buildQuickAccessTile(
                icon: Icons.timelapse_outlined,
                label: 'Status',
                bgColor: const Color(0xFFE1F5FE),
                iconColor: Colors.lightBlue.shade800,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProcurementStatusScreen(),
                    ),
                  );
                },
              ),
              _buildQuickAccessTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Payments',
                bgColor: const Color(0xFFF3E5F5),
                iconColor: Colors.purple.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentStatusScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextProcurement() {
    final farmerId = SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid;
    return FutureBuilder<List<BookingModel>>(
      future: farmerId == null ? Future.value([]) : IsarDatabaseService().farmerBookings(farmerId),
      builder: (context, snapshot) {
        final bookings = (snapshot.data ?? []).where((booking) => booking.bookingDate.isAfter(DateTime.now())).toList();
        final booking = bookings.isEmpty ? null : bookings.first;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Next Procurement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            Center(child: Text(booking == null ? 'No upcoming procurements' : '${booking.crop} at ${booking.centreName}\n${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} • ${booking.slotTime}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary))),
          ]),
        );
      },
    );
  }

  Widget _buildBestDeal() => FutureBuilder<List<BookingModel>>(
        future: IsarDatabaseService().allBookings(),
        builder: (context, snapshot) {
          final booking = (snapshot.data ?? []).isEmpty ? null : snapshot.data!.first;
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.accentOrange, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Text(booking == null ? 'No active offers' : '${booking.crop}\n${booking.centreName}\n${booking.slotTime}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          );
        },
      );

  Widget _buildQuickAccessTile({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}