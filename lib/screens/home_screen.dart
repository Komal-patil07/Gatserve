import 'package:flutter/material.dart';
import '../models/food.dart';
import '../widgets/food_card.dart';
import '../widgets/bottom_nav.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Food> _filteredFoods = sampleFoods;
  List<Food> _suggestions = [];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFoods = sampleFoods;
        _suggestions = [];
      } else {
        _suggestions = sampleFoods
            .where((food) =>
                food.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

        _filteredFoods = _suggestions;
      }
    });
  }

  void _selectSuggestion(Food food) {
    FocusScope.of(context).unfocus();
    _searchController.text = food.title;
    setState(() => _suggestions = []);
    Navigator.pushNamed(context, ProductDetailScreen.routeName,
        arguments: food);
  }

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
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          children: [
            // 🔍 Search bar + dropdown suggestions
            Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search your favorite food...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                suggestion.imageUrl.startsWith('http')
                                    ? NetworkImage(suggestion.imageUrl)
                                    : AssetImage(suggestion.imageUrl)
                                        as ImageProvider,
                          ),
                          title: Text(suggestion.title),
                          onTap: () => _selectSuggestion(suggestion),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // 🍱 Food Grid
            Expanded(
              child: GridView.builder(
                itemCount: _filteredFoods.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) => FoodCard(food: _filteredFoods[i]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HelloBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 2) Navigator.pushNamed(context, CartScreen.routeName);
        },
      ),
    );
  }
}
