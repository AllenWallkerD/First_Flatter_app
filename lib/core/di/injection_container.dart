import 'package:get_it/get_it.dart';
import '../network/network_service.dart';
import '../storage/local_storage_service.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/cart_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../../presentation/blocs/categories/categories_bloc.dart';
import '../../presentation/blocs/products/products_bloc.dart';
import '../../presentation/blocs/top_selling/top_selling_bloc.dart';
import '../../presentation/blocs/new_in/new_in_bloc.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/orders/orders_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => NetworkService.instance);
  sl.registerLazySingleton(() => LocalStorageService.instance);
  
  // Initialize local storage
  await sl<LocalStorageService>().init();

  //! Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(networkService: sl()),
  );
  
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(storageService: sl()),
  );

  //! Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  //! Use cases
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetTopSellingProducts(sl()));
  sl.registerLazySingleton(() => GetNewInProducts(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  
  // Cart use cases
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => UpdateCartItem(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));
  sl.registerLazySingleton(() => GetOrderHistory(sl()));
  sl.registerLazySingleton(() => CreateOrder(sl()));

  //! BLoCs
  sl.registerFactory(() => CategoriesBloc(getCategories: sl()));
  
  sl.registerFactory(() => TopSellingBloc(getTopSellingProducts: sl()));
  
  sl.registerFactory(() => NewInBloc(getNewInProducts: sl()));
  
  sl.registerFactory(() => ProductsBloc(
        getTopSellingProducts: sl(),
        getProductsByCategory: sl(),
      ));
      
  sl.registerFactory(() => CartBloc(
        getCartItems: sl(),
        addToCart: sl(),
        updateCartItem: sl(),
        removeFromCart: sl(),
        clearCart: sl(),
        createOrder: sl(),
      ));
      
  sl.registerFactory(() => OrdersBloc(getOrderHistory: sl()));
}
