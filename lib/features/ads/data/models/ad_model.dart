class Ad {
  final int id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? targetUrl;
  final String type;
  final int priority;
  final bool isActive; // Add this field

  Ad({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.targetUrl,
    required this.type,
    required this.priority,
    required this.isActive, // Add to constructor
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      targetUrl: json['target_url'],
      type: json['type'],
      priority: json['priority'],
      isActive: json['is_active'] ?? false, // Map from JSON
    );
  }
}