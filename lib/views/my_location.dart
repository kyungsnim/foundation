import 'package:flutter/material.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:foundation/widgets/widgets.dart';

import 'package:get/get.dart';

class MyLocation extends StatelessWidget {
  GeoController geoController = GeoController.to;
  @override
  Widget build(BuildContext context) {
    geoController.getCurrentPosition();
    return GetBuilder<GeoController>(
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Location'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Current Location'),
                    geoController.position == null ? SizedBox() : Text(geoController.position!.latitude.toString()),
                    geoController.position == null ? SizedBox() : Text(geoController.position!.longitude.toString()),
                    FormVerticalSpace(),
                    PrimaryButton(labelText: '현재 위치 날씨 정보 보기', onPressed: () {
                      geoController.getCurrentWeatherByLocation(geoController.position!.latitude, geoController.position!.longitude);

                    }),
                    FormVerticalSpace(),
                    Text('Current Weather'),
                    geoController.w == null ? SizedBox() : Text('rainLastHour : ${geoController.w!.rainLastHour.toString()}'),
                    geoController.w == null ? SizedBox() : Text('rainLast3Hours : ${geoController.w!.rainLast3Hours.toString()}'),
                    geoController.w == null ? SizedBox() : Text('areaName : ${geoController.w!.areaName.toString()}'),
                    geoController.w == null ? SizedBox() : Text('cloudiness : ${geoController.w!.cloudiness.toString()}'),
                    geoController.w == null ? SizedBox() : Text('country: ${geoController.w!.country.toString()}'),
                    geoController.w == null ? SizedBox() : Text('date : ${geoController.w!.date.toString()}'),
                    geoController.w == null ? SizedBox() : Text('humidity : ${geoController.w!.humidity.toString()}'),
                    geoController.w == null ? SizedBox() : Text('pressure : ${geoController.w!.pressure.toString()}'),
                    geoController.w == null ? SizedBox() : Text('sunset : ${geoController.w!.sunset.toString()}'),
                    geoController.w == null ? SizedBox() : Text('sunrise: ${geoController.w!.sunrise.toString()}'),
                    geoController.w == null ? SizedBox() : Text('weatherDescription : ${geoController.w!.weatherDescription.toString()}'),
                    geoController.w == null ? SizedBox() : Text('windSpeed: ${geoController.w!.windSpeed.toString()}'),
                    geoController.w == null ? SizedBox() : Text('windDegree : ${geoController.w!.windDegree.toString()}'),
                    geoController.w == null ? SizedBox() : Text('weatherMain: ${geoController.w!.weatherMain.toString()}'),
                    geoController.w == null ? SizedBox() : Text('windGust : ${geoController.w!.windGust.toString()}'),
                    geoController.w == null ? SizedBox() : Text('temperature: ${geoController.w!.temperature.toString()}'),
                    geoController.w == null ? SizedBox() : Text('tempFeelsLike: ${geoController.w!.tempFeelsLike.toString()}'),
                    geoController.w == null ? SizedBox() : Text('tempMin: ${geoController.w!.tempMin.toString()}'),
                    geoController.w == null ? SizedBox() : Text('tempMax: ${geoController.w!.tempMax.toString()}'),
                    geoController.w == null ? SizedBox() : Text('snowLastHour : ${geoController.w!.snowLastHour.toString()}'),
                    geoController.w == null ? SizedBox() : Text('snowLast3Hour: ${geoController.w!.snowLast3Hours.toString()}'),
                  ],
                )),
              ));
        }
    );
  }
}
