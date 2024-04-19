

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc/page/week_page.dart';
import 'package:flutter_weather_bloc/repository/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dayKey = '';
  double maxTemp = 0.0;
  double minTemp = 0.0;
  int  isSelected = -1;
  List<Map<String, dynamic>> hourlyData = [];

  double _longitude = 0.0;
  double _latitude = 0.0;

  late WeatherBloc _weatherBloc;
  double currentTemperature = 21.0; // Track the currently displayed temperature
  double currentwind = 7.5; // Track the currently displayed temperature
  double currenthuyimidty = 21; // Track the currently displayed temperature

  String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
  String cityName = 'Loading...'; // Initial value while fetching city name
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        print(_longitude);
        print(_latitude);
      });
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  @override
  void initState()  {
    super.initState();
    // Determine position asynchronously
    _weatherBloc  =  WeatherBloc(WeatherRepository());

    _determinePosition().then((_) {
      // After determining position, get location
      _getLocation().then((_) {
        // After getting location, fetch city name if needed
        //_fetchCityName();

        final todayData = []; // Initialize with empty list
        setState(() {
          _weatherBloc.add(FetchWeatherEvent(latitude: _longitude, longitude: _latitude));
        });
      });
    });

  }




  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  Future<String?> getCityName(double latitude, double longitude) async {
    final apiKey = 'AIzaSyAOVYRIgupAurZup5y1PRh8Ismb1A3lLao';
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("succce city");

        final decodedResponse = json.decode(response.body);
        final results = decodedResponse['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final addressComponents = results[0]['address_components'] as List<dynamic>;
          for (final component in addressComponents) {
            final types = component['types'] as List<dynamic>;
            if (types.contains('locality')) {
              return component['long_name'] as String?;
            }
          }
        }
      }
      // Handle any other response status codes or errors
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedItemInfo = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;


      if(selectedItemInfo !=null){
      String dayKey = selectedItemInfo['dayKey'];
      double maxTemp = selectedItemInfo['maxTemp'];
      double minTemp = selectedItemInfo['minTemp'];
      // Access hourly temperature data here

      // Display selected item's information
      return Scaffold(
        appBar: AppBar(
          title: Text('Selected Item Information'),
        ),
        body: Center(
          child: Text('Selected Item: $dayKey, Highest: $maxTemp°C, Lowest: $minTemp°C'),
        ),
      );
    }else{
      return Scaffold(

        backgroundColor: Colors.black,
        body: BlocBuilder<WeatherBloc, WeatherState>(
          bloc: _weatherBloc,
          builder: (context, state) {
            if (state is WeatherInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WeatherLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WeatherLoaded) {

              final weatherData = state.weather;
              final todayData = weatherData.hourly.temperature2M.sublist(
                0,
                24,
              );

              final todaywind = weatherData.hourly.windSpeed10M.sublist(
                0,
                24,
              );
              final todayhuyumidty = weatherData.hourly.relativeHumidity2M.sublist(
                0,
                24,
              );


              if (todayData.isEmpty) {
                return Center(
                  child: Text('No data available'),
                );
              }
              return Column(

                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        color: Colors.blue
                    ),
                    // height: 450,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.white60,width: 2), ),
                                    child:Icon(Icons.menu,color: Colors.white60,),


                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,color: Colors.white,),
                                  Text("Tashkent",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      height: 25,
                                      width: 25,
                                      child:
                                      Image.asset("assets/dots.png",color: Colors.white,)
                                  ),
                                ],
                              ),
                            ],

                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                  border: Border.all(color: Colors.white60,width: 2), ),
                                child:Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [

                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: Colors.white),
                                      ),
                                      SizedBox(width: 3,),
                                      Text("Updating",style: TextStyle(color: Colors.white,fontSize: 10),)

                                    ],
                                  ),
                                )


                            ),

                          ],
                        ),
                        Container(
                            height: 150,
                            child:
                            Image.asset("assets/sunny2.png")
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${currentTemperature}",style: TextStyle(fontSize: 50,color: Colors.white),),
                            Text("°",style: TextStyle(color: Colors.white60,fontSize: 35),)

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Thunderstorm",style: TextStyle(fontSize: 25,color: Colors.white),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(formattedDate,style: TextStyle(color: Colors.white70),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.wind_power,color: Colors.white,),
                                      Text("${currentwind}km/h",style: TextStyle(color: Colors.white),),
                                      Text("wind",style: TextStyle(color: Colors.white70),),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.water_drop,color: Colors.white,),
                                          Text("${currenthuyimidty}%",style: TextStyle(color: Colors.white70),),
                                          Text("Humidity",style: TextStyle(color: Colors.white70)),
                                        ],
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.grain,color: Colors.white,),
                                          Text("87%",style: TextStyle(color: Colors.white70)),
                                          Text("chance of rain",style: TextStyle(color: Colors.white70)),
                                        ],
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WeekPage()),
                                );                           },
                              child: Row(
                                children: [
                                  Text("7 days",style: TextStyle(color: Colors.white70),),
                                  Icon(Icons.arrow_forward_ios,color: Colors.white70,)
                                ],
                              ),
                            )

                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120, // Set the height for horizontal scrolling
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: todayData.length,
                            itemBuilder: (context, index) {
                              final temperature = todayData[index];
                              final timeString = weatherData.hourly.time[index];
                              final time = DateTime.parse(timeString);
                              final wind = todaywind[index];
                              final huyimidity = todayhuyumidty[index];
                              if (time.isAfter(DateTime.now())) {
                                return GestureDetector(
                                  onTap: () {
                                    print("Item $index tapped"); // Check if onTap is triggered
                                    setState(() {
                                      currentTemperature=temperature;
                                      currenthuyimidty=huyimidity.toDouble();
                                      currentwind=wind;
                                      isSelected =index; // Toggle selection
                                      print("isSelected: $isSelected"); // Debug print
                                    });
                                  },
                                  child: Container(
                                    width: 100, // Specify the width for each item
                                    margin: EdgeInsets.symmetric(horizontal: 4), // Add margin for spacing between items
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white60
                                      ),
                                      color: isSelected==index ? Colors.blue : Colors.transparent, // Change the color based on isSelected
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$temperature°C',
                                          style: TextStyle(fontSize: 14, color: Colors.white),
                                        ),
                                        Container(
                                          height: 25,
                                          child: Image.asset("assets/sunny2.png"),
                                        ),
                                        Text(
                                          '${time.hour}:${time.minute}0',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(); // Return an empty container for items where the time is before the current time
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )


                ],
              );

            } else if (state is WeatherError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return Container();
            }
          },
        ),
      );

    }

  }

  @override
  void dispose() {
    _weatherBloc.close();
    super.dispose();
  }
}

extension DateTimeExtension on DateTime {
  String format(BuildContext context) {
    return DateFormat.yMMMMd().add_jm().format(this).toUpperCase();
  }
}


