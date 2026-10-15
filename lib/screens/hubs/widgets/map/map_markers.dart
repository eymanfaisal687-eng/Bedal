import 'package:flutter/material.dart';
import '../../models/hub_models.dart';

class CafeMapMarker extends StatelessWidget {
  final Venue venue;
  final bool isSelected;
  final VoidCallback onTap;

  const CafeMapMarker({
    super.key,
    required this.venue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Container(
                  width: 60 * value,
                  height: 60 * value,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC89B3C).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 48 : 36,
            height: isSelected ? 48 : 36,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFC89B3C) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFC89B3C),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.coffee_rounded,
              color: isSelected ? Colors.white : const Color(0xFFC89B3C),
              size: isSelected ? 24 : 18,
            ),
          ),
        ],
      ),
    );
  }
}

class UserMapMarker extends StatelessWidget {
  final ActiveUser user;

  const UserMapMarker({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              user.avatar,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (user.isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF49C774),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
