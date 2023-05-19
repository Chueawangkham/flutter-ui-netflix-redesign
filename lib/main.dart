import 'package:flutter/material.dart';
import 'package:netflix_redesign/views/nav_bar.dart';

void main() {
  runApp(const NetFlixRedesign());
}

class NetFlixRedesign extends StatelessWidget {
  const NetFlixRedesign({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavBar(),
    );
  }
}
