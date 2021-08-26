import 'package:flutter/material.dart';
import 'package:foundation/widgets/widgets.dart';
import 'package:get/get.dart';

class ResearchHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Research')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: PrimaryButton(
            labelText: '설문조사 시작',
            onPressed: () => Get.toNamed('research_play'),
          ),
        ),
      )
    );
  }
}
