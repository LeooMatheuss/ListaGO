import 'package:drift/drift.dart';

enum MeasurementUnit { kg, g, l, ml, unidade, pacote, duzia }

extension MeasurementUnitDisplay on MeasurementUnit {
  String get label {
    switch (this) {
      case MeasurementUnit.kg:
        return 'kg';
      case MeasurementUnit.g:
        return 'g';
      case MeasurementUnit.l:
        return 'L';
      case MeasurementUnit.ml:
        return 'mL';
      case MeasurementUnit.unidade:
        return 'un';
      case MeasurementUnit.pacote:
        return 'pct';
      case MeasurementUnit.duzia:
        return 'dz';
    }
  }
}

class MeasurementUnitConverter extends TypeConverter<MeasurementUnit, String> {
  const MeasurementUnitConverter();

  @override
  MeasurementUnit fromSql(String fromDb) {
    return MeasurementUnit.values.firstWhere(
      (value) => value.name == fromDb,
      orElse: () => MeasurementUnit.unidade,
    );
  }

  @override
  String toSql(MeasurementUnit value) {
    return value.name;
  }
}
