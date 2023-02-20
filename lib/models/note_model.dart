class NoteModel {
  final String text;
  final String date;
  final String userId;
  final String id;

  NoteModel({
    required this.text,
    required this.date,
    required this.userId,
    required this.id,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      text: json['text'],
      date: json['placeDateTime'],
      userId: json['userId'] ?? '0',
      id: json['id'],
    );
  }
}
