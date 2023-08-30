import 'package:flutter/material.dart';
import 'package:travel_book/inputFeild.dart';
import 'package:travel_book/travel_data.dart';

class travelPage extends StatelessWidget {
  const travelPage({Key? key, required this.travel}) : super(key: key);
  final Travel travel;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(travel.name,
            style: const TextStyle(
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.red[200],
        ),
        body: Column(
          children: [
            Text('${travel.id}')
          ],
        ),
      )
    );
  }
}