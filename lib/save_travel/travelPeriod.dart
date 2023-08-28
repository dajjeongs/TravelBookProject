import 'package:flutter/material.dart';

class TravelPeriod extends StatefulWidget {
  @override
  TravelPeriodFeild createState() => TravelPeriodFeild();
}

class TravelPeriodFeild extends State<TravelPeriod> {

  var select_start_date = '여행 시작일';
  var select_end_date = '여행 종료일';
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
    );
  }
}