import 'package:grpc/grpc.dart';
import 'package:grpc_dart/grpc_dart.dart';

class GroceriesService extends GroceriesServiceBase {
  @override
  Future<Category> createCategory(ServiceCall call, Category request) async {
    return categoriesServices.createCategory(request)!;
  }

  @override
  Future<Item> createItem(ServiceCall call, Item request) async =>
      itemsServices.createItem(request)!;

  @override
  Future<Empty> deleteCategory(ServiceCall call, Category request) async =>
      categoriesServices.deleteCategory(request)!;

  @override
  Future<Empty> deleteItem(ServiceCall call, Item request) async =>
      itemsServices.deleteItem(request)!;

  @override
  Future<Category> editCategory(ServiceCall call, Category request) async =>
      categoriesServices.editCategory(request)!;

  @override
  Future<Item> editItem(ServiceCall call, Item request) async =>
      itemsServices.editItem(request)!;

  @override
  Future<Categories> getAllCategories(ServiceCall call, Empty request) async =>
      Categories()..categories.addAll(categoriesServices.getCategories()!);

  @override
  Future<Items> getAllItems(ServiceCall call, Empty request) async =>
      Items()..items.addAll(itemsServices.getItems()!);

  @override
  Future<Category> getCategory(ServiceCall call, Category request) async =>
      categoriesServices.getCategoryByName(request.name)!;
  @override
  Future<Item> getItem(ServiceCall call, Item request) async =>
      itemsServices.getItemByName(request.name)!;
  @override
  Future<AllItemsOfCategory> getItemsByCategory(
          ServiceCall call, Category request) async =>
      AllItemsOfCategory(
        items: itemsServices.getItemsByCategory(request)!,
        categoryId: request.id,
      );
}

Future<void> main() async {
  final server = Server.create(
    services: [GroceriesService()],
    interceptors: [],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: 50000);
  print('✅ Server listening on port ${server.port}...');
}
