import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lines of Destiny',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  int? _dateResult;
  List<int> _path = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, int dateNumber) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
    );
    if (picked != null) {
      setState(() {
        if (dateNumber == 1) {
          _selectedDate1 = picked;
        } else {
          _selectedDate2 = picked;
        }
        _calculateDateResult();
      });
    }
  }

  void _calculateDateResult() {
    if (_selectedDate1 != null && _selectedDate2 != null) {
      final date1Str = "${_selectedDate1!.day.toString().padLeft(2, '0')}${_selectedDate1!.month.toString().padLeft(2, '0')}${_selectedDate1!.year}";
      final date2Str = "${_selectedDate2!.day.toString().padLeft(2, '0')}${_selectedDate2!.month.toString().padLeft(2, '0')}${_selectedDate2!.year}";
      final date1Int = int.parse(date1Str);
      final date2Int = int.parse(date2Str);
      setState(() {
        _dateResult = date1Int + date2Int;
        _path = _dateResult.toString().split('').map((e) => int.parse(e)).where((e) => e != 0).toList();
        _controller.duration = Duration(milliseconds: 500 * (_path.length - 1));
        _startAnimation();
      });
    }
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Lines of Destiny',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 3, 31, 44)),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      _selectedDate1 == null
                          ? 'DD-MM-YYYY'
                          : 'Your Birthday',
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, 1),
                      child: Text(_selectedDate1 == null
                          ? 'Set your Birth Day'
                          : '${_selectedDate1!.day.toString().padLeft(2, '0')}-${_selectedDate1!.month.toString().padLeft(2, '0')}-${_selectedDate1!.year}'),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      _selectedDate2 == null
                          ? 'DD-MM-YYYY'
                          : 'Date of Interest',
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _selectedDate1 == null ? null : () => _selectDate(context, 2),
                      child: Text(_selectedDate2 == null
                          ? 'Set Date of Interest'
                          : '${_selectedDate2!.day.toString().padLeft(2, '0')}-${_selectedDate2!.month.toString().padLeft(2, '0')}-${_selectedDate2!.year}'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(
                  TextSpan(
                    text: 'Points of Destiny ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${_dateResult ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the shadow to be visible
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha((255 * 0.5).round()),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 250, // Adjust size as needed
                  height: 250, // Adjust size as needed
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: LinePainter(_path, _animation.value),
                        child: Container(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<int> path;
  final double progress;
  List<Offset> points = [];

  LinePainter(this.path, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    final double side = size.width < size.height ? size.width : size.height;
    final double cellWidth = side / 3;
    final double cellHeight = side / 3;

    points = List.generate(9, (index) {
      final row = index ~/ 3;
      final col = index % 3;
      return Offset(col * cellWidth + cellWidth / 2, row * cellHeight + cellHeight / 2);
    });

    for (final point in points) {
      canvas.drawCircle(point, 5, paint);
    }

    if (path.length < 2) return;

    final pathPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4;

    final totalProgress = progress * (path.length - 1);

    for (int i = 0; i < path.length - 1; i++) {
      if (totalProgress > i) {
        final startPointIndex = path[i] - 1;
        final endPointIndex = path[i + 1] - 1;

        if (startPointIndex < 0 || startPointIndex >= 9 || endPointIndex < 0 || endPointIndex >= 9) {
          continue;
        }

        final startPoint = points[startPointIndex];
        final endPoint = points[endPointIndex];
        
        final segmentProgress = totalProgress - i;
        final currentPoint = Offset.lerp(startPoint, endPoint, segmentProgress.clamp(0.0, 1.0))!;
        canvas.drawLine(startPoint, currentPoint, pathPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}