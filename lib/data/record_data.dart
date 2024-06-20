
class RecordData {
  int? id;
  String? type;
  int? childId;
  int? createdAt; // seconds
  String? note;

  RecordData({
    this.id,
    this.type,
    this.childId,
    this.createdAt,
    this.note
  });

  RecordData copyWith({
    String? type,
    int? childId,
    String? note
  }) {
    return RecordData(
      type: type ?? this.type,
      childId: childId ?? this.childId,
      note: note ?? this.note
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'child_id': childId,
      'note': note
    };
  }

  factory RecordData.fromMap(Map<String, dynamic> map) {
    return RecordData(
      id: map['id'],
      type: map['type'],
      childId: map['child_id'],
      createdAt: map['created_at'],
      note: map['note']
    );
  }

}