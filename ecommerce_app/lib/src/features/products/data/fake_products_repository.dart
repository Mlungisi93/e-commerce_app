import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    //to test error throw Exception("Connection failed");
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

//Summary: Use FutureProvider for one-time data fetching and StreamProvider for continuous data updates(live updates).
final productListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  //debugPrint('created productListStreamProvider');
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductsList();
});

final productListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  //debugPrint('created productProvider($id)');
  //ref.onResume(() => debugPrint('resume productProvider($id)'));
  //ref.onCancel(() => debugPrint('cancel productProvider($id)'));
  //ref.onDispose(() => debugPrint('disposed productProvider($id)'));
  final productsRepository = ref.watch(productRepositoryProvider);
  return productsRepository.watchProduct(id);
});
/*Caching with Timeout (Riverpod 2.0)
Riverpod 2.0 also offers an additional keepAlive() method that can be used to delay the disposal of the provider when it is no longer used.

This can be used in combination with a Timer to implement a “cache with timeout” policy:

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  // keep the provider alive when it's no longer used
  final link = ref.keepAlive();
  // use a timer to dispose it after 10 seconds
  final timer = Timer(const Duration(seconds: 10), () {
    link.close();
  });
  // make sure the timer is cancelled when the provider state is disposed
  ref.onDispose(() => timer.cancel());
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
});*/
