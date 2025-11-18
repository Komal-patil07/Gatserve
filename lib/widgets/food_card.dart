import 'package:flutter/material.dart';
import '../models/food.dart';
import '../screens/product_detail_screen.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: food);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Image fills the top of the card without white gaps
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: food.imageUrl.startsWith('http')
                    ? Image.network(
                        food.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        food.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // 🍽 Title and Price section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${food.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
