enum SlotStatus { available, full, inactive }

class ProcurementSlot {
  final String id;
  final String timeWindow;
  final SlotStatus status;
  final int availableCapacityQuintals;

  const ProcurementSlot({
    required this.id,
    required this.timeWindow,
    required this.status,
    required this.availableCapacityQuintals,
  });
}

class District {
  final String name;
  final List<ProcurementSlot> slots;

  const District({
    required this.name,
    required this.slots,
  });
}

class IndianState {
  final String name;
  final List<District> districts;

  const IndianState({
    required this.name,
    required this.districts,
  });
}