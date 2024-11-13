import 'package:flutter/material.dart';
import 'profile_card.dart';

class SelectableCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? imageUrl;
  final bool verified;
  final bool isSelected; 
  final VoidCallback? onViewProfile;
  final VoidCallback? onUnmatch;
  final VoidCallback onToggleSelection; 

  const SelectableCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.verified = false,
    required this.isSelected,
    this.onViewProfile,
    this.onUnmatch,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleSelection,
      child: Stack(
        children: [
          ProfileCard(
            name: name,
            email: email,
            phone: phone,
            imageUrl: imageUrl,
            verified: verified,
            onViewProfile: onViewProfile,
            onUnmatch: onUnmatch,
            isSelected: isSelected, 
          ),
          if (!isSelected)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
        ],
      ),
    );
  }
}
