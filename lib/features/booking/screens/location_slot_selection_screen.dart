import 'package:flutter/material.dart';
import 'booking_flow_screen.dart';

class LocationSlotSelectionScreen extends StatelessWidget {
  final String uid;
  final String farmerName;

  const LocationSlotSelectionScreen({
    super.key,
    required this.uid,
    required this.farmerName,
  });

  @override
  Widget build(BuildContext context) {
    return const BookingFlowScreen(crop: 'Paddy', quantityQuintal: 1);
  }
}
