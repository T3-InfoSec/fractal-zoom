import 'dart:ui';
import 'package:flutter/gestures.dart';
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
  double _zoom = 2.0; // todo: zoom
  Offset _offset = const Offset(0, 0);
  Offset _mousePosition = const Offset(0, 0);
  Offset _selectedPosition = const Offset(0.0, 0.0); // todo: selected position
  final double _gridSize = 0.00001;

  final int _maxIterations = 100; // todo: max iterations

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShader();
    });
    super.initState();
  }

  void _loadShader() async {
    try {
      final program =
          await FragmentProgram.fromAsset('shaders/burningShipAdv.frag');
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
            ? const Center(
                child: CircularProgressIndicator()) // Show a loading indicator
            : Listener(
                onPointerSignal: (PointerSignalEvent event) {
                  if (event is PointerScrollEvent) {
                    setState(() {
                      // Adjust zoom level based on scroll delta
                      var zoomFactor = event.scrollDelta.dy  > 0 ? 1.1 : 0.9;
                      var zoomDelta = zoomFactor  * zoomFactor * (event.scrollDelta.dy > 0 ? 1: -1);
                      _zoom *= zoomFactor;
                      print("position ${event.position}");
                      var mouseX = event.position.dx/ MediaQuery.of(context).size.width;
                      var mouseY = event.position.dy / MediaQuery.of(context).size.height;
                      var aspectRatio = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
                      // _offset = _offset - Offset(-mouseX * zoomDelta *aspectRatio, -mouseY * zoomDelta);
                      // print(_offset);
                      print(_zoom);
                    });
                  }
                },
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      _selectedPosition = details.localPosition;
                      var aspectRatio = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
                      var mouseX = details.localPosition.dx/ MediaQuery.of(context).size.width;
                      var mouseY = details.localPosition.dy/ MediaQuery.of(context).size.height;
                      var pos =  Offset(_zoom * aspectRatio * mouseX + 0.5 * _gridSize,
                          _zoom * mouseY + 0.5 * _gridSize);
                      print(pos);
                      print(_selectedPosition);
                    });
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      // var zoomFactor = event.scrollDelta.dy  > 0 ? 1.1 : 0.9;
                      // var zoomDelta = zoomFactor  * zoomFactor * (event.scrollDelta.dy > 0 ? 1: -1);
                      // _zoom *= zoomFactor;
                      _zoom *= (1/details.scale.clamp(0.99, 1.01));

                      if(details.scale != 1.0) {
                        // var zoomFactor = details.scale  > 1.0 ? 1.1 : 0.9;
                        //
                        // _zoom *= zoomFactor * details.scale;
                        print("scale ${details.scale.clamp(0.99, 1.01)}");
                      }
                      // print(_zoom);
                        _offset -= details.focalPointDelta * _zoom/ 1000.0;
                      // print('${(details.focalPointDelta / (_zoom * 100.0)).dx}, ${(details.focalPointDelta / (_zoom * 100.0)).dy}');
                    });
                  },
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
              ));
  }
}

class _BurningShipAdvFractalPainter extends CustomPainter {
  final FragmentShader shader;
  final double zoom;
  final Offset offset;
  final int maxIterations;
  final double gridSize;
  Offset selectedPosition;

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
    shader.setFloat(6, gridSize);
    shader.setFloat(7, selectedPosition.dx);
    shader.setFloat(8, selectedPosition.dy);
    // shader.setFloat(6, 0.0);

    final paint = Paint()..shader = shader;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
