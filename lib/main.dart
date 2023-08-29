import 'package:flutter/material.dart';
import 'package:travel_book/save_travel/travelPeopleNumber.dart';
import 'package:travel_book/save_travel/travelPeriod.dart';
import 'package:travel_book/travel_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travel_book/travel_sql.dart';

import 'test.dart';


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

  final DatabaseService _databaseService = DatabaseService();
  Future<List<Travel>> _travelList = DatabaseService()
      .databaseConfig()
      .then((_) => DatabaseService().selectTravels());

  int currentCount = 0;


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height * 0.6;

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
                Container(
                  height: height,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    ),
                  ),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: FutureBuilder(
                          future: _travelList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              currentCount = snapshot.data!.length;
                              if (currentCount == 0) {
                                return const Center(
                                  child: Text("No data exists."),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return travelBox(
                                        snapshot.data![index].id,
                                        snapshot.data![index].name);
                                    },
                                );
                              }
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text("Error."),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                            );
                          }
                        },
                      )
                    ),
                  ),
                )
                ]
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        addTravelBottomSheet();
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

  Widget travelBox(int id, String name) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("$id"),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(name),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // updateButton(id),
              const SizedBox(width: 10),
              deleteButton(id),
            ],
          ),
        ),
      ],
    );
  }

  Widget deleteButton(int id) {
    return ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => deleteWordDialog(id),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: const Icon(Icons.delete));
  }

  TextEditingController travelNameView = TextEditingController();
  static String travelName = '';
  final formKey = GlobalKey<FormState>();

  var select_start_date = '여행 시작일';
  var select_end_date = '여행 종료일';
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();

  Widget deleteWordDialog(int id) {
    return AlertDialog(
      title: const Text("이 여행을 삭제하시겠습니까?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _databaseService.deleteTravel(id).then(
                        (result) {
                      if (result) {
                        Navigator.of(context).pop();
                        setState(() {
                          _travelList = _databaseService.selectTravels();
                        });
                      } else {
                        print("delete error");
                      }
                    },
                  );
                },
                child: const Text("예"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("아니오"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addTravelBottomSheet() {
    double height = MediaQuery.of(context).size.height * 0.8;

    showModalBottomSheet(
        context: context,
        // backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: height,
            decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child:
            Padding(
              padding: const EdgeInsets.all(10),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: Column (

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: travelNameView,
                      style: const TextStyle(
                          letterSpacing: 2,
                          decorationThickness: 0
                      ),
                      cursorColor: Colors.redAccent[100],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            // focusColor: Colors.redAccent[100],
                            onPressed: () {
                              travelNameView.clear();
                            }),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.redAccent[100]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.redAccent[100]!),
                        ),
                        hintText: '필수 입력',
                      ),
                      onChanged: (String str) {
                        setState(() => travelName = str);
                        debugPrint(travelName);
                      },
                      onSaved: (val) {
                        travelName = val!;
                      },
                      validator: (val) {
                        if(val!.isEmpty) {
                          return '아무것도 입력되지 않았습니다.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TravelPeriod(),
                    const SizedBox(height: 15),
                    TravelPeopleNumber(),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        _databaseService
                            .insertTravel(Travel(
                            id: currentCount + 1,
                            name: travelNameView.text))
                            .then(
                              (result) {
                            if (result) {
                              Navigator.of(context).pop();
                              setState(() {
                                _travelList = _databaseService.selectTravels();
                              });
                            } else {
                              print("insert error");
                            }
                          },
                        );
                      },
                      child: const Text("생성"),
                    ),
                  ],
                )
                ),
              ),
            );
        }
    );
  }

}
