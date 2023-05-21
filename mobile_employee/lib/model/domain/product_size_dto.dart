

class ProductSizeDTO {
  Map<double, bool> map;

  ProductSizeDTO({required this.map});

  factory ProductSizeDTO.fromJson(Map<String, dynamic> json) {
    Map<double, bool> parsedMap = {};
    json.forEach((key, value) {
      double doubleKey = double.parse(key);
      if (doubleKey != null) {
        parsedMap[doubleKey] = value as bool;
      }
    });

    return ProductSizeDTO(map: parsedMap);
  }
}
