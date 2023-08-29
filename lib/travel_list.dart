import 'package:flutter/material.dart';
import 'package:travel_book/travel_sql.dart';
import 'package:travel_book/travel_data.dart';

class travelList extends StatefulWidget {
  @override
  travelListState createState() => travelListState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class travelListState extends State<travelList> {

  final DatabaseService _databaseService = DatabaseService();
  Future<List<Travel>> _travelList = DatabaseService()
      .databaseConfig()
      .then((_) => DatabaseService().selectTravels());
  int currentCount = 0;


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height * 0.6;

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
        // Expanded(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       updateButton(id),
        //       const SizedBox(width: 10),
        //       deleteButton(id),
        //     ],
        //   ),
        // ),
      ],
    );
  }

}