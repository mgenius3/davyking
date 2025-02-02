class GiftcardsListModel {
  final String name;
  final String image_url;

  const GiftcardsListModel({required this.name, required this.image_url});

  factory GiftcardsListModel.fromJson(Map<String, dynamic> json) {
    return GiftcardsListModel(name: json['name'], image_url: json['image']);
  }
}
