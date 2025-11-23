import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = "/admin-dashboard";
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  int totalUsers = 0;
  List<dynamic> mlFoods = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final usersRes = await http
          .get(Uri.parse("http://192.168.0.102:5000/api/auth/total-users"));
      final userData = jsonDecode(usersRes.body);
      totalUsers = userData["totalUsers"] ?? 0;

      final mlRes =
          await http.get(Uri.parse("http://192.168.0.102:5000/api/ml/predict"));
      final mlData = jsonDecode(mlRes.body);
      mlFoods = mlData["most_sold_food_items"] ?? [];

      setState(() => loading = false);
    } catch (e) {
      print("Dashboard Load Error: $e");
      setState(() => loading = false);
    }
  }

  final List<String> pages = [
    "Dashboard",
    "Foods",
    "Users",
    "Inventory",
    "Orders",
    "ML Analytics",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  // ---------------- SIDEBAR ----------------
  Widget _buildSidebar() {
    return Container(
      width: 230,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text("GatServe Admin",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _menuItem(Icons.dashboard, "Dashboard", 0),
          _menuItem(Icons.fastfood, "Foods", 1),
          _menuItem(Icons.people, "Users", 2),
          _menuItem(Icons.inventory_2, "Inventory", 3),
          _menuItem(Icons.shopping_bag, "Orders", 4),
          _menuItem(Icons.bar_chart, "ML Analytics", 5),
          _menuItem(Icons.settings, "Settings", 6),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("v1.0.0", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    bool selected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple.shade50 : Colors.transparent,
          border: selected
              ? Border(left: BorderSide(color: Colors.deepPurple, width: 4))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22, color: selected ? Colors.deepPurple : Colors.black87),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: selected ? Colors.deepPurple : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- MAIN CONTENT ----------------
  Widget _buildMainContent() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return _dashboardPage();
      default:
        return _placeholder(pages[_selectedIndex]);
    }
  }

  // ---------------- DASHBOARD PAGE (WITH CHARTS) ----------------
  Widget _dashboardPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Dashboard Overview",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        // TOP CARDS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCard("Total Users", "$totalUsers", Icons.people),
            _statCard("Food Items", "38", Icons.fastfood),
            _statCard("Orders Today", "12", Icons.shopping_cart),
            _statCard(
                "Top ML Items", mlFoods.length.toString(), Icons.auto_graph),
          ],
        ),

        const SizedBox(height: 30),
        const Text("📈 Peak Hours Chart",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _peakHoursChart(),

        const SizedBox(height: 30),
        const Text("📊 Weekly Orders",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _weeklyOrdersChart(),

        const SizedBox(height: 30),
        const Text("🥗 Food Category Distribution",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _foodCategoryPie(),

        const SizedBox(height: 30),
        const Text("🔥 Most Demanded Items (ML)",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _mlList(),
      ],
    );
  }

  // ---------------- STAT CARD ----------------
  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.deepPurple),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ------------------- CHART 1: PEAK HOURS -------------------
  Widget _peakHoursChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: _chartBox(),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            _bar(8, 10),
            _bar(10, 22),
            _bar(12, 40),
            _bar(14, 32),
            _bar(18, 50),
            _bar(20, 28),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int hour, int value) {
    return BarChartGroupData(
      x: hour,
      barRods: [
        BarChartRodData(
          toY: value.toDouble(),
          color: Colors.deepPurple,
          width: 18,
        )
      ],
    );
  }

  // ------------------- CHART 2: WEEKLY ORDERS -------------------
  Widget _weeklyOrdersChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(12),
      decoration: _chartBox(),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 60,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 20),
                FlSpot(1, 35),
                FlSpot(2, 30),
                FlSpot(3, 55),
                FlSpot(4, 40),
                FlSpot(5, 50),
                FlSpot(6, 45),
              ],
              isCurved: true,
              color: Colors.deepPurple,
              barWidth: 4,
            )
          ],
        ),
      ),
    );
  }

  // ------------------- CHART 3: CATEGORY PIE -------------------
  Widget _foodCategoryPie() {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(12),
      decoration: _chartBox(),
      child: PieChart(
        PieChartData(sections: [
          PieChartSectionData(
              value: 40, title: "Snacks", color: Colors.deepPurple),
          PieChartSectionData(value: 30, title: "Meals", color: Colors.orange),
          PieChartSectionData(
              value: 20, title: "Beverages", color: Colors.blue),
          PieChartSectionData(value: 10, title: "Dessert", color: Colors.green),
        ]),
      ),
    );
  }

  BoxDecoration _chartBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4))
      ],
    );
  }

  // -------- ML FOOD LIST --------
  Widget _mlList() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _chartBox(),
      child: Column(
        children: mlFoods.map((item) {
          return ListTile(
            leading: const Icon(Icons.star, color: Colors.deepPurple),
            title: Text(item["food_item"],
                style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text(
              item["total_orders"].toString(),
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------- PLACEHOLDER ----------------
  Widget _placeholder(String text) {
    return Center(
      child: Text(text,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    );
  }
}
