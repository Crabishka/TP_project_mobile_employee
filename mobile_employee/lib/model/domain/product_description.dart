class ProductDescription {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;

  ProductDescription(
      {required this.id,
        required this.title,
        required this.description,
        required this.price,
        required this.image});

  factory ProductDescription.fromJson(Map<String, dynamic> json) {
    return ProductDescription(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['cost'].toDouble(),
      image: json['photo'],
    );
  }

}
