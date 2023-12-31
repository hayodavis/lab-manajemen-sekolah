import 'package:get/get.dart';

import '../modules/add_inventory/bindings/add_inventory_binding.dart';
import '../modules/add_inventory/views/add_inventory_view.dart';
import '../modules/detail_inventory/bindings/detail_inventory_binding.dart';
import '../modules/detail_inventory/views/detail_inventory_view.dart';
import '../modules/edit_inventory/bindings/edit_inventory_binding.dart';
import '../modules/edit_inventory/views/edit_inventory_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ADD_INVENTORY,
      page: () => const AddInventoryView(),
      binding: AddInventoryBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_INVENTORY,
      page: () => const DetailInventoryView(),
      binding: DetailInventoryBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_INVENTORY,
      page: () => const EditInventoryView(),
      binding: EditInventoryBinding(),
    ),
  ];
}
