  import 'package:flutter/material.dart';
  import 'package:joint_stats_official/tjc.dart';

  class SJC extends StatefulWidget {
    const SJC({super.key});
    

    @override
    State<SJC> createState() => _SJCState();
  }

  class _SJCState extends State<SJC> {
    late double screenWidth;
    late double screenHeight;
    void initState() {
      super.initState();
      setState(() {
        
      });
    }

   

      List<Point> points = [
        // Right
        Point(id: 1, x: 86, y: 106, size: 27, color: Colors.green), //shoulder
        Point(id: 2, x: 61, y: 161, size: 27, color: Colors.green), //elbow
        Point(id: 3, x: 45, y: 209, size: 21.5, color: Colors.green), //wrist
        Point(id: 4, x: 77, y: 228, size: 9.3, color: Colors.green), //thump 1
        Point(id: 5, x: 96, y: 234, size: 10, color: Colors.green), //thump 2
        Point(id: 6, x: 69, y: 251, size: 10, color: Colors.green), //index 1
        Point(id: 7, x: 69, y: 274, size: 10, color: Colors.green), //index 2
        Point(id: 8, x: 53, y: 253, size: 10, color: Colors.green), //middle 1
        Point(id: 9, x: 53, y: 278, size: 10, color: Colors.green), //middle 2
        Point(id: 10, x: 35, y: 273, size: 10, color: Colors.green), //ring 2
        Point(id: 11, x: 35, y: 251, size: 10, color: Colors.green), //ring 1
        Point(id: 12, x: 23, y: 240, size: 10, color: Colors.green), //pinky 1
        Point(id: 13, x: 23, y: 262, size: 10, color: Colors.green), //pinky 2
        Point(id: 14, x: 101 , y: 276, size: 29, color: Colors.green), //knee
        // Left
        Point(id: 15, x: 216, y: 106, size: 27, color: Colors.green), //shoulder
        Point(id: 16, x: 244, y: 161, size: 27, color: Colors.green), //elbow
        Point(id: 17, x: 264, y: 210, size: 21.5, color: Colors.green), //wrist
        Point(id: 18, x: 244, y: 227, size: 9.3, color: Colors.green), //thump 1
        Point(id: 19, x: 225, y: 235, size: 10, color: Colors.green), //thump 2
        Point(id: 20, x: 252, y: 251, size: 10, color: Colors.green), //index 1
        Point(id: 21, x: 252, y: 273, size: 10, color: Colors.green), //index 2
        Point(id: 22, x: 269, y: 253, size: 10, color: Colors.green), //middle 1
        Point(id: 23, x: 269, y: 278, size: 10, color: Colors.green), //middle 2
        Point(id: 24, x: 286, y: 251, size: 10, color: Colors.green), //ring 1
        Point(id: 25, x: 286, y: 273, size: 10, color: Colors.green), //ring 2
        Point(id: 26, x: 298, y: 240, size: 10, color: Colors.green), //pinky 1
        Point(id: 27, x: 298, y: 261, size: 10, color: Colors.green), //pinky 2
        Point(id: 28, x: 202, y: 276, size: 29, color: Colors.green), //knee
      ];

      void handlePointClick(int id) {
        setState(() {
          points = points.map((point) {
            return point.id == id ? point.copyWith(color: Colors.red) : point;
          }).toList();
        });
      }



    @override
    Widget build(BuildContext context) {
      
      return Scaffold(
        appBar: AppBar(
          title: const Text("Swollen Joint Count (0–28)"),
          actions: [
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TJC()),
                  );
                }),
          ],
        ),
        backgroundColor: Colors.white,
        body: InteractiveViewer(
          minScale: 0.1,
          maxScale: 5.0,
          child: Center(
            child: Stack(
              children: [
                SizedBox(
                    height: 360,
                    width: 460,
                    child: Image.asset('assets/sjc.jpg', fit: BoxFit.fill)),
                for (var point in points)
                  ClickablePoint(
                    point: point,
                    onTap: handlePointClick,
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }

  class ClickablePoint extends StatelessWidget {
    final Point point;
    final Function(int) onTap;

    const ClickablePoint({super.key, required this.point, required this.onTap});

    @override
    Widget build(BuildContext context) {
      return Positioned(
        left: point.x,
        top: point.y,
        child: GestureDetector(
          onTap: () {
            onTap(point.id);
          },
          child: Container(
            width: point.size,
            height: point.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: point.color,
            ),
          ),
        ),
      );
    }
  }

  class Point {
    final int id;
    final double x;
    final double y;
    final double size;
    final Color color;

    Point({
      required this.id,
      required this.x,
      required this.y,
      required this.size,
      this.color = Colors.green,
    });

    Point copyWith({
      int? id,
      double? x,
      double? y,
      double? size,
      Color? color,
    }) {
      return Point(
        id: id ?? this.id,
        x: x ?? this.x,
        y: y ?? this.y,
        size: size ?? this.size,
        color: color ?? this.color,
      );
    }
  }
