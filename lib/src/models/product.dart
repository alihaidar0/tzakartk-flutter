import '../models/category.dart';
import '../models/media.dart';
import '../models/option.dart';
import '../models/option_group.dart';
import 'coupon.dart';

class Product {
  String id;
  double price;
  double discountPrice;
  String capacity;
  String packageItemsCount;
  String unit;
  bool featured;
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
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0
          ? discountPrice
          : jsonMap['price'] != null
              ? jsonMap['price'].toDouble()
              : 0.0;
      capacity = jsonMap['capacity'].toString();
      packageItemsCount = jsonMap['package_items_count'].toString();
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      featured = jsonMap['featured'] ?? false;
      category_id = jsonMap['category_id'].toString();
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
    } catch (e) {
      id = '';
      price = 0.0;
      discountPrice = 0.0;
      capacity = '';
      packageItemsCount = '';
      unit = '';
      featured = false;
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

  Coupon applyCoupon(Coupon coupon) {
    if (coupon.code != '') {
      if (coupon.valid == null) {
        coupon.valid = false;
      }
      coupon.discountables.forEach((element) {
        if (!coupon.valid) {
          if (element.discountableType == "App\\Models\\Product") {
            if (element.discountableId == id) {
              coupon = _couponDiscountPrice(coupon);
            }
          }

          /// I HID THIS FOR MARKET
          // else if (element.discountableType == "App\\Models\\Market") {
          //   if (element.discountableId == market.id) {
          //     coupon = _couponDiscountPrice(coupon);
          //   }
          // }
          else if (element.discountableType == "App\\Models\\Category") {
            if (element.discountableId == category.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          }
        }
      });
    }
    return coupon;
  }

  Coupon _couponDiscountPrice(Coupon coupon) {
    coupon.valid = true;
    discountPrice = price;
    if (coupon.discountType == 'fixed') {
      price -= coupon.discount;
    } else {
      price = price - (price * coupon.discount / 100);
    }
    if (price < 0) price = 0;
    return coupon;
  }

  @override
  String toString() => "name= $en_name, check= $options";
}
