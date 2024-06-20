
import 'dart:io';

import 'gender.dart';

class ChildData {
  final int? id;
  final Gender gender;
  final String name;
  final String? note;
  final int? createdAt;
  final String? photoPath;

  ChildData({
    this.id,
    required this.gender,
    required this.name,
    this.note,
    this.createdAt,
    this.photoPath,
  });

  ChildData copyWith({
    int? id,
    Gender? gender,
    String? name,
    String? note,
    int? createdAt,
    String? photoPath
  }) {
    return ChildData(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gender': gender.dbString,
      'name': name,
      'photo_path': photoPath,
      'note': note ?? ""
    };
  }

  factory ChildData.fromMap(Map<String, dynamic> map) {
    return ChildData(
        id: map['id'],
        gender: GenderExtension.fromDbString(map['gender']),
        name: map['name'],
        photoPath: map['photo_path'],
        note: map['note'],
        createdAt: map['created_at']);
  }
}
