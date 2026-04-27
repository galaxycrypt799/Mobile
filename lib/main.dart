import 'package:flutter/material.dart';
import 'package:untitled/screens/home/views/coffee_card.dart';
import 'package:untitled/screens/home/views/details_screen.dart';
import 'package:untitled/screens/packages/coffee_repository/lib/src/models/coffee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F4E37)),
        useMaterial3: true,
      ),
      home: const CoffeeHomePage(),
    );
  }
}

class CoffeeHomePage extends StatefulWidget {
  const CoffeeHomePage({super.key});

  @override
  State<CoffeeHomePage> createState() => _CoffeeHomePageState();
}

class _CoffeeHomePageState extends State<CoffeeHomePage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final List<String> categories = ['All', 'Hot', 'Iced', 'Blend'];

  final List<Coffee> coffeeList = [
    Coffee(
      id: '1',
      name: 'Cappuccino Mịn',
      description: 'Espresso với sữa nóng và bọt sữa.',
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?q=80&w=600&auto=format&fit=crop',
      rating: 4.8,
      reviewCount: 230,
      category: 'Hot',
    ),
    Coffee(
      id: '2',
      name: 'Iced Americano',
      description: 'Cà phê đen nguyên chất pha lạnh.',
      price: 35000,
      imageUrl: 'https://www.chewcharm.com/wp-content/uploads/2025/08/Iced_Americano_aoi7wk.webp',
      rating: 4.5,
      reviewCount: 150,
      category: 'Iced',
    ),
    Coffee(
      id: '3',
      name: 'Caramel Latte',
      description: 'Vị ngọt caramel và béo của sữa.',
      price: 55000,
      imageUrl: 'https://yummynotes.net/wp-content/uploads/2021/10/Homemade-Caramel-Latte-Recipe-3.jpg',
      rating: 4.9,
      reviewCount: 420,
      category: 'Hot',
    ),
    Coffee(
      id: '4',
      name: 'Mocha Đá Xay',
      description: 'Socola hòa quyện cùng espresso.',
      price: 60000,
      imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?q=80&w=600&auto=format&fit=crop',
      rating: 4.9,
      reviewCount: 305,
      category: 'Blend',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Logic tìm kiếm kết hợp lọc danh mục
    final filteredList = coffeeList.where((coffee) {
      final matchesCategory = selectedCategory == 'All' || coffee.category == selectedCategory;
      final matchesSearch = coffee.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F3EB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chào buổi sáng! 👋', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(
                          'Hôm nay uống gì nào?',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2C1A0E)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm cà phê...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF6F4E37)),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                searchQuery = '';
                              });
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6F4E37) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (filteredList.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Không tìm thấy món bạn yêu cầu ☕',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final coffee = filteredList[index];
                      return CoffeeCard(
                        coffee: coffee,
                        onTap: () => Navigator.push(context, DetailsScreen.route(coffee)),
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${coffee.name} vào giỏ!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                    childCount: filteredList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF6F4E37),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
        ],
      ),
    );
  }
}
