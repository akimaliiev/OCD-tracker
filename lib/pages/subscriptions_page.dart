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
  String selectedPlan = '';

  final _purchaseUpdates = InAppPurchase.instance.purchaseStream;

  final List<PaymentItem> _googlePayItems = [
    const PaymentItem(
      label: 'Monthly Plan',
      amount: '5.99',
      status: PaymentItemStatus.final_price,
    ),
  ];

  final List<PaymentItem> _applePayItems = [
    const PaymentItem(
      label: 'Monthly Plan',
      amount: '5.99',
      status: PaymentItemStatus.final_price,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadTrialStatus();
    _checkSubscriptionStatus();
    _listenToPurchaseUpdates();
  }

  void _listenToPurchaseUpdates() {
    _purchaseUpdates.listen((purchaseDetailsList) {
      for (var purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.purchased) {
          _updateSubscriptionStatus();
          _showSnackBar("Subscription activated successfully!");
        } else if (purchase.status == PurchaseStatus.error) {
          _showSnackBar("Purchase failed: ${purchase.error?.message}");
        }
      }
    });
  }

  Future<void> _loadTrialStatus() async {
    DateTime? trialStartDate = await AuthService().getTrialStartDate();
    if (trialStartDate != null) {
      int daysElapsed = DateTime.now().difference(trialStartDate).inDays;
      setState(() {
        remainingDays = trialDuration - daysElapsed;
        trialStatus = remainingDays > 0
            ? "Trial expires in $remainingDays day(s)."
            : "Trial has expired.";
      });
    } else {
      setState(() {
        trialStatus = "No trial data found.";
      });
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    final subscribed = await AuthService().isUserSubscribed();
    setState(() {
      isSubscribed = subscribed;
    });
  }

  Future<void> _updateSubscriptionStatus() async {
    final user = AuthService().getCurrentUser();
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

  void _handleApplePayResult(paymentResult) {
    _updateSubscriptionStatus();
    _showSnackBar("Apple Pay successful!");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscription', style: TextStyle(color: Colors.brown)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: const IconThemeData(color: Colors.brown),
        leading: BackButton(color: Colors.brown),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isSubscribed ? "You are subscribed" : trialStatus,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 20),
            if (!isSubscribed) ...[
              Text(
                'Choose your plan:',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlanCard('Monthly Plan', '\$5.99/month'),
                  _buildPlanCard('Annual Plan', '\$4.99/month, billed annually'),
                ],
              ),
              const SizedBox(height: 24),
              if (selectedPlan.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 48,
                    child: ApplePayButton(
                      paymentConfigurationAsset: 'apple_pay.json',
                      paymentItems: selectedPlan == 'Monthly Plan'
                          ? _applePayItems
                          : [
                        const PaymentItem(
                          label: 'Annual Plan',
                          amount: '59.88',
                          status: PaymentItemStatus.final_price,
                        ),
                      ],
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.subscribe,
                      onPaymentResult: _handleApplePayResult,
                      loadingIndicator: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String plan, String price) {
    final isSelected = selectedPlan == plan;
    return GestureDetector(
      onTap: () => _selectPlan(plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(plan, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(color: Colors.black), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
