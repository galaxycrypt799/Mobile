import 'package:flutter/material.dart';
import '../../packages/coffee_repository/lib/src/models/coffee.dart';

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const CoffeeCard({
    super.key,
    required this.coffee,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh cà phê
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.1,
                    child: Image.network(
                      coffee.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF5ECD7),
                        child: const Icon(
                          Icons.coffee,
                          size: 48,
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                    ),
                  ),
                  // Badge loại đồ uống
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildBadge(coffee.category),
                  ),
                ],
              ),
            ),

            // Thông tin
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C1A0E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coffee.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Giá
                      Text(
                        '${coffee.price.toStringAsFixed(0)}đ',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                      // Nút thêm vào giỏ
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6F4E37),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String category) {
    Color bgColor;
    Color textColor;
    switch (category.toLowerCase()) {
      case 'hot':
        bgColor = const Color(0xFFFF6B35);
        textColor = Colors.white;
        break;
      case 'cold':
      case 'iced':
        bgColor = const Color(0xFF4FC3F7);
        textColor = Colors.white;
        break;
      case 'blend':
        bgColor = const Color(0xFF81C784);
        textColor = Colors.white;
        break;
      default:
        bgColor = const Color(0xFFF5ECD7);
        textColor = const Color(0xFF6F4E37);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}