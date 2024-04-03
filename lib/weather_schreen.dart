import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/SECRETC.dart';
import 'additional_forecast_info.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
 class WeatherSchreen extends StatefulWidget {
  const WeatherSchreen({super.key});

  @override
  State<WeatherSchreen> createState() => _WeatherSchreenState();
}

class _WeatherSchreenState extends State<WeatherSchreen> {
  
  @override
  void initState() {
    super.initState();
    getCurrentweather();
  }
Future<Map<String,dynamic>> getCurrentweather() async {
  try{String cityName = 'London';
     final res = await
    http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey',)
    );
    final data = jsonDecode(res.body);
    if (data['cod'] != '200'){throw 'An unexpected error occured';}
    return data;
  
    }
    catch(e){
      throw e.toString();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Weather app',style: TextStyle(fontWeight: FontWeight.bold ),),centerTitle: true,
        actions:  [IconButton(onPressed: () {setState(() {
          
        });}, icon: const Icon(Icons.refresh))],
      ),
      body:  FutureBuilder(
        future: getCurrentweather(),
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator.adaptive(),);
          }
          if (snapshot.hasError)
          {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentSpeed = currentWeatherData['wind']['speed'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
              [SizedBox(width: double.infinity,child: Card(elevation: 10,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ClipRRect( borderRadius: BorderRadius.circular(16) ,
               child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                 child: Padding(
                   padding:const  EdgeInsets.all(16.0),
                   child: Column(children: [Text('$currentTemp ° K',style:const TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),const SizedBox(height: 16,), Icon(currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny,size: 75,),const SizedBox(height: 10,), Text('$currentSky',style:const TextStyle(fontSize: 20),)],),
                 ),
               ),
             ),)),
             const SizedBox(height: 20,),
             const Text('Hourly Forecast',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
             const SizedBox(height: 10,),
            
             SizedBox(
              height: 120,
               child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: 8, itemBuilder: (context, index)
               {
                
                final hourlyForecastItem = data['list'][index + 1];
                final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                final hourlyTemp = hourlyForecastItem['main']['temp'];
                final time = DateTime.parse(hourlyForecastItem['dt_txt'].toString()) ;
                 return HourlyForecastItem(time: DateFormat.j().format(time), temperature: hourlyTemp.toString(), icon: hourlySky  == 'Clouds' || hourlySky == 'Rain' ? Icons.cloud : Icons.sunny);
               },),
             ),
             const SizedBox(height: 20,),
            const Text('Additional information' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
            const SizedBox(height: 10,),
             Row( 
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: 
              [
               Additionalforecastinfo
               (
                icon: Icons.water_drop,
                label: 'Humidity',
                value: currentHumidity.toString(),
               ),
               Additionalforecastinfo
               (
                icon: Icons.air,
                label: 'Wind Speed',
                value: currentSpeed.toString(),
               ),
               Additionalforecastinfo
               (
                icon: Icons.beach_access,
                label: 'Pressure',
                value: currentPressure.toString(),
               ),
               
               
              ],)
             ], 
          ),
        );
        },
      ),
      
    );
    
  }
}



