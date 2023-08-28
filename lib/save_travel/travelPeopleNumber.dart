import 'package:flutter/material.dart';

class TravelPeopleNumber extends StatefulWidget {
  @override
  TravelPeopleNumberFeild createState() => TravelPeopleNumberFeild();
}

class TravelPeopleNumberFeild extends State<TravelPeopleNumber> {

  List<String> people_number = ['1명', '2명', '3명', '4명', '5명 +'];
  String select_number = '';

  void initState() {
    super.initState();
    setState(() {
      select_number = people_number[0];
    });
  }

  @override
  Widget build(BuildContext context) {

    double feild_width = MediaQuery.of(context).size.width * 0.4;

    return Container(
      child: Column(
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
    );
  }
}