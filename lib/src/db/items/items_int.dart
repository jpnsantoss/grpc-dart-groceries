import 'package:grpc_dart/grpc_dart.dart';

abstract class IItemsServices {
  factory IItemsServices() => ItemsServices();

  Item? getItemByName(String name);
  Item? getItemById(int id);

  Item? createItem(Item item);
  Item? editItem(Item item);
  Empty? deleteItem(Item item);
  List<Item>? getItems();
  List<Item>? getItemsByCategory(Category category);
}

final itemsServices = IItemsServices();
