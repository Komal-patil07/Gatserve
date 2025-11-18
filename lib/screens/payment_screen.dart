import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  void _payWithCash(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentSuccessScreen(
          message: "Cash payment selected. Please pay at delivery.",
        ),
      ),
    );
  }

  void _payWithWallet(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text("₹${totalAmount.toStringAsFixed(2)} deducted from wallet.")),
    );
    Navigator.pop(context, true); // Return success
  }

  Future<void> _payWithUPI(BuildContext context) async {
    const upiId = 'example@upi'; // Replace with your real UPI ID
    final amount = totalAmount.toStringAsFixed(2);
    final uri = Uri.parse(
        'upi://pay?pa=$upiId&pn=Gatserve&am=$amount&cu=INR&tn=FoodOrder');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No UPI app found on device')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Cash Payment Button
            ElevatedButton.icon(
              onPressed: () => _payWithCash(context),
              icon: const Icon(Icons.money),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              label: const Text(
                'Pay with Cash',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // Wallet Payment Button
            ElevatedButton.icon(
              onPressed: () => _payWithWallet(context),
              icon: const Icon(Icons.account_balance_wallet),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              label: const Text(
                'Pay with Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // UPI Payment Button
            ElevatedButton.icon(
              onPressed: () => _payWithUPI(context),
              icon: const Icon(Icons.payment),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              label: const Text(
                'Pay using UPI App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
