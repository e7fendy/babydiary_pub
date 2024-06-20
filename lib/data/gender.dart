
enum Gender {
  male,
  female
}

extension GenderExtension on Gender {
  String get dbString {
    switch (this) {
      case Gender.male:
        return "male";
      case Gender.female:
        return "female";
    }
  }

  static Gender fromDbString(String value) {
    switch (value) {
      case "female":
        return Gender.female;
      case "male":
        return Gender.male;
      default:
        throw ArgumentError('Invalid enum value: $value');
    }
  }
}