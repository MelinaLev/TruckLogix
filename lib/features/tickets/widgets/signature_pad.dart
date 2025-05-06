import 'dart:ui';
import 'package:flutter/material.dart';

class SignaturePad extends StatefulWidget {
  final Function(List<Offset>)? onSignatureChanged;

  const SignaturePad({
    super.key,
    this.onSignatureChanged,
  });

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<Offset> _points = [];

  void _onPanStart(DragStartDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      _points.add(localPosition);
    });
    if (widget.onSignatureChanged != null) {
      widget.onSignatureChanged!(_points);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      _points.add(localPosition);
    });
    if (widget.onSignatureChanged != null) {
      widget.onSignatureChanged!(_points);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _points.add(Offset.infinite); // Add a separator for multiple strokes
    });
    if (widget.onSignatureChanged != null) {
      widget.onSignatureChanged!(_points);
    }
  }

  void clear() {
    setState(() {
      _points.clear();
    });
    if (widget.onSignatureChanged != null) {
      widget.onSignatureChanged!(_points);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CustomPaint(
              painter: SignaturePainter(points: _points),
            ),
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: clear,
            tooltip: 'Clear Signature',
            color: const Color(0xFF15385E),
          ),
        ),
      ],
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      // Skip drawing if the current point or next point is a separator
      if (points[i] == Offset.infinite || points[i + 1] == Offset.infinite) {
        continue;
      }

      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
