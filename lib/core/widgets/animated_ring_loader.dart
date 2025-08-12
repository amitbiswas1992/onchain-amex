import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  late Animation<double> _scaleAnimation4;

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
    _scaleAnimation4 = Tween<double>(begin: 0.75, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
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
        widget.child ??
            const Icon(
              Icons.person,
              size: 24, // Reduced from 40 to 24
              color: Colors.white,
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
                child: SvgPicture.asset('assets/rings/ring1.svg', fit: BoxFit.contain),
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
                width: widget.size * 1.1, // Reduced from 0.85 to 0.65
                height: widget.size * 1.1, // Reduced from 0.85 to 0.65
                child: SvgPicture.asset('assets/rings/ring2.svg', fit: BoxFit.contain),
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
                width: widget.size * 1.5, // Reduced from 1.0 to 0.8
                height: widget.size * 1.5, // Reduced from 1.0 to 0.8
                child: SvgPicture.asset('assets/rings/ring3.svg', fit: BoxFit.contain),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _scaleAnimation3,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation3.value,
              child: SizedBox(
                width: widget.size * 2, // Reduced from 1.0 to 0.8
                height: widget.size * 2, // Reduced from 1.0 to 0.8
                child: SvgPicture.asset('assets/rings/ring4.svg', fit: BoxFit.contain),
              ),
            );
          },
        ),
      ],
    );
  }
}