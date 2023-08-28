import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  List<Map<String, dynamic>> _dataList = [];

  // 데이터베이스 초기화 및 데이터 로딩
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 데이터베이스 초기화
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'example.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE example(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
    );
  }

  // 데이터 로딩
  Future<void> _loadData() async {
    final db = await _initDB();
    final dataList = await db.query('example');
    setState(() {
      _dataList = dataList;
    });
  }

  // 데이터 추가
  Future<void> _addData(String name) async {
    final db = await _initDB();
    await db.insert(
      'example',
      {
        'name': name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _textFieldController.clear();
    _loadData();
  }

  // 데이터 수정
  Future<void> _editData(int id, String name) async {
    final db = await _initDB();
    await db.update(
      'example',
      {
        'name': name,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadData();
  }

  // 데이터 삭제
  Future<void> _deleteData(int id) async {
    final db = await _initDB();
    await db.delete(
      'example',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('쭈미로운 생활 SQLite 예제'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '추가할 데이터를 입력하세요',
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _addData(_textFieldController.text);
                  },
                  child: Text('추가'),
                ),
              ],
            ),
          ),
          // 데이터 목록
          Expanded(
            child: ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                final data = _dataList[index];
                return ListTile(
                  title: Text(data['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // 데이터 수정 다이얼로그 띄우기
                          showDialog(
                            context: context,
                            builder: (_) {
                              final editController =
                                  TextEditingController(text: data['name']);
                              return AlertDialog(
                                title: Text('데이터 수정'),
                                content: TextField(
                                  controller: editController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '수정할 데이터를 입력하세요',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _editData(
                                          data['id'], editController.text);
                                      Navigator.pop(context);
                                    },
                                    child: Text('저장'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // 데이터 삭제
                          _deleteData(data['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
