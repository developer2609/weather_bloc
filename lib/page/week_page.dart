import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../repository/weather_repository.dart';

class WeekPage extends StatefulWidget {
   WeekPage({super.key});

  @override
  State<WeekPage> createState() => _WeekPageState();
}
double _latitude = 0.0;
double _longitude = 0.0;
class _WeekPageState extends State<WeekPage> {
  late WeatherBloc _weatherBloc;
  late List<bool> isSelected;
  final int indexs=0;
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
  void initState() {
    super.initState();
      _getLocation();
    _weatherBloc = WeatherBloc(WeatherRepository());
    _weatherBloc.add(FetchWeatherEvent(latitude: 69.2857047, longitude:41.3790986,));
  }
  double currentTemperature = 21.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000918),
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
            final List<String> time = weatherData.hourly.time;
            final List<double> temperatures = weatherData.hourly.temperature2M;
            Map<String, List<double>> dailyTemperatures = {};
            for (int i = 0; i < time.length; i++) {
              DateTime dateTime = DateTime.parse(time[i]);
              String dayKey = DateFormat('yyyy-MM-dd').format(dateTime);
              if (!dailyTemperatures.containsKey(dayKey)) {
                dailyTemperatures[dayKey] = [];
              }
              dailyTemperatures[dayKey]!.add(temperatures[i]);
            }
            // Find highest and lowest temperatures for each day
            Map<String, Map<String, double>> dailyMinMaxTemperatures = {};
            dailyTemperatures.forEach((key, value) {
              double maxTemp = value.reduce((curr, next) => curr > next ? curr : next);
              double minTemp = value.reduce((curr, next) => curr < next ? curr : next);
              dailyMinMaxTemperatures[key] = {'max': maxTemp, 'min': minTemp};
            });
            final todayData = weatherData.hourly.temperature2M.sublist(
              0,
              24,
            );
            isSelected = List.filled(todayData.length, false); // Initialize isSelected list
// Get tomorrow's date

// Find the index of tomorrow's date in the list of dates

            String dayKey = dailyMinMaxTemperatures.keys.toList()[1];
            double maxTemp = dailyMinMaxTemperatures[dayKey]!['max']!;
            double minTemp = dailyMinMaxTemperatures[dayKey]!['min']!;




            if (todayData.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            }
            return
                Column(
                children: [
                  Container(
                     padding: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.7), // Set the color of the shadow
                              spreadRadius: 10, // Set the spread radius of the shadow
                              blurRadius: 10, // Set the blur radius of the shadow
                              offset: Offset(0, 3), // Set the offset of the shadow
                            ),
                          ],
                          color: Colors.blue
                      ),

                      child:Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                          border: Border.all(color: Colors.white60,width: 2), ),
                                      child:Center(child: GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                       child:Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,size: 20,)
                                      
                                      ),
                                          
          )
                                      


                                    ),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,color: Colors.white,size: 18,),
                                    SizedBox(width: 3,),
                                    Text("7 days",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Tommorow",style: TextStyle(color: Colors.white,fontSize: 20),)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 130,
                                        width: 130,
                                        child:
                                        Image.asset("assets/sunny2.png")
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20,),
                                Row(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("$maxTemp",style: TextStyle(fontSize: 50,color: Colors.white),)
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("/${minTemp}°",style: TextStyle(fontSize: 25,color: Colors.white70),)
                                      ],
                                    ),
                                  ],
                                )

                              ],

                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Rainy-Cloudly",style: TextStyle(color: Colors.white70),)
                            ],
                          ),
                          Divider(
                            color: Colors.white30,
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
                                        Text("13km/",style: TextStyle(color: Colors.white),),
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
                                            Text("24%",style: TextStyle(color: Colors.white70),),
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
                      )

                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child:
                    ListView.builder(
                      itemCount: dailyMinMaxTemperatures.length,
                      itemBuilder: (context, index) {
                        String dayKey = dailyMinMaxTemperatures.keys.toList()[index];
                        DateTime dateTime = DateTime.parse(dayKey);
                        String dayName = DateFormat('EEEE').format(dateTime);

                        double maxTemp = dailyMinMaxTemperatures[dayKey]!['max']!;
                        double minTemp = dailyMinMaxTemperatures[dayKey]!['min']!;

                        return GestureDetector(
                          onTap:(){

                          }
                                                   ,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(dayName,style: TextStyle(color: Colors.white60),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/sunny2.png",height: 30,width: 30,),
                                    SizedBox(width: 2,),

                                    Text("Rainy",style: TextStyle(color: Colors.white,fontSize: 18),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${maxTemp}°",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                    SizedBox(width: 2,),
                                    Text("${minTemp}°",style: TextStyle(color: Colors.white60),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                        ListTile(
                          title: Text(dayName),
                          subtitle: Text('Highest: $maxTemp°C, Lowest: $minTemp°C'),
                        );
                      },
                    ),
                  )

          ],
              ) ;



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
  }@override
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