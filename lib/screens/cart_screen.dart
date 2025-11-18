import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/food.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Item Carts')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final id = items.keys.elementAt(i);
                  final qty = items[id]!;
                  final food = sampleFoods.firstWhere((f) => f.id == id);
                  return Card(
                    child: ListTile(
                      leading: SizedBox(
                        width: 56,
                        child: Image.network(food.imageUrl, fit: BoxFit.cover),
                      ),
                      title: Text(food.title),
                      subtitle: Text('\$${food.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => cart.removeSingle(id),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('$qty'),
                          IconButton(
                            onPressed: () => cart.addItem(food),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () => cart.removeAll(id),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Add Your Promo Code',
                prefixIcon: const Icon(Icons.local_offer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Final Amount:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '\$${cart.totalAmount(sampleFoods).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final total = cart.totalAmount(sampleFoods);
                  final success = await Navigator.pushNamed(
                    context,
                    PaymentScreen.routeName, // ✅ use the static routeName

                    arguments: total,
                  );
                  if (success == true) {
                    cart.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order Placed Successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text('Checkout & Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
