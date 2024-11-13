import 'package:flutter/material.dart';
import 'profile_card.dart'; 
class SelectableCard extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? imageUrl;
  final bool verified;
  final VoidCallback? onViewProfile;
  final VoidCallback? onUnmatch;

  const SelectableCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.verified = false,
    this.onViewProfile,
    this.onUnmatch,
  });

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  bool isSelected = false;

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSelection,
      child: Stack(
        children: [
          ProfileCard(
            name: widget.name,
            email: widget.email,
            phone: widget.phone,
            imageUrl: widget.imageUrl,
            verified: widget.verified,
            onViewProfile: widget.onViewProfile,
            onUnmatch: widget.onUnmatch,
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
