import 'package:get/get.dart';

class ItemDetailsController extends GetxController
{
  RxInt _quantityItem = 1.obs;
  RxInt _sizeItem = 0.obs;
  RxInt _varianItem = 0.obs;
  RxBool _isFavorite = false.obs;

  int get quantity => _quantityItem.value;
  int get size => _sizeItem.value;
  int get varian => _varianItem.value;
  bool get isfavorite => _isFavorite.value;

  setQuantityItem(int quantityOfItem)
  {
    _quantityItem.value = quantityOfItem;
  }

  setSizeItem(int sizeOfItem)
  {
    _sizeItem.value = sizeOfItem;
  }

  setVarianItem(int varianOfItem)
  {
    _varianItem.value = varianOfItem;
  }

  setIsFavorite(bool isfavorite)
  {
    _isFavorite.value = isfavorite;
  }
}