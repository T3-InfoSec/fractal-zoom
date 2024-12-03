import 'dart:ui';
import 'package:flutter/material.dart';

class BurningShipFractalAdv extends StatefulWidget {
  const BurningShipFractalAdv({super.key});

  @override
  State<BurningShipFractalAdv> createState() {
    return _BurningShipFractalAdvState();
  }
}

class _BurningShipFractalAdvState extends State<BurningShipFractalAdv> {
  FragmentShader? _shader; // Nullable until initialized
  final double _zoom = 2.0; // todo: zoom
  Offset _offset = const Offset(0, 0);
  final Offset _selectedPosition = const Offset(0.0, 0.0); // todo: selected position
  final double _gridSize = 0.00001;

  final int _maxIterations = 200; // todo: max iterations

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
          'shaders/burningShipAdv.frag');
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
          painter: _BurningShipAdvFractalPainter(
            shader: _shader!,
            zoom: _zoom,
            offset: _offset,
            maxIterations: _maxIterations,
            gridSize: _gridSize,
            selectedPosition: _selectedPosition,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _BurningShipAdvFractalPainter extends CustomPainter {
  final FragmentShader shader;
  final double zoom;
  final Offset offset;
  final int maxIterations;
  final double gridSize;
  final Offset selectedPosition;

  _BurningShipAdvFractalPainter({
    required this.shader,
    required this.zoom,
    required this.offset,
    required this.maxIterations,
    required this.gridSize,
    required this.selectedPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, offset.dx);
    shader.setFloat(3, offset.dy);
    shader.setFloat(4, zoom);
    shader.setFloat(5, maxIterations.toDouble());
    // shader.setFloat(7, gridSize);
    // shader.setFloat(8, selectedPosition.dx);
    // shader.setFloat(9, selectedPosition.dy);
    shader.setFloat(6, 0.0);

    final paint = Paint()..shader = shader;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
