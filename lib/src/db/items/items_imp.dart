import 'package:grpc_dart/grpc_dart.dart';

class ItemsServices implements IItemsServices {
  @override
  Item? createItem(Item item) {
    items.add({
      'id': item.id,
      'name': item.name,
      'categoryId': item.categoryId,
    });
    return item;
  }

  @override
  Empty? deleteItem(Item item) {
    items.removeWhere((element) => element['id'] == item.id);
    return Empty();
  }

  @override
  Item? editItem(Item item) {
    try {
      var itemIndex = items.indexWhere((element) => element['id'] == item.id);
      items[itemIndex]['name'] = item.name;
    } catch (e) {
      print(e);
    }
    return item;
  }

  @override
  Item? getItemById(int id) {
    var item = Item();
    var result = items.where((element) => element["id"] == id).toList();
    if (result.isNotEmpty) {
      item = helper.getItemFromMap(result.first);
    }
    return item;
  }

  @override
  Item? getItemByName(String name) {
    var item = Item();
    var result = items.where((element) => element["name"] == name).toList();
    if (result.isNotEmpty) {
      item = helper.getItemFromMap(result.first);
    }
    return item;
  }

  @override
  List<Item>? getItems() {
    return items.map((item) {
      return helper.getItemFromMap(item);
    }).toList();
  }

  @override
  List<Item>? getItemsByCategory(Category category) {
    var result = <Item>[];
    var jsonList =
        items.where((element) => element["categoryId"] == category.id).toList();
    result = jsonList.map((item) => helper.getItemFromMap(item)).toList();
    return result;
  }
}
