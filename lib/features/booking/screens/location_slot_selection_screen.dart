import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_seed_service.dart';
import '../../../core/theme/app_theme.dart';
import 'farmer_bookings_screen.dart';

class LocationSlotSelectionScreen extends StatefulWidget {
  final String uid;
  final String farmerName;

  const LocationSlotSelectionScreen({
    super.key,
    required this.uid,
    required this.farmerName,
  });

  @override
  State<LocationSlotSelectionScreen> createState() =>
      _LocationSlotSelectionScreenState();
}

class _LocationSlotSelectionScreenState
    extends State<LocationSlotSelectionScreen> {
  final FirebaseSeedService _seedService = FirebaseSeedService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _selectedCrop;
  Map<String, dynamic>? _selectedStateDoc;
  Map<String, dynamic>? _selectedDistrict;
  final Set<String> _selectedCenterIds = {};
  Map<String, dynamic>? _selectedSlot;

  bool _isSeeding = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Procurement Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'My Bookings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmerBookingsScreen(uid: widget.uid),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Seed Database',
            onPressed: _isSeeding ? null : _runDatabaseSeed,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('locations').snapshots(),
        builder: (context, locationSnapshot) {
          if (locationSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!locationSnapshot.hasData || locationSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.dataset_linked_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No location or crop data found in database.',
                    style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isSeeding ? null : _runDatabaseSeed,
                    icon: _isSeeding
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.cloud_upload),
                    label: const Text('Populate Database Now'),
                  ),
                ],
              ),
            );
          }

          final stateDocs = locationSnapshot.data!.docs;
          _selectedStateDoc ??= stateDocs.first.data() as Map<String, dynamic>;

          final districts = List<Map<String, dynamic>>.from(
              _selectedStateDoc!['districts'] ?? []);
          _selectedDistrict ??= districts.isNotEmpty ? districts.first : null;

          final centers = List<Map<String, dynamic>>.from(
              _selectedDistrict?['procurementCenters'] ?? []);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Select Crop for Procurement',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('crops').snapshots(),
                    builder: (context, cropSnapshot) {
                      if (!cropSnapshot.hasData) {
                        return const LinearProgressIndicator();
                      }

                      final cropDocs = cropSnapshot.data!.docs;
                      if (cropDocs.isEmpty) {
                        return const Text('No crops populated yet. Click seed above.');
                      }

                      _selectedCrop ??=
                          cropDocs.first.data() as Map<String, dynamic>;

                      return DropdownButtonFormField<Map<String, dynamic>>(
                        initialValue: _selectedCrop,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        items: cropDocs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: data,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['name'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'MSP: ₹${data['minSupportPricePerQuintal']}/Qtl',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newCrop) {
                          if (newCrop == null) return;
                          setState(() {
                            _selectedCrop = newCrop;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '2. Select State',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    initialValue: _selectedStateDoc,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: stateDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: data,
                        child: Text(
                          data['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (newState) {
                      if (newState == null) return;
                      setState(() {
                        _selectedStateDoc = newState;
                        final newDistricts = List<Map<String, dynamic>>.from(
                            newState['districts'] ?? []);
                        _selectedDistrict =
                            newDistricts.isNotEmpty ? newDistricts.first : null;
                        _selectedCenterIds.clear();
                        _selectedSlot = null;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '3. Select District',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    initialValue: _selectedDistrict,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: districts.map((district) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: district,
                        child: Text(
                          district['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (newDistrict) {
                      if (newDistrict == null) return;
                      setState(() {
                        _selectedDistrict = newDistrict;
                        _selectedCenterIds.clear();
                        _selectedSlot = null;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '4. Select Procurement Centers in ${_selectedDistrict?['name'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${centers.length} Centers Available. Select one or more:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      final center = centers[index];
                      final centerId = center['id'] as String;
                      final isChecked = _selectedCenterIds.contains(centerId);

                      return Card(
                        elevation: isChecked ? 2 : 1,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isChecked
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: isChecked ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isChecked,
                          activeColor: Colors.green,
                          title: Text(
                            center['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '📍 ${center['address']}\n📦 Capacity: ${center['capacityQuintals']} Quintals',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                height: 1.3,
                              ),
                            ),
                          ),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedCenterIds.add(centerId);
                              } else {
                                _selectedCenterIds.remove(centerId);
                              }
                              _selectedSlot = null;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedCenterIds.isNotEmpty) ...[
                    const Text(
                      '5. Select Time Window Slot',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAvailableSlotsList(centers),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: (_selectedCrop != null &&
                              _selectedCenterIds.isNotEmpty &&
                              _selectedSlot != null &&
                              !_isSubmitting)
                          ? () => _saveBookingToFirestore(centers)
                          : null,
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Confirm Booking & Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailableSlotsList(List<Map<String, dynamic>> centers) {
    final selectedCenterDocs = centers
        .where((c) => _selectedCenterIds.contains(c['id']))
        .toList();

    List<Map<String, dynamic>> availableSlots = [];
    for (var center in selectedCenterDocs) {
      final slots =
          List<Map<String, dynamic>>.from(center['availableSlots'] ?? []);
      for (var s in slots) {
        if (!availableSlots.any((existing) => existing['id'] == s['id'])) {
          availableSlots.add(s);
        }
      }
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableSlots.map((slot) {
        final isSelected = _selectedSlot?['id'] == slot['id'];
        return ChoiceChip(
          label: Text(slot['timeWindow'] ?? ''),
          selected: isSelected,
          selectedColor: Colors.green.shade100,
          labelStyle: TextStyle(
            color: isSelected ? Colors.green.shade900 : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            setState(() {
              _selectedSlot = selected ? slot : null;
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _runDatabaseSeed() async {
    setState(() => _isSeeding = true);
    try {
      await _seedService.seedCompleteLocationAndCropData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Successfully populated Crops & Location data into Firestore!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seeding failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  Future<void> _saveBookingToFirestore(
      List<Map<String, dynamic>> allCenters) async {
    setState(() => _isSubmitting = true);
    try {
      final selectedCenterNames = allCenters
          .where((c) => _selectedCenterIds.contains(c['id']))
          .map((c) => c['name'] as String)
          .toList();

      await _firestore.collection('bookings').add({
        'uid': widget.uid,
        'farmerName': widget.farmerName,
        'cropName': _selectedCrop!['name'],
        'cropMsp': _selectedCrop!['minSupportPricePerQuintal'],
        'state': _selectedStateDoc!['name'],
        'district': _selectedDistrict!['name'],
        'selectedCenterIds': _selectedCenterIds.toList(),
        'selectedCenterNames': selectedCenterNames,
        'slotId': _selectedSlot!['id'],
        'timeWindow': _selectedSlot!['timeWindow'],
        'status': 'CONFIRMED',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking Confirmed for ${_selectedCrop!['name']} across ${_selectedCenterIds.length} center(s)!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate straight to Bookings History Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerBookingsScreen(uid: widget.uid),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}