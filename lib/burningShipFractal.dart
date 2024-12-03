import 'dart:ui';
import 'package:flutter/material.dart';

class BurningShipFractal extends StatefulWidget {
  const BurningShipFractal({super.key});

  @override
  State<BurningShipFractal> createState() {
    return _BurningShipFractalState();
  }
}

class _BurningShipFractalState extends State<BurningShipFractal> {
  FragmentShader? _shader; // Nullable until initialized
  double _zoom = 2.0;
  Offset _offset = const Offset(0, 0);
  final int _maxIterations = 200;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShader();
    });
    super.initState();
  }

  void _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset(
          'shaders/burningShipShader.frag');
      setState(() {
        _shader = program.fragmentShader(); // Initialize the shader
      });
    } catch (e) {
      print('Failed to load shader: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Burning Ship Fractal')),
      body: _shader == null
          ? const Center(child: CircularProgressIndicator()) // Show a loading indicator
          : GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset -= details.delta / (200.0 / _zoom);
          });
        },
        // onScaleUpdate: (details) {
        //   setState(() {
        //     _zoom *= details.scale.clamp(0.5, 2.0);
        //     _offset -= details.focalPointDelta / (_zoom*100.0);
        //   });
        // },
        child: CustomPaint(
          painter: _FractalPainter(
            shader: _shader!,
            zoom: _zoom,
            offset: _offset,
            maxIterations: _maxIterations,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _FractalPainter extends CustomPainter {
  final FragmentShader shader;
  final double zoom;
  final Offset offset;
  final int maxIterations;

  _FractalPainter({
    required this.shader,
    required this.zoom,
    required this.offset,
    required this.maxIterations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, offset.dx);
    shader.setFloat(3, offset.dy);
    shader.setFloat(4, zoom);
    shader.setFloat(5, maxIterations.toDouble());

    final paint = Paint()..shader = shader;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
