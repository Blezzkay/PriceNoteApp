// app_bindings.dart
// Put controllers & services here so they are available app-wide.

import 'package:get/get.dart';
import 'package:price_note/services/product_pdf_service.dart';
import 'controllers/conversion_controller.dart';
import 'controllers/price_controller.dart';
import 'services/storage_service.dart';
import 'services/pdf_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Order matters: StorageService should be available before controller loads persisted data
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<PdfService>(PdfService(), permanent: true);
    Get.put<ProductPdfService>(ProductPdfService(), permanent: true);
    Get.put<ConversionController>(ConversionController(), permanent: true);
    Get.put<PriceController>(PriceController(), permanent: true);
  }
}
