import 'package:get/get.dart';
import '../../features/bikes/controllers/bikes_controller.dart';
import '../../features/fuel/controllers/fuel_controller.dart';
import '../../features/expense/controller/expense_controller.dart';

/// Initial bindings for the app
/// Registers all controllers that should be available throughout the app
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register bikes controller as permanent (lifetime: entire app)
    Get.put<BikesController>(BikesController(), permanent: true);
    
    // Register fuel controller as permanent
    Get.put<FuelController>(FuelController(), permanent: true);
    
    // Register expense controller as permanent
    Get.put<ExpenseController>(ExpenseController(), permanent: true);
  }
}
