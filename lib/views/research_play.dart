import 'package:flutter/material.dart';
import 'package:foundation/widgets/widgets.dart';

class ResearchPlay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Research')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ',
                  style: TextStyle()
                )
              ],
            )
          ),
        )
    );
  }
}
