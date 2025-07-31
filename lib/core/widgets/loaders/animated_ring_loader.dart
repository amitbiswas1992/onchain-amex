import 'package:flutter/material.dart';

class AnimatedRingLoader extends StatefulWidget {
  final double size;
  final Widget? child;

  const AnimatedRingLoader({
    super.key,
    this.size = 100.0,
    this.child,
  });

  @override
  _AnimatedRingLoaderState createState() => _AnimatedRingLoaderState();
}

class _AnimatedRingLoaderState extends State<AnimatedRingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  late Animation<double> _scaleAnimation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Define scale animations for the three rings with slight delays
    _scaleAnimation1 = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation2 = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation3 = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Central widget (profile picture or placeholder)
        Container(
          width: widget.size * 0.38, // Reduced from 0.5 to 0.3
          height: widget.size * 0.38, // Reduced from 0.5 to 0.3
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: widget.child ??
              const Icon(
                Icons.person,
                size: 24, // Reduced from 40 to 24
                color: Colors.white,
              ),
        ),
        // First ring
        AnimatedBuilder(
          animation: _scaleAnimation1,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation1.value,
              child: SizedBox(
                width: widget.size * 0.5, // Reduced from 0.7 to 0.5
                height: widget.size * 0.5, // Reduced from 0.7 to 0.5
                child: Image.asset('assets/ellipse/cicle.png', fit: BoxFit.contain),
              ),
            );
          },
        ),
        // Second ring
        AnimatedBuilder(
          animation: _scaleAnimation2,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation2.value,
              child: SizedBox(
                width: widget.size * 0.65, // Reduced from 0.85 to 0.65
                height: widget.size * 0.65, // Reduced from 0.85 to 0.65
                child: Image.asset('assets/ellipse/cicle.png', fit: BoxFit.contain),
              ),
            );
          },
        ),
        // Third ring
        AnimatedBuilder(
          animation: _scaleAnimation3,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation3.value,
              child: SizedBox(
                width: widget.size * 0.8, // Reduced from 1.0 to 0.8
                height: widget.size * 0.8, // Reduced from 1.0 to 0.8
                child: Image.asset('assets/ellipse/cicle.png', fit: BoxFit.contain),
              ),
            );
          },
        ),
      ],
    );
  }
}