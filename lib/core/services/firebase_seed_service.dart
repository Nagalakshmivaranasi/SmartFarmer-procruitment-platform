import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedCompleteLocationAndCropData() async {
    final batch = _firestore.batch();

    // 1. Seed Top 5 South Indian Crops
    final crops = [
      {
        'id': 'crop_paddy',
        'name': 'Paddy (Rice)',
        'localNames': {'te': 'వరి (Paddy)', 'ta': 'நெல் (Nelm)'},
        'category': 'Cereals',
        'minSupportPricePerQuintal': 2183,
        'maxMoistureLimit': 17.0,
      },
      {
        'id': 'crop_maize',
        'name': 'Maize (Corn)',
        'localNames': {'te': 'జొన్న / మొక్కజొన్న', 'ta': 'மக்காச்சோளம்'},
        'category': 'Coarse Cereals',
        'minSupportPricePerQuintal': 2090,
        'maxMoistureLimit': 14.0,
      },
      {
        'id': 'crop_redgram',
        'name': 'Red Gram (Pigeon Pea / Toor Dal)',
        'localNames': {'te': 'కందులు', 'ta': 'துவரம் பருப்பு'},
        'category': 'Pulses',
        'minSupportPricePerQuintal': 7000,
        'maxMoistureLimit': 12.0,
      },
      {
        'id': 'crop_groundnut',
        'name': 'Groundnut (Peanut)',
        'localNames': {'te': 'వేరుశెనగ', 'ta': 'நிலக்கடலை'},
        'category': 'Oilseeds',
        'minSupportPricePerQuintal': 6377,
        'maxMoistureLimit': 10.0,
      },
      {
        'id': 'crop_cotton',
        'name': 'Cotton (Medium Staple)',
        'localNames': {'te': 'పత్తి', 'ta': 'பருத்தி'},
        'category': 'Commercial Crops',
        'minSupportPricePerQuintal': 6620,
        'maxMoistureLimit': 8.0,
      },
    ];

    for (var crop in crops) {
      final docRef = _firestore.collection('crops').doc(crop['id'] as String);
      batch.set(docRef, crop);
    }

    // Commit batch write for crops
    await batch.commit();

    // 2. Seed Location Data (Andhra Pradesh, Telangana, Tamil Nadu)
    await seedLocationData();
  }

  Future<void> seedLocationData() async {
    final locationsRef = _firestore.collection('locations');

    await locationsRef.doc('andhra_pradesh').set({
      'name': 'Andhra Pradesh',
      'districts': [
        _buildDistrict('Visakhapatnam', 'AP_VSKP'),
        _buildDistrict('Vijayawada (NTR)', 'AP_NTR'),
        _buildDistrict('Guntur', 'AP_GNT'),
        _buildDistrict('Kurnool', 'AP_KRN'),
        _buildDistrict('East Godavari', 'AP_EG'),
        _buildDistrict('Chittoor', 'AP_CTR'),
        _buildDistrict('Anantapur', 'AP_ATP'),
      ]
    });

    await locationsRef.doc('telangana').set({
      'name': 'Telangana',
      'districts': [
        _buildDistrict('Hyderabad', 'TS_HYD'),
        _buildDistrict('Warangal', 'TS_WGL'),
        _buildDistrict('Nizamabad', 'TS_NZB'),
        _buildDistrict('Karimnagar', 'TS_KRM'),
        _buildDistrict('Khammam', 'TS_KHM'),
        _buildDistrict('Nalgonda', 'TS_NLG'),
        _buildDistrict('Mahbubnagar', 'TS_MBN'),
      ]
    });

    await locationsRef.doc('tamil_nadu').set({
      'name': 'Tamil Nadu',
      'districts': [
        _buildDistrict('Thanjavur', 'TN_TNJ'),
        _buildDistrict('Madurai', 'TN_MDU'),
        _buildDistrict('Coimbatore', 'TN_CBE'),
        _buildDistrict('Tiruchirappalli', 'TN_TPJ'),
        _buildDistrict('Salem', 'TN_SLM'),
        _buildDistrict('Tirunelveli', 'TN_TNV'),
        _buildDistrict('Erode', 'TN_ERD'),
      ]
    });
  }

  Map<String, dynamic> _buildDistrict(String districtName, String code) {
    return {
      'name': districtName,
      'procurementCenters': [
        {
          'id': '${code}_PC1',
          'name': '$districtName Main Agriculture Marketing Hub',
          'address': 'Gate 1, APMC Yard, $districtName',
          'capacityQuintals': 500,
          'availableSlots': [
            {'id': '${code}_PC1_S1', 'timeWindow': '08:00 AM - 10:00 AM', 'status': 'available'},
            {'id': '${code}_PC1_S2', 'timeWindow': '10:00 AM - 12:00 PM', 'status': 'available'},
            {'id': '${code}_PC1_S3', 'timeWindow': '02:00 PM - 04:00 PM', 'status': 'available'},
          ]
        },
        {
          'id': '${code}_PC2',
          'name': '$districtName Farmers Cooperative Society',
          'address': 'Station Road, $districtName',
          'capacityQuintals': 350,
          'availableSlots': [
            {'id': '${code}_PC2_S1', 'timeWindow': '09:00 AM - 11:00 AM', 'status': 'available'},
            {'id': '${code}_PC2_S2', 'timeWindow': '01:00 PM - 03:00 PM', 'status': 'available'},
          ]
        },
        {
          'id': '${code}_PC3',
          'name': '$districtName Central Grain Storage Warehouse',
          'address': 'Industrial Area, $districtName',
          'capacityQuintals': 600,
          'availableSlots': [
            {'id': '${code}_PC3_S1', 'timeWindow': '08:00 AM - 11:00 AM', 'status': 'available'},
            {'id': '${code}_PC3_S2', 'timeWindow': '01:00 PM - 04:00 PM', 'status': 'available'},
          ]
        },
        {
          'id': '${code}_PC4',
          'name': '$districtName Rural Procurement & Distribution Center',
          'address': 'Bypass Road, $districtName',
          'capacityQuintals': 400,
          'availableSlots': [
            {'id': '${code}_PC4_S1', 'timeWindow': '09:00 AM - 12:00 PM', 'status': 'available'},
            {'id': '${code}_PC4_S2', 'timeWindow': '02:00 PM - 05:00 PM', 'status': 'available'},
          ]
        },
        {
          'id': '${code}_PC5',
          'name': '$districtName Grain Mandi Procurement Yard',
          'address': 'Mandi Complex, $districtName',
          'capacityQuintals': 450,
          'availableSlots': [
            {'id': '${code}_PC5_S1', 'timeWindow': '08:30 AM - 11:30 AM', 'status': 'available'},
            {'id': '${code}_PC5_S2', 'timeWindow': '01:30 PM - 04:30 PM', 'status': 'available'},
          ]
        },
        {
          'id': '${code}_PC6',
          'name': '$districtName Regional Collection Point',
          'address': 'National Highway Junction, $districtName',
          'capacityQuintals': 300,
          'availableSlots': [
            {'id': '${code}_PC6_S1', 'timeWindow': '08:00 AM - 10:00 AM', 'status': 'available'},
            {'id': '${code}_PC6_S2', 'timeWindow': '10:30 AM - 12:30 PM', 'status': 'available'},
          ]
        },
      ]
    };
  }
}