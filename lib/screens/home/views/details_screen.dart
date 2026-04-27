import 'package:flutter/material.dart';
import 'package:untitled/screens/packages/coffee_repository/lib/src/models/coffee.dart';
// import '../blocs/cart_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final Coffee coffee;

  const DetailsScreen({super.key, required this.coffee});

  static Route<void> route(Coffee coffee) {
    return MaterialPageRoute(
      builder: (_) => DetailsScreen(coffee: coffee),
    );
  }

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _selectedSize = 'M';
  int _sugarLevel = 1; 
  int _quantity = 1;

  static const _sizes = ['S', 'M', 'L'];
  static const _sugarLabels = ['0%', '30%', '70%', '100%'];
  static const _sizePriceExtra = {'S': 0, 'M': 5000, 'L': 10000};

  double get _totalPrice =>
      (widget.coffee.price + (_sizePriceExtra[_selectedSize] ?? 0)) * _quantity;

  @override
  Widget build(BuildContext context) {
    final coffee = widget.coffee;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F3EB),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: const Color(0xFF2C1A0E),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2C1A0E), size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Color(0xFF6F4E37), size: 20),
                        onPressed: () {}, 
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        coffee.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFF5ECD7),
                          child: const Icon(Icons.coffee, size: 80, color: Color(0xFF6F4E37)),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xCCF9F3EB)],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              coffee.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2C1A0E),
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CategoryBadge(label: coffee.category),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            coffee.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C1A0E),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${coffee.reviewCount} đánh giá)',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        coffee.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Kích cỡ'),
                      const SizedBox(height: 10),
                      Row(
                        children: _sizes.map((size) {
                          final isSelected = _selectedSize == size;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF6F4E37) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF6F4E37)
                                        : const Color(0xFFE0D5C8),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: const Color(0xFF6F4E37).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected ? Colors.white : const Color(0xFF6F4E37),
                                      ),
                                    ),
                                    if ((_sizePriceExtra[size] ?? 0) > 0)
                                      Text(
                                        '+${_sizePriceExtra[size]! ~/ 1000}k',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.grey[400],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Mức đường'),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(4, (i) {
                          final isSelected = _sugarLevel == i;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                              child: GestureDetector(
                                onTap: () => setState(() => _sugarLevel = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFD4A76A)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFD4A76A)
                                          : const Color(0xFFE0D5C8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _sugarLabels[i],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Số lượng'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2C1A0E),
                              ),
                            ),
                          ),
                          _QuantityButton(
                            icon: Icons.add,
                            onTap: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      Text(
                        '${_totalPrice.toStringAsFixed(0)}đ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                      label: const Text(
                        'Thêm vào giỏ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${widget.coffee.name} vào giỏ hàng!'),
        backgroundColor: const Color(0xFF6F4E37),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2C1A0E),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'hot': [const Color(0xFFFF6B35), Colors.white],
      'iced': [const Color(0xFF4FC3F7), Colors.white],
      'cold': [const Color(0xFF4FC3F7), Colors.white],
      'blend': [const Color(0xFF81C784), Colors.white],
    };
    final pair = colors[label.toLowerCase()] ??
        [const Color(0xFFF5ECD7), const Color(0xFF6F4E37)];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: pair[0],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: pair[1],
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: const Border.fromBorderSide(
            BorderSide(color: Color(0xFFE0D5C8)),
          ),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF6F4E37)),
      ),
    );
  }
}
