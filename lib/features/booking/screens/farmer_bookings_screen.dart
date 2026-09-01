import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

class FarmerBookingsScreen extends StatelessWidget {
  final String uid;

  const FarmerBookingsScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Procurement Bookings'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading bookings:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy_outlined,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No Procurement Bookings Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your scheduled crop procurement appointments will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          final bookingDocs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final aTimestamp = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
              final bTimestamp = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
              final aTime = aTimestamp?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bTime = bTimestamp?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bTime.compareTo(aTime);
            });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookingDocs.length,
            itemBuilder: (context, index) {
              final doc = bookingDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              final bookingId = doc.id;

              return _buildBookingCard(context, bookingId, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(
      BuildContext context, String bookingId, Map<String, dynamic> data) {
    final cropName = data['cropName'] ?? 'Unspecified Crop';
    final cropMsp = data['cropMsp'] ?? 0;
    final state = data['state'] ?? '';
    final district = data['district'] ?? '';
    final centerNames =
        List<String>.from(data['selectedCenterNames'] ?? ['Center N/A']);
    final timeWindow = data['timeWindow'] ?? 'N/A';
    final status = (data['status'] as String? ?? 'CONFIRMED').toUpperCase();
    final createdAtTimestamp = data['createdAt'] as Timestamp?;

    String formattedDate = 'N/A';
    if (createdAtTimestamp != null) {
      formattedDate = DateFormat('MMM dd, yyyy • hh:mm a')
          .format(createdAtTimestamp.toDate());
    }

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'CANCELLED':
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      case 'COMPLETED':
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'CONFIRMED':
      default:
        statusColor = Colors.green;
        statusIcon = Icons.verified_outlined;
        break;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: Icon(statusIcon, color: statusColor, size: 18),
                  label: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  side: BorderSide(color: statusColor.withValues(alpha: 0.3)),
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cropName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '₹$cropMsp / Qtl (MSP)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$district, $state',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.storefront_outlined,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Centers (${centerNames.length}): ${centerNames.join(', ')}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_outlined,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Time Slot: $timeWindow',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
            if (status == 'CONFIRMED') ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _confirmCancelBooking(context, bookingId),
                  icon: const Icon(Icons.cancel, color: Colors.red, size: 18),
                  label: const Text(
                    'Cancel Booking',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancelBooking(
      BuildContext context, String bookingId) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text(
            'Are you sure you want to cancel this procurement slot booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'CANCELLED'});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}