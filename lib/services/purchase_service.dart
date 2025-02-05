import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> initialize() async {
    bool available = await _iap.isAvailable();
    if (!available) {
      throw Exception("In-app purchases are not available on this device.");
    }
  }

  Future<void> makePurchase(String productId) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: ProductDetails(
        id: productId,
        title: productId == "monthly_plan" ? "Monthly Plan" : "Annual Plan",
        price: productId == "monthly_plan" ? "\$8.90" : "\$82.80",
        description: productId == "monthly_plan"
            ? "Get access with a monthly plan."
            : "Get access with an annual plan.",
        currencyCode: "USD",
        rawPrice: productId == "monthly_plan" ? 8.90 : 82.80,
      ),
    );
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
