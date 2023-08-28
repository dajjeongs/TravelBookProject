import 'package:flutter/material.dart';
import 'package:travel_book/save_travel/travelName.dart';
import 'package:travel_book/save_travel/travelPeopleNumber.dart';
import 'package:travel_book/save_travel/travelPeriod.dart';

void main() => runApp(SaveTravel());

class SaveTravel extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Cash Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SaveTravelPage(),
    );
  }
}

class SaveTravelPage extends StatefulWidget {
  @override
  SaveTravelPageState createState() => SaveTravelPageState();
}

class SaveTravelPageState extends State<SaveTravelPage> {

  final formKey = GlobalKey<FormState>();

  var travelName = '일단 임시';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('여행 추가',
            style: TextStyle(
                letterSpacing: 1
            ),),
          centerTitle: true,
          backgroundColor: Colors.red[200],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TravelName(),
                      const SizedBox(
                        height: 20,
                      ),
                      TravelPeriod(),
                      const SizedBox(
                        height: 15,
                      ),
                      TravelPeopleNumber(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            if (formKey.currentState!.validate()){
                              formKey.currentState!.save();
                              _saveAlert();
                            }
                          },
                          icon: Icon(Icons.add),
                          label: Text('저장'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveAlert() {
    showDialog(
      context: context, // Alert을 띄울 context
      builder: (BuildContext context) {
        // Alert의 Context
        return AlertDialog(
          title: Text("확인"), // 제목
          content: Text('${travelName}을 저장하시겠습니까?'), // 내용
          actions: [
            // 위젯을 담을 수 있는 위젯배열
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Alert 끄기
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  print('test');
                });
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.redAccent[100]!),
              ),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

}