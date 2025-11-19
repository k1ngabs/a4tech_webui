class OllamaModel {
  final String name;
  final String modifiedAt;
  final int size;

  OllamaModel({
    required this.name,
    required this.modifiedAt,
    required this.size,
  });

  factory OllamaModel.fromJson(Map<String, dynamic> json) {
    return OllamaModel(
      name: json['name'],
      modifiedAt: json['modified_at'],
      size: json['size'],
    );
  }
}
