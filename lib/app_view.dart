import 'package:flutter/material.dart';

import 'screens/auth/views/sign_in_screen.dart';
import 'screens/auth/views/sign_up_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F1EA),
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CoffeeHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.local_cafe_rounded,
                size: 72,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Coffee Order',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Order your favorite coffee easily',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: colorScheme.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: colorScheme.primary,
                      tabs: const [
                        Tab(text: 'Sign In'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                    SizedBox(
                      height: 470,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SignInScreen(onSignInSuccess: _goToHome),
                          SignUpScreen(onSignUpSuccess: _goToHome),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoffeeHomePage extends StatelessWidget {
  const CoffeeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Menu'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CoffeeItem(name: 'Americano', price: '25.000đ', icon: Icons.coffee),
          _CoffeeItem(name: 'Latte', price: '35.000đ', icon: Icons.local_cafe),
          _CoffeeItem(name: 'Cappuccino', price: '39.000đ', icon: Icons.coffee_maker),
          _CoffeeItem(name: 'Milk Coffee', price: '30.000đ', icon: Icons.emoji_food_beverage),
        ],
      ),
    );
  }
}

class _CoffeeItem extends StatelessWidget {
  final String name;
  final String price;
  final IconData icon;

  const _CoffeeItem({
    required this.name,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(name),
        subtitle: Text(price),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('Order'),
        ),
      ),
    );
  }
}
