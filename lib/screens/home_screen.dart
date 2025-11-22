import 'package:flutter/material.dart';
import '../models/food.dart';
import '../widgets/food_card.dart';
import '../widgets/bottom_nav.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import '../services/ml_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Food> _filteredFoods = sampleFoods;
  List<Food> _suggestions = [];

  List<dynamic> _mlItems = [];
  bool _mlLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  // Mapping ML names → Asset image paths
  final Map<String, String> mlFoodImages = {
    "Manchurian Delight": "assets/images/cabbage_manchurian_dry.webp",
    "Butter Chicken": "assets/images/butter_chicken.jpg",
    "Chocolate Milkshake": "assets/images/ChocolateMilkshake-Featured.jpg",
    "Lassi Combo": "assets/images/lassi.jpg",
    "Vanilla Milkshake": "assets/images/vanilla_milkshake.png",
    "Coffee": "assets/images/coffee.png",
    "Noodles Premium": "assets/images/noodles.png",
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    fetchMLData();
  }

  void fetchMLData() async {
    try {
      final data = await MLService.getPrediction();
      setState(() {
        _mlItems = data["most_sold_food_items"] ?? [];
        _mlLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      print("ML error: $e");
      setState(() => _mlLoading = false);
    }
  }

  void _applyMLFilter(String name) {
    setState(() {
      _filteredFoods = sampleFoods
          .where((f) => f.title.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("What would you like to eat?"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            children: [
              // 🟣 Banner section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A65), Color(0xFF4E3CC8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  "🔥 Today's Top Picks Based on Demand 🔥",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 14),

              // ⭐ ML Top Selling Round Chips
              _mlLoading
                  ? SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (_, __) => Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _mlItems.length,
                        itemBuilder: (context, index) {
                          final item = _mlItems[index];
                          final img = mlFoodImages[item["food_item"]];

                          return GestureDetector(
                            onTap: () => _applyMLFilter(item["food_item"]),
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        img != null ? AssetImage(img) : null,
                                    backgroundColor: Colors.deepPurple.shade100,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item["food_item"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

              const SizedBox(height: 10),

              // 🔍 Search bar & suggestions
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search your favourite food...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              if (_suggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        title: Text(suggestion.title),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 10),

              // 🍱 Food grid
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
