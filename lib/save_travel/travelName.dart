import 'package:flutter/material.dart';

class TravelName extends StatefulWidget {
  @override
  TravelNameFeild createState() => TravelNameFeild();
}

class TravelNameFeild extends State<TravelName> {
  TextEditingController travelNameView = TextEditingController();

  String travelName = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
        ],
      ),
    );
  }
}