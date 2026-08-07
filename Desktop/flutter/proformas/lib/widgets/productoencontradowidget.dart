import 'package:flutter/material.dart';

class ProductoEncontradoAnimation extends StatefulWidget {
  const ProductoEncontradoAnimation({
    super.key,
    this.onFinish,
  });

  final VoidCallback? onFinish;

  @override
  State<ProductoEncontradoAnimation> createState() =>
      _ProductoEncontradoAnimationState();
}

class _ProductoEncontradoAnimationState
    extends State<ProductoEncontradoAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _mostrar();
  }

  Future<void> _mostrar() async {
    await _controller.forward();

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    await _controller.reverse();

    widget.onFinish?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 25,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  Icons.thumb_up,
                  size: 70,
                  color: Colors.green,
                ),

                SizedBox(height: 10),

                Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  '',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}