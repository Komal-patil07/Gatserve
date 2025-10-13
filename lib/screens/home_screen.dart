import 'package:flutter/material.dart';
import '../models/food.dart';
import '../widgets/food_card.dart';
import '../widgets/bottom_nav.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What would you like to eat?'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_bag_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'What would you like to buy?',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list), onPressed: () {}),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('Burger'),
                  _buildCategoryChip('Sushi'),
                  _buildCategoryChip('Pizza'),
                  _buildCategoryChip('Cake'),
                  _buildCategoryChip('Ice Cream'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: sampleFoods.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (ctx, i) => FoodCard(food: sampleFoods[i]),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: HelloBottomNav(
          currentIndex: _navIndex,
          onTap: (i) {
            setState(() => _navIndex = i);
            if (i == 2) Navigator.pushNamed(context, CartScreen.routeName);
          }),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(label: Text(label)),
    );
  }
}
