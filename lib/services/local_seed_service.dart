import '../models/centre_model.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import 'local_database_service.dart';

class LocalSeedService {
  static Future<void> seedIfEmpty() async {
    final isar = IsarDatabaseService.isar;

    final existingCentres = await isar.centreModels.count();
    if (existingCentres < 25) {
      final centres = <CentreModel>[];

      final stateData = <String, Map<String, List<String>>>{
        'Madhya Pradesh': {
          'Shivpuri': [
            'Shivpuri Main Procurement Center',
            'Kolaras Procurement Center',
            'Pichhore Procurement Center',
            'Karera Procurement Center',
            'Pohari Procurement Center',
          ],
          'Bhopal': [
            'Bhopal Central Mandi Center',
            'Berasia Procurement Center',
            'Phanda Procurement Hub',
            'Huzur Grain Center',
            'Kolar Road Mandi',
          ],
          'Indore': [
            'Indore Laxmibai Nagar Mandi',
            'Sanwer Procurement Center',
            'Depalpur Agriculture Center',
            'Mhow Farmers Center',
            'Rau Procurement Hub',
          ],
          'Gwalior': [
            'Gwalior Lashkar Procurement Center',
            'Dabra Grain Mandi',
            'Bhantar Procurement Hub',
            'Morar Farmers Center',
            'Chinor Agriculture Hub',
          ],
          'Ujjain': [
            'Ujjain Chimanganj Mandi',
            'Nagda Procurement Center',
            'Khachrod Agriculture Center',
            'Mahidpur Farmers Hub',
            'Tarana Grain Center',
          ],
        },
        'Telangana': {
          'Warangal': [
            'Warangal APMC Grain Market',
            'Narsampet Procurement Center',
            'Parkal Agriculture Hub',
            'Wardhannapet Mandi',
            'Mahabubabad Procurement Center',
          ],
          'Nizamabad': [
            'Nizamabad Integrated Market',
            'Bodhan Grain Center',
            'Armoor Farmers Hub',
            'Balkonda Procurement Center',
            'Banswada Mandi',
          ],
          'Karimnagar': [
            'Karimnagar District Center',
            'Huzurabad Agriculture Center',
            'Peddapalli Mandi',
            'Jagtial Farmers Market',
            'Sircilla Grain Center',
          ],
          'Khammam': [
            'Khammam Main APMC',
            'Madhira Procurement Center',
            'Sathupally Agriculture Hub',
            'Wyra Grain Mandi',
            'Kothagudem Farmers Hub',
          ],
          'Nalgonda': [
            'Nalgonda APMC Market',
            'Miryalaguda Paddy Center',
            'Suryapet Farmers Hub',
            'Devarakonda Grain Mandi',
            'Bhongir Agriculture Center',
          ],
        },
        'Punjab': {
          'Ludhiana': [
            'Ludhiana Grain Market',
            'Khanna APMC Market',
            'Jagraon Procurement Hub',
            'Samrala Mandi',
            'Raikot Agriculture Center',
          ],
          'Amritsar': [
            'Amritsar Bhagtanwala Mandi',
            'Ajnala Procurement Center',
            'Rayya Farmers Hub',
            'Baba Bakala Grain Market',
            'Majitha Agriculture Center',
          ],
          'Patiala': [
            'Patiala Sirhind Road Mandi',
            'Nabha Procurement Center',
            'Rajpura Grain Hub',
            'Samana Agriculture Mandi',
            'Patran Farmers Center',
          ],
          'Jalandhar': [
            'Jalandhar New Grain Market',
            'Nakodar Procurement Hub',
            'Phillaur Farmers Market',
            'Shahkot Agriculture Center',
            'Adampur Mandi',
          ],
          'Bathinda': [
            'Bathinda Main Mandi',
            'Talwandi Sabo Center',
            'Rampura Phul Mandi',
            'Maur Agriculture Hub',
            'Bhucho Mandi',
          ],
        },
        'Haryana': {
          'Karnal': [
            'Karnal Grain Market',
            'Gharaunda Procurement Hub',
            'Taraori Mandi',
            'Assandh Farmers Center',
            'Indri Agriculture Market',
          ],
          'Ambala': [
            'Ambala City Grain Market',
            'Ambala Cantt Procurement Center',
            'Naraingarh Mandi',
            'Barara Farmers Hub',
            'Mullana Grain Hub',
          ],
          'Hisar': [
            'Hisar Main APMC',
            'Hansi Procurement Center',
            'Barwala Agriculture Market',
            'Adampur Farmers Center',
            'Narnaund Mandi',
          ],
          'Kurukshetra': [
            'Kurukshetra Thanesar Mandi',
            'Shahbad Markanda Center',
            'Pehowa Farmers Hub',
            'Ladwa Grain Market',
            'Babain Agriculture Center',
          ],
          'Rohtak': [
            'Rohtak Grain Market',
            'Meham Procurement Center',
            'Sampla Agriculture Hub',
            'Kalanaur Mandi',
            'Lakhan Majra Center',
          ],
        },
        'Andhra Pradesh': {
          'Guntur': [
            'Guntur Mirchi & Grain Yard',
            'Tenali Procurement Center',
            'Narasaraopet Agriculture Hub',
            'Bapatla Farmers Market',
            'Mangalagiri Mandi',
          ],
          'Krishna': [
            'Vijayawada APMC Yard',
            'Gudivada Procurement Center',
            'Machilipatnam Farmers Hub',
            'Nuzvid Grain Mandi',
            'Jaggaiahpet Agriculture Center',
          ],
          'West Godavari': [
            'Eluru Main Grain Yard',
            'Tadepalligudem Paddy Center',
            'Tanuku Farmers Hub',
            'Bhimavaram Procurement Market',
            'Jangareddygudem Mandi',
          ],
          'East Godavari': [
            'Kakinada APMC Market',
            'Rajahmundry Grain Yard',
            'Amalapuram Agriculture Hub',
            'Peddapuram Farmers Center',
            'Pithapuram Procurement Market',
          ],
          'Kurnool': [
            'Kurnool APMC Yard',
            'Nandyal Procurement Market',
            'Adoni Cotton & Grain Center',
            'Yemmiganur Farmers Hub',
            'Dhone Agriculture Mandi',
          ],
        },
      };

      int idCounter = 100;
      stateData.forEach((stateName, districts) {
        districts.forEach((districtName, centerList) {
          for (final centerName in centerList) {
            idCounter++;
            centres.add(
              CentreModel(
                centreId: 'CTR-$idCounter',
                state: stateName,
                district: districtName,
                centreName: centerName,
                capacity: 20,
              ),
            );
          }
        });
      });

      await isar.writeTxn(() async {
        await isar.centreModels.putAll(centres);
      });
    }

    final userCount = await isar.userModels.count();
    if (userCount == 0) {
      final defaultUsers = [
        UserModel(
          uid: '123456789012',
          role: 'farmer',
          name: 'Ramesh Kumar',
          farmerId: 'RS10245',
          phoneNumber: '9876543210',
          aadhaarNumber: '123456789012',
          state: 'Madhya Pradesh',
          district: 'Shivpuri',
          createdAt: DateTime.now(),
        ),
        UserModel(
          uid: '987654321098',
          role: 'farmer',
          name: 'Suresh Yadav',
          farmerId: 'SY98211',
          phoneNumber: '9812345678',
          aadhaarNumber: '987654321098',
          state: 'Telangana',
          district: 'Warangal',
          createdAt: DateTime.now(),
        ),
        UserModel(
          uid: 'OPF102',
          role: 'officer',
          name: 'Rajesh Sharma',
          officerId: 'OPF102',
          phoneNumber: '9711223344',
          state: 'Madhya Pradesh',
          district: 'Shivpuri',
          centreId: 'CTR-101',
          createdAt: DateTime.now(),
        ),
        UserModel(
          uid: 'OPF103',
          role: 'officer',
          name: 'Anil Verma',
          officerId: 'OPF103',
          phoneNumber: '9755443322',
          state: 'Telangana',
          district: 'Warangal',
          centreId: 'CTR-126',
          createdAt: DateTime.now(),
        ),
      ];

      await isar.writeTxn(() async {
        await isar.userModels.putAll(defaultUsers);
      });
    }

    final bookingCount = await isar.bookingModels.count();
    if (bookingCount == 0) {
      final sampleBooking = BookingModel(
        bookingId: 'booking_42',
        farmerId: 'RS10245',
        farmerName: 'Ramesh Kumar',
        centreId: 'CTR-101',
        centreName: 'Shivpuri Main Procurement Center',
        crop: 'Wheat',
        quantityQuintal: 20.0,
        bookingDate: DateTime.now().add(const Duration(days: 2)),
        slotTime: '11:00 AM - 11:30 AM',
        token: '42',
        status: 'Booked',
        paymentStatus: 'Pending',
        createdAt: DateTime.now(),
      );

      await isar.writeTxn(() async {
        await isar.bookingModels.put(sampleBooking);
      });
    }
  }
}