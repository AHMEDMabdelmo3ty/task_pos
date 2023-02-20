class InterestModel {
  final String text;
  final String id;

  InterestModel({required this.text, required this.id});
  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      text: json['intrestText'],
      id: json['id'],
    );
  }
}
