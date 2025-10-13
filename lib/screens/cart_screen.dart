import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/food.dart';

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
        child: Column(children: [
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
                        child: Image.network(food.imageUrl, fit: BoxFit.cover)),
                    title: Text(food.title),
                    subtitle: Text('\$${food.price.toStringAsFixed(2)}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          onPressed: () => cart.removeSingle(id),
                          icon: const Icon(Icons.remove)),
                      Text('$qty'),
                      IconButton(
                          onPressed: () => cart.addItem(food),
                          icon: const Icon(Icons.add)),
                      IconButton(
                          onPressed: () => cart.removeAll(id),
                          icon: const Icon(Icons.delete)),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          TextField(
              decoration: InputDecoration(
                  hintText: 'Add Your Promo Code',
                  prefixIcon: const Icon(Icons.local_offer))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Grilled Salmon'), Text('\$192')]),
              const SizedBox(height: 6),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Meat vegetable'), Text('\$102')]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${cart.totalAmount(sampleFoods).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // go to checkout or back to home
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: const Text('Payment'),
                            content: const Text('Payment flow goes here.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'))
                            ]));
              },
              child: const Padding(
                  padding: EdgeInsets.all(14.0), child: Text('Checkout')),
            ),
          ),
        ]),
      ),
    );
  }
}
