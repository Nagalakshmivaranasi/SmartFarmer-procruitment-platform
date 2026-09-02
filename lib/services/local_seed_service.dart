import '../models/centre_model.dart';
import 'local_database_service.dart';

class LocalSeedService {
  static Future<void> seedIfEmpty() async {
    final isar = LocalDatabaseService.isar;

    await isar.writeTxn(() async {
        await isar.centreModels.putAll([
          CentreModel(centreId: 'CTR-01', state: 'Telangana', district: 'Warangal', centreName: 'Warangal Procurement Centre', capacity: 20),
          CentreModel(centreId: 'CTR-02', state: 'Andhra Pradesh', district: 'Guntur', centreName: 'Guntur Procurement Centre', capacity: 20),
        ]);
    });

  }
}