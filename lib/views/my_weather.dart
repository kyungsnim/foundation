// import 'package:flutter/material.dart';
// import 'package:foundation/widgets/widgets.dart';
//
// class MyWeather extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<GeoController>(
//         builder: (_) {
//           return Scaffold(
//               appBar: AppBar(
//                 title: Text('Location'),
//               ),
//               body: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Center(child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Current Location'),
//                     geoController.position == null ? SizedBox() : Text(geoController.position!.latitude.toString()),
//                     geoController.position == null ? SizedBox() : Text(geoController.position!.longitude.toString()),
//                     FormVerticalSpace(),
//                     PrimaryButton(labelText: '현재 위치 도시 찾기', onPressed: () {
//
//                     })
//                   ],
//                 )),
//               ));
//         }
//     );
//   }
// }
