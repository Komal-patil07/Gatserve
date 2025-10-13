import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final food = ModalRoute.of(context)!.settings.arguments as Food?;
    if (food == null)
      return const Scaffold(body: Center(child: Text('No product')));

    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(food.title), leading: BackButton()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(food.imageUrl,
                fit: BoxFit.cover,
                height: 260,
                width: double.infinity,
                errorBuilder: (_, __, ___) =>
                    Container(height: 260, color: Colors.grey[200])),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(food.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          Text('\$${food.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ]),
                    const SizedBox(height: 8),
                    Text(food.description),
                    const SizedBox(height: 12),
                    Row(children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.remove_circle_outline)),
                      const SizedBox(width: 6),
                      ElevatedButton.icon(
                        onPressed: () {
                          cart.addItem(food);
                          final snack = SnackBar(
                              content: Text('${food.title} added to cart'));
                          ScaffoldMessenger.of(context).showSnackBar(snack);
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add To Bag'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12)),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('Food Details',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent euismod.'),
                    const SizedBox(height: 20),
                    // small footer icons
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Column(children: [
                            Icon(Icons.schedule),
                            SizedBox(height: 6),
                            Text('12pm-3pm')
                          ]),
                          Column(children: [
                            Icon(Icons.location_on),
                            SizedBox(height: 6),
                            Text('3.5 km')
                          ]),
                          Column(children: [
                            Icon(Icons.map),
                            SizedBox(height: 6),
                            Text('Map View')
                          ]),
                          Column(children: [
                            Icon(Icons.delivery_dining),
                            SizedBox(height: 6),
                            Text('Delivery')
                          ]),
                        ])
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
