import '../models/category.dart';
import '../models/media.dart';
import '../models/option.dart';
import '../models/option_group.dart';

class Product {
  String id;
  double price;
  double priceHelp;
  double discountPrice;
  double discountPriceHelp;
  String capacity;
  double packageItemsCount;
  String unit;
  bool featured;
  bool freeDelivery;
  bool enabled;
  String category_id;
  String en_name;
  String ar_name;
  String en_description;
  String ar_description;
  bool has_media;
  Category category;
  List<Option> options;
  List<Media> images;
  Media image;
  List<OptionGroup> optionGroups;

  Product();

  Product.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0;
      capacity = jsonMap['capacity'].toString();
      packageItemsCount = jsonMap['package_items_count'] != null
          ? jsonMap['package_items_count'].toDouble()
          : 0.0;
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      featured = jsonMap['featured'] ?? false;
      freeDelivery = jsonMap['featured'] ?? false;
      enabled = jsonMap['free_delivery'] ?? false;
      category_id = jsonMap['enabled'].toString();
      en_name = jsonMap['en_name'];
      ar_name = jsonMap['ar_name'];
      en_description = jsonMap['en_description'];
      ar_description = jsonMap['ar_description'];
      has_media = jsonMap['has_media'] ?? false;
      category = jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : Category.fromJSON({});
      options =
          jsonMap['options'] != null && (jsonMap['options'] as List).length > 0
              ? List.from(jsonMap['options'])
                  .map((element) => Option.fromJSON(element))
                  .toSet()
                  .toList()
              : [];
      images = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? List.from(jsonMap['media'])
              .map((element) => Media.fromJSON(element))
              .toSet()
              .toList()
          : [];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      optionGroups = jsonMap['option_groups'] != null &&
              (jsonMap['option_groups'] as List).length > 0
          ? List.from(jsonMap['option_groups'])
              .map((element) => OptionGroup.fromJSON(element))
              .toSet()
              .toList()
          : [];
      priceHelp = featured && discountPrice > 0 ? discountPrice : price;
      discountPriceHelp = featured && discountPrice > 0 ? price : discountPrice;
      price = priceHelp;
      discountPrice = discountPriceHelp;
    } catch (e) {
      id = '';
      price = 0.0;
      discountPrice = 0.0;
      capacity = '';
      packageItemsCount = 0.0;
      unit = '';
      featured = false;
      freeDelivery = false;
      enabled = false;
      category_id = '';
      en_name = '';
      ar_name = '';
      en_description = '';
      ar_description = '';
      has_media = false;
      category = Category.fromJSON({});
      options = [];
      optionGroups = [];
      images = [];
      image = new Media();
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["capacity"] = capacity;
    map["package_items_count"] = packageItemsCount;
    map["en_name"] = en_name;
    map["ar_name"] = ar_name;
    map["en_description"] = en_description;
    map["ar_description"] = ar_description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  @override
  String toString() => "name= $en_name, check= $options";
}
