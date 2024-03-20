import 'dart:io';
import 'dart:math';
import 'package:grpc/grpc.dart';
import 'package:grpc_dart/grpc_dart.dart';

class Client {
  ClientChannel? channel;
  GroceriesServiceClient? stub;
  var response;
  bool executionInProgress = true;

  Future<void> main() async {
    channel = ClientChannel(
      'localhost',
      port: 50000,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    stub = GroceriesServiceClient(
      channel!,
      options: CallOptions(timeout: Duration(seconds: 30)),
    );

    while (executionInProgress) {
      try {
        print('---- Welcome to the dart store API ----');
        print(' ---- What would you like to do? ----');
        print('👉 1: View all products');
        print('👉 2: Add new product');
        print('👉 3: Edit product');
        print('👉 4: Get product');
        print('👉 5: Delete product \n');
        print('👉 6: View all categories');
        print('👉 7: Add new category');
        print('👉 8: Edit category');
        print('👉 9: Get category');
        print('👉 10: Delete category \n');
        print('👉 11: Get all products of a given category');

        var option = int.parse(stdin.readLineSync()!);

        switch (option) {
          case 1:
            response = await stub!.getAllItems(Empty());
            print(' --- Store products --- ');
            response.items.forEach((item) {
              print('Product: ${item.name} (id: ${item.id})');
            });
            break;
          case 2:
            print('Enter product name');
            var name = stdin.readLineSync()!;
            var item = await _findItemByName(name);
            if (item.id != 0) {
              print(
                  'Product already exists: product ${item.name} (id: ${item.id})');
            } else {
              print('Enter product category');
              var categoryName = stdin.readLineSync()!;
              var category = await _findCategoryByName(categoryName);
              if (category.id != 0) {
                item = Item()
                  ..id = _randomId()
                  ..name = name
                  ..categoryId = category.id;
                response = await stub!.createItem(item);
                print(
                    'Product created: product ${response.name} (id: ${response.id})');
              } else {
                print('Category $categoryName not found');
              }
            }
            break;
          case 3:
            print('Enter product name');
            var name = stdin.readLineSync()!;
            var item = await _findItemByName(name);
            if (item.id != 0) {
              print('Enter new product name');
              name = stdin.readLineSync()!;
              response = await stub!.editItem(
                  Item(id: item.id, name: name, categoryId: item.categoryId));

              if (response.name == name) {
                print(
                    'Product updated: product ${response.name} (id: ${response.id})');
              } else {
                print('Product update failed!');
              }
            } else {
              print('Product $name not found');
            }
            break;
          case 4:
            print('Enter product name');
            var name = stdin.readLineSync()!;
            var item = await _findItemByName(name);

            if (item.id != 0) {
              print(
                  'Product found: product ${item.name} (id: ${item.id}) | category: ${item.categoryId}');
            } else {
              print('Product not found');
            }
            break;
          case 5:
            print('Enter product name');
            var name = stdin.readLineSync()!;
            var item = await _findItemByName(name);
            if (item.id != 0) {
              response = await stub!.deleteItem(item);
              print('Product deleted: product ${item.name}');
            } else {
              print('Product not found');
            }
            break;
          case 6:
            response = await stub!.getAllCategories(Empty());
            print(' --- Store product categories --- ');
            response.categories.forEach((category) {
              print('Category: ${category.name} (id: ${category.id})');
            });
            break;
          case 7:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  'Category already exists: category ${category.name} (id: ${category.id})');
            } else {
              category = Category()
                ..id = _randomId()
                ..name = name;
              response = await stub!.createCategory(category);
              print(
                  'Category created: category ${response.name} (id: ${response.id})');
            }
            break;
          case 8:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  'Enter new category name for category ${category.name} (id: ${category.id})');
              name = stdin.readLineSync()!;
              response = await stub!
                  .editCategory(Category(id: category.id, name: name));
              if (response.name == name) {
                print(
                    'Category updated: category ${response.name} (id: ${response.id})');
              } else {
                print('Category update failed!');
              }
              print(
                  'Category updated: category ${response.name} (id: ${response.id})');
            } else {
              print('Category $name not found');
            }
            break;
          case 9:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print(
                  'Category found: category ${category.name} (id: ${category.id})');
            } else {
              print('Category not found');
            }
            break;
          case 10:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              response = await stub!.deleteCategory(category);
              print('Category deleted: category ${category.name}');
            } else {
              print('Category not found');
            }
            break;
          case 11:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              response = await stub!.getItemsByCategory(category);
              print(' --- Products of category ${category.name} --- ');
              response.items.forEach((item) {
                print('Product: ${item.name} (id: ${item.id})');
              });
            } else {
              print('Category not found');
            }
            break;
          default:
            print('Invalid option');
        }
      } catch (e) {
        print(e);
      }

      print('Do you wish to exit the store? (y/N)');
      var result = stdin.readLineSync() ?? 'n';
      executionInProgress = result.toLowerCase() != 'y';
    }

    await channel!.shutdown();
  }

  Future<Category> _findCategoryByName(String name) async {
    var category = Category()..name = name;
    category = await stub!.getCategory(category);
    return category;
  }

  Future<Item> _findItemByName(String name) async {
    var item = Item()..name = name;
    item = await stub!.getItem(item);
    return item;
  }

  int _randomId() => Random(1000).nextInt(9999);
}

void main() {
  var client = Client();
  client.main();
}
