import 'package:flutter/material.dart';
import 'package:travel_book/travelPage.dart';
import 'package:travel_book/travel_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travel_book/travel_sql.dart';
import 'travel_data.dart';


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

  List<String> people_number = ['1명', '2명', '3명', '4명', '5명 +'];
  String select_number = '';

  int currentCount = 0;


  void initState() {
    super.initState();
    setState(() {
      select_number = people_number[0];
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height * 0.65;

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
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
                                    child: Text("저장된 여행 일정이 없습니다.",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 17,
                                      color: Colors.black54
                                    ),),
                                  );
                                } else {
                                  return ListView(
                                    children: List.generate(snapshot.data!.length, (index) {
                                      return travelBox(
                                        snapshot.data![index].id,
                                        snapshot.data![index].name,
                                      );
                                    }),
                                  );
                                  // return ListView.builder(
                                  //   itemCount: snapshot.data!.length,
                                  //   itemBuilder: (context, index) {
                                  //     return travelBox(
                                  //         snapshot.data![index].id,
                                  //         snapshot.data![index].name);
                                  //     },
                                  // );
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
      ),
    );
  }

  Widget travelBox(int id, String name) {
    double boxHeight = MediaQuery.of(context).size.height * 0.15;
    double boxWidth = MediaQuery.of(context).size.width * 0.85;

    return Card(
      child:
        Container(
          height: boxHeight,
          width: boxWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), //모서리를 둥글게
              border: Border.all(color: Colors.grey, width: 2)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text("$id",
                      style: const TextStyle(
                          fontSize: 15
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        updateButton(id),
                        deleteButton(id),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => travelPage(travel: Travel(id: id, name: name),)
                    )
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(name,
                    style: const TextStyle(
                        fontSize: 20
                    ),),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
    );
  }

  Widget updateButton(int id) {
    return IconButton(
        onPressed: () {
          Future<Travel> travel = _databaseService.selectTravel(id);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => updateTravelDialog(travel),
          );
        },
        icon: const Icon(Icons.edit),
        color: Colors.black45,
    );
  }

  Widget updateTravelDialog(Future<Travel> travel) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("여행명 수정"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: FutureBuilder(
          future: travel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              travelNameView.text = snapshot.data!.name;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: travelNameView,
                    decoration: const InputDecoration(hintText: "변경할 여행명을 입력해주세요."),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      _databaseService
                          .updateTravel(Travel(
                          id: snapshot.data!.id,
                          name: travelNameView.text))
                          .then(
                            (result) {
                          if (result) {
                            Navigator.of(context).pop();
                            setState(() {
                              _travelList = _databaseService.selectTravels();
                            });
                          } else {
                            print("update error");
                          }
                        },
                      );
                    },
                    child: const Text("수정"),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred!"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          }),
    );
  }

  Widget deleteButton(int id) {
    return IconButton(
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => deleteWordDialog(id),
        ),
        icon: const Icon(Icons.delete),
        color: Colors.black45,
    );
  }

  Widget deleteWordDialog(int id) {
    return AlertDialog(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("이 여행을 삭제하시겠습니까?",
            style: TextStyle(
                fontSize: 17,
                letterSpacing: 1
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                child: Text("예"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent[100])
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("아니오"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.redAccent[200])
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextEditingController travelNameView = TextEditingController();
  static String travelName = '';
  final formKey = GlobalKey<FormState>();

  var select_start_date = '여행 시작일';
  var select_end_date = '여행 종료일';
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();

  void addTravelBottomSheet() {
    double height = MediaQuery.of(context).size.height * 0.8;
    double feild_width = MediaQuery.of(context).size.width * 0.2;

    showModalBottomSheet(
        context: context,
        // backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: height,
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: Column (
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('여행 계획 추가',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black45,
                            letterSpacing: 2.0
                        ),
                      ),
                      const Divider(
                        height: 20.0,
                        thickness: 1,
                        endIndent: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('여행명',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black45,
                                letterSpacing: 2.0
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('여행 기간',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black45,
                                letterSpacing: 2.0
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(select_start_date,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                    letterSpacing: 2.0
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: start_date,
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2999),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      start_date = selectedDate;
                                      select_start_date = '${start_date.year.toString()}-${start_date.month.toString().padLeft(2, '0')}-${start_date.day.toString().padLeft(2, '0')}';
                                    });
                                  }
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                              const Text('~'),
                              Text(select_end_date,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                    letterSpacing: 2.0
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: end_date,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2999),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      end_date = selectedDate;
                                      select_end_date = '${end_date.year.toString()}-${end_date.month.toString().padLeft(2, '0')}-${end_date.day.toString().padLeft(2, '0')}';
                                    });
                                  }
                                },
                                icon: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('여행 인원',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black45,
                                    letterSpacing: 2.0
                                ),
                              ),
                              Container(
                                width: feild_width,
                                child: DropdownButton(
                                    iconEnabledColor: Colors.black54,
                                    underline: Container(),
                                    isExpanded: true,
                                    value: select_number,
                                    items: people_number.map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    )).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        select_number = value!;
                                      });
                                    }
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () async {
                          int count = await _databaseService.getDatabaseRowCount();
                          print(count);
                          _databaseService
                              .insertTravel(
                              Travel(
                                  id: count + 1,
                                  name: travelNameView.text,
                              ))
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
                          travelNameView.clear();
                        },
                        child: const Text("생성"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent[100],
                          padding: EdgeInsets.fromLTRB(100, 10, 100, 10)
                        ),
                      ),
                    ],
                  )
                  ),
                ),
              ),
          );
        }
    );
  }

}
