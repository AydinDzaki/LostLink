class ItemModel {
  final String? id;
  final String title;
  final String description;
  final String imageUrl; 
  final String location;
  final String status; 

  ItemModel({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.status,
  });

  // Factory method untuk mengubah JSON dari API/Backend menjadi Object Dart
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String?,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? 'Hilang',
    );
  }

  // Method untuk mengubah Object Dart menjadi JSON (untuk dikirim ke Backend)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'status': status,
    };
  }
}