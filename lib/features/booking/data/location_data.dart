import '../models/location_slot_models.dart';

final List<IndianState> indianStatesData = [
  const IndianState(
    name: 'Madhya Pradesh',
    districts: [
      District(
        name: 'Shivpuri',
        slots: [
          ProcurementSlot(id: 'S1', timeWindow: '08:00 AM - 10:00 AM', status: SlotStatus.available, availableCapacityQuintals: 150),
          ProcurementSlot(id: 'S2', timeWindow: '10:00 AM - 12:00 PM', status: SlotStatus.full, availableCapacityQuintals: 0),
          ProcurementSlot(id: 'S3', timeWindow: '12:00 PM - 02:00 PM', status: SlotStatus.available, availableCapacityQuintals: 80),
          ProcurementSlot(id: 'S4', timeWindow: '02:00 PM - 04:00 PM', status: SlotStatus.inactive, availableCapacityQuintals: 0),
          ProcurementSlot(id: 'S5', timeWindow: '04:00 PM - 06:00 PM', status: SlotStatus.available, availableCapacityQuintals: 200),
        ],
      ),
      District(
        name: 'Gwalior',
        slots: [
          ProcurementSlot(id: 'G1', timeWindow: '09:00 AM - 11:00 AM', status: SlotStatus.full, availableCapacityQuintals: 0),
          ProcurementSlot(id: 'G2', timeWindow: '11:00 AM - 01:00 PM', status: SlotStatus.available, availableCapacityQuintals: 300),
          ProcurementSlot(id: 'G3', timeWindow: '02:00 PM - 04:00 PM', status: SlotStatus.inactive, availableCapacityQuintals: 0),
        ],
      ),
      District(
        name: 'Indore',
        slots: [
          ProcurementSlot(id: 'I1', timeWindow: '08:00 AM - 10:00 AM', status: SlotStatus.available, availableCapacityQuintals: 500),
          ProcurementSlot(id: 'I2', timeWindow: '10:00 AM - 12:00 PM', status: SlotStatus.available, availableCapacityQuintals: 120),
        ],
      ),
    ],
  ),
  const IndianState(
    name: 'Punjab',
    districts: [
      District(
        name: 'Ludhiana',
        slots: [
          ProcurementSlot(id: 'L1', timeWindow: '08:00 AM - 10:00 AM', status: SlotStatus.full, availableCapacityQuintals: 0),
          ProcurementSlot(id: 'L2', timeWindow: '10:00 AM - 12:00 PM', status: SlotStatus.available, availableCapacityQuintals: 400),
        ],
      ),
      District(
        name: 'Patiala',
        slots: [
          ProcurementSlot(id: 'P1', timeWindow: '09:00 AM - 11:00 AM', status: SlotStatus.available, availableCapacityQuintals: 250),
          ProcurementSlot(id: 'P2', timeWindow: '01:00 PM - 03:00 PM', status: SlotStatus.inactive, availableCapacityQuintals: 0),
        ],
      ),
    ],
  ),
  const IndianState(
    name: 'Andhra Pradesh',
    districts: [
      District(
        name: 'Visakhapatnam',
        slots: [
          ProcurementSlot(id: 'V1', timeWindow: '08:00 AM - 10:00 AM', status: SlotStatus.available, availableCapacityQuintals: 350),
          ProcurementSlot(id: 'V2', timeWindow: '10:00 AM - 12:00 PM', status: SlotStatus.full, availableCapacityQuintals: 0),
        ],
      ),
    ],
  ),
];