import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.content,
    this.width = 150,
    required this.onPressed,
  });

  final Color color;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String content;
  final double width;
  final VoidCallback onPressed;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.color,
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: darken(widget.color, 0.1),
                    blurRadius: 10,
                    // spreadRadius: -5,
                  ),
                ]
              : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
        ),
        // height: 100,
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: darken(widget.iconColor, 0.2),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: darken(widget.iconColor, 0.2),
                  ),
                ),
                Icon(
                  widget.icon,
                  size: 40,
                  color: widget.iconColor,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
