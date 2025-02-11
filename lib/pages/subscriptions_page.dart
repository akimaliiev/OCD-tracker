import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocr_2/auth/auth_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocr_2/services/purchase_service.dart';

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
                    price: '\$8.90\nper month',
                    onTap: () => _handleSubscription('Monthly Plan'),
                  ),
                  _buildSubscriptionOption(
                    plan: 'Annual Plan',
                    price: '\$6.90\nper month,\nbilled annually',
                    onTap: () => _handleSubscription('Annual Plan'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionOption({
    required String plan,
    required String price,
    required VoidCallback onTap,
  }) {
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
        child: Column(
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
      ),
    );
  }
}
