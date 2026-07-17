import 'package:flutter/material.dart';

class ShimmerGradient extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const ShimmerGradient({
    super.key,
    required this.child,
    this.colors = const [Color(0xFF5C6BC0), Color(0xFFAB47BC), Color(0xFF5C6BC0)],
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<ShimmerGradient> createState() => _ShimmerGradientState();
}

class _ShimmerGradientState extends State<ShimmerGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 3.0 * _controller.value, 0),
              end: Alignment(1.0 + 3.0 * _controller.value, 0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
