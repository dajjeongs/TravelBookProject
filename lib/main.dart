import 'package:flutter/material.dart';
import 'package:travel_book/save_travel/saveTravelPage.dart';
import 'package:travel_book/travel_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Cash Book',
      home: TravelCashBook(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko','KR'),
      ],
    );
  }
}

class TravelCashBook extends StatefulWidget {
  @override
  _TravelCashBook createState() => _TravelCashBook();
}

class _TravelCashBook extends State<TravelCashBook> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Cash Book',
          style: TextStyle(
              letterSpacing: 1
          ),),
        centerTitle: true,
        backgroundColor: Colors.red[200],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 30, 15, 10),
        child:
        SingleChildScrollView(
          child: Column(
            children: [
              const Column(
                children: [
                  Text('여행',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black45,
                        letterSpacing: 2.0
                    ),
                  ),
                  Divider(
                    height: 20.0,
                    thickness: 1,
                    endIndent: 15.0,
                  ),
                ],
              ),
              Column(
                children: [
                  travelList()
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => SaveTravelPage()
                              )
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                          side: const BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 3
                          )
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text('추가',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1
                            ),
                          )
                        ],
                      )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
