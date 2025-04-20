import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocr_2/services/purchase_service.dart';
import 'package:pay/pay.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  int remainingDays = 0;
  String trialStatus = "Loading...";
  final int trialDuration = 7;
  bool isSubscribed = false;
  late final Stream<List<PurchaseDetails>> _purchaseUpdates;

  final _googlePayItems = <PaymentItem>[
    const PaymentItem(
      label: 'Monthly Plan',
      amount: '5.99',
      status: PaymentItemStatus.final_price,
    ),
  ];

  final _applePayItems = <PaymentItem>[
    const PaymentItem(
      label: 'Monthly Plan',
      amount: '5.99',
      status: PaymentItemStatus.final_price,
    ),
  ];

  String selectedPlan = ''; // Track selected plan (monthly or annual)

  @override
  void initState() {
    super.initState();
    _loadTrialStatus();
    _initializeInAppPurchase();
  }

  void _initializeInAppPurchase() {
    _purchaseUpdates = InAppPurchase.instance.purchaseStream;
    _purchaseUpdates.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  void _loadTrialStatus() async {
    DateTime? trialStartDate = await AuthService().getTrialStartDate();
    if (trialStartDate != null) {
      setState(() {
        int daysElapsed = DateTime.now().difference(trialStartDate).inDays;
        remainingDays = trialDuration - daysElapsed;
        trialStatus = remainingDays > 0
            ? "Your Trial Expires in $remainingDays Days!"
            : "Your Trial Has Expired";
      });
    } else {
      setState(() {
        trialStatus = "No trial data found. Please contact support.";
      });
    }
  }

  void _checkSubscriptionStatus() async {
    bool subscribed = await AuthService().isUserSubscribed();
    setState(() {
      isSubscribed = subscribed;
    });
  }

  void _handleSubscription(String plan) {
    String productId = plan == 'Monthly Plan' ? 'monthly_plan' : 'annual_plan';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Initiating $plan subscription...")),
    );
    PurchaseService().makePurchase(productId);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased) {
        _updateSubscriptionStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Subscription activated successfully!")),
        );
      } else if (purchase.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Purchase failed: ${purchase.error?.message}")),
        );
      }
    }
  }

  void _updateSubscriptionStatus() async {
    User? user = AuthService().getCurrentUser();
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .update({'isSubscribed': true});
      setState(() {
        isSubscribed = true;
      });
    }
  }

  void onGooglePayResult(paymentResult) {
    _updateSubscriptionStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google Pay successful! Subscription activated.")),
    );
  }

  void onApplePayResult(paymentResult) {
    _updateSubscriptionStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Apple Pay successful! Subscription activated.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage My Subscriptions',
          style: TextStyle(color: Colors.brown),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isSubscribed ? "You are currently subscribed" : trialStatus,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!isSubscribed) ...[
              Center(
                child: Text(
                  'Upgrade Now:',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubscriptionOption(
                    plan: 'Monthly Plan',
                    price: '\$5.99\nper month',
                    onTap: () {
                      setState(() {
                        selectedPlan = 'Monthly Plan';
                      });
                    },
                  ),
                  _buildSubscriptionOption(
                    plan: 'Annual Plan',
                    price: '\$4.99\nper month,\nbilled annually',
                    onTap: () {
                      setState(() {
                        selectedPlan = 'Annual Plan';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 20),
              if (selectedPlan.isNotEmpty) ...[
                // Center(
                //   child: Text(
                //     'Selected Plan: $selectedPlan',
                //     style: GoogleFonts.roboto(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.green,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                _buildApplePayButton(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApplePayButton() {
    return Center(
      child: ApplePayButton(
        paymentConfigurationAsset: 'apple_pay.json',
        paymentItems: selectedPlan == 'Monthly Plan' ? _applePayItems : [
          PaymentItem(
            label: 'Annual Plan',
            amount: '4.99',
            status: PaymentItemStatus.final_price,
          ),
        ],
        style: ApplePayButtonStyle.black,
        type: ApplePayButtonType.buy,
        onPaymentResult: onApplePayResult,
        loadingIndicator: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSubscriptionOption({
    required String plan,
    required String price,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedPlan == plan;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plan,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (isSelected) ...[
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              ),
            ],
            if (!isSelected) ...[
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
