enum InspectionVerdict {
  accepted,
  partiallyAccepted,
  rejected,
}

class QualityEvaluationResult {
  final InspectionVerdict verdict;
  final String grade;
  final double deductionPercentage;
  final double finalRatePerQuintal;
  final double netPayableAmount;
  final String remarks;

  QualityEvaluationResult({
    required this.verdict,
    required this.grade,
    required this.deductionPercentage,
    required this.finalRatePerQuintal,
    required this.netPayableAmount,
    required this.remarks,
  });
}

class QualityEvaluator {
  static const double baseMsp = 2425.0; // ₹ per Quintal

  static QualityEvaluationResult evaluate({
    required double netWeightQuintal,
    required double moisture,
    required double foreignMatter,
    required double damagedGrains,
    required double otherGrains,
  }) {
    // 1. Rejection Criteria Check
    if (moisture > 14.0 || foreignMatter > 2.0 || damagedGrains > 4.0 || otherGrains > 3.0) {
      final List<String> reasons = [];
      if (moisture > 14.0) reasons.add('Moisture exceeds 14% (found ${moisture.toStringAsFixed(1)}%)');
      if (foreignMatter > 2.0) reasons.add('Foreign matter exceeds 2% (found ${foreignMatter.toStringAsFixed(1)}%)');
      if (damagedGrains > 4.0) reasons.add('Damaged grains exceed 4% (found ${damagedGrains.toStringAsFixed(1)}%)');
      if (otherGrains > 3.0) reasons.add('Other food grains exceed 3% (found ${otherGrains.toStringAsFixed(1)}%)');

      return QualityEvaluationResult(
        verdict: InspectionVerdict.rejected,
        grade: 'Below FAQ (Rejected)',
        deductionPercentage: 0.0,
        finalRatePerQuintal: 0.0,
        netPayableAmount: 0.0,
        remarks: 'Lot rejected: ${reasons.join(', ')}.',
      );
    }

    // 2. Full Acceptance Criteria
    final bool isFullFaq = moisture <= 12.0 &&
        foreignMatter <= 0.75 &&
        damagedGrains <= 2.0 &&
        otherGrains <= 2.0;

    if (isFullFaq) {
      final double total = netWeightQuintal * baseMsp;
      return QualityEvaluationResult(
        verdict: InspectionVerdict.accepted,
        grade: 'Grade A (FAQ Compliant)',
        deductionPercentage: 0.0,
        finalRatePerQuintal: baseMsp,
        netPayableAmount: total,
        remarks: 'Produce meets all FAQ specifications. Full MSP granted.',
      );
    }

    // 3. Partial Acceptance (Value Deductions)
    double deduction = 0.0;
    final List<String> deductionReasons = [];

    if (moisture > 12.0) {
      final excess = moisture - 12.0;
      deduction += excess * 1.5; // 1.5% deduction per 1% excess moisture
      deductionReasons.add('Excess moisture (${moisture.toStringAsFixed(1)}%)');
    }
    if (foreignMatter > 0.75) {
      deduction += 1.0;
      deductionReasons.add('Foreign matter (${foreignMatter.toStringAsFixed(1)}%)');
    }
    if (damagedGrains > 2.0) {
      deduction += 2.0;
      deductionReasons.add('Damaged kernels (${damagedGrains.toStringAsFixed(1)}%)');
    }

    // Cap maximum deduction at 10%
    if (deduction > 10.0) deduction = 10.0;

    final double discountedRate = baseMsp * (1 - (deduction / 100));
    final double netTotal = netWeightQuintal * discountedRate;

    return QualityEvaluationResult(
      verdict: InspectionVerdict.partiallyAccepted,
      grade: 'Grade B (Substandard / Deductions)',
      deductionPercentage: deduction,
      finalRatePerQuintal: discountedRate,
      netPayableAmount: netTotal,
      remarks: 'Partial acceptance subject to ${deduction.toStringAsFixed(1)}% cut: ${deductionReasons.join(', ')}.',
    );
  }
}