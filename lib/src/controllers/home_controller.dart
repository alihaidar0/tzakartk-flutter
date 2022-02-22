import '../models/category.dart';
import '../models/sub_category.dart';
import '../repository/banner_slider_repository.dart';
import '../repository/category_repository.dart';
import '../repository/change_location_repository.dart';
import '../repository/our_new_repository.dart';
import '../repository/sub_category_repository.dart';
import 'cart_controller.dart';

class HomeController extends CartController {
  List<String> bannerSlider = <String>[];
  List<String> ourNewSlider = <String>[];
  List<Category> categories = <Category>[];
  List<bool> selected = <bool>[];
  List<SubCategory> subCategories = <SubCategory>[];
  bool loadingBanners = false;
  bool loadingOurNew = false;
  bool loadingCategories = false;
  bool loadingSubCategories = false;
  bool loadingSubCategoriesByCity = false;

  HomeController() {
    listenForBanners();
    listenForOurNew();
  }

  Future<void> listenForBanners() async {
    if (!loadingBanners) {
      loadingBanners = true;
      bannerSlider.clear();
      final Stream<String> stream = await getBanners();
      stream.listen(
        (String _banner) {
          setState(() => bannerSlider.add(_banner));
        },
        onError: (a) {
          loadingBanners = false;
          print("##################");
          print("######### Error getBanners #########");
          print("##################");
          print(a);
        },
        onDone: () {
          loadingBanners = false;
        },
      );
    }
  }

  Future<void> listenForOurNew() async {
    if (!loadingOurNew) {
      loadingOurNew = true;
      ourNewSlider.clear();
      final Stream<String> stream = await getOurNew();
      stream.listen(
        (String _ourNew) {
          setState(() => ourNewSlider.add(_ourNew));
        },
        onError: (a) {
          loadingOurNew = false;
          print("##################");
          print("######### Error getBanners #########");
          print("##################");
          print(a);
        },
        onDone: () {
          loadingOurNew = false;
        },
      );
    }
  }

  Future<void> listenForCategories(String cityId) async {
    if (!loadingCategories) {
      loadingCategories = true;
      categories.clear();
      selected.clear();
      final Stream<Category> stream = await getCategories(cityId);
      stream.listen(
        (Category _category) {
          setState(() {
            categories.add(_category);
            selected.add(false);
          });
        },
        onError: (a) {
          loadingCategories = false;
          print("##################");
          print("######### Error getCategories #########");
          print("##################");
          print(a);
        },
        onDone: () {
          loadingCategories = false;
        },
      );
    }
  }

  Future<void> listenForSubCategories(String parentId) async {
    if (!loadingSubCategories) {
      loadingSubCategories = true;
      subCategories.clear();
      final Stream<SubCategory> stream = await getSubCategories(parentId);
      stream.listen(
        (SubCategory _subCategory) {
          setState(() => subCategories.add(_subCategory));
        },
        onError: (a) {
          loadingSubCategories = false;
          print("##################");
          print("######### Error getSubCategories #########");
          print("##################");
          print(a);
        },
        onDone: () {
          loadingSubCategories = false;
        },
      );
    }
  }

  Future<void> listenForSubCategoriesByCity(String cityId) async {
    if (!loadingSubCategoriesByCity) {
      loadingSubCategoriesByCity = true;
      subCategories.clear();
      final Stream<SubCategory> stream = await getSubCategoriesByCity(cityId);
      stream.listen(
        (SubCategory _subCategory) {
          setState(() => subCategories.add(_subCategory));
        },
        onError: (a) {
          loadingSubCategoriesByCity = false;
          print("##################");
          print("######### Error getSubCategoriesByCity #########");
          print("##################");
          print(a);
        },
        onDone: () {
          loadingSubCategoriesByCity = false;
        },
      );
    }
  }

  void changeLocation(String cityId, {String message}) async {
    changeLocationRepo(cityId);
  }

  Future<void> refreshHome() async {
    bannerSlider.clear();
    ourNewSlider.clear();
    categories.clear();
    selected.clear();
    subCategories.clear();
    await listenForBanners();
    await listenForOurNew();
  }
}
