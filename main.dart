import 'package:flutter/material.dart';

// 1) You need to install this so it works 'flutter pub add http'
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

// 2) ADD your JItem class below (we'll do in class or grab from 10b notes)
class JItem {
  final int id;
  final String title;

  JItem({required this.id, required this.title});
}

class JItemsProvider extends ChangeNotifier {
  List<JItem> items = [];
  final String postURL = "https://jsonplaceholder.typicode.com/posts";
  Future<void> getData() async {
    var response = await http.get(Uri.parse(postURL));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var item in data) {
        items.add(JItem(id: item['id'], title: item['title']));
      }
    }

    notifyListeners(); // ADD THIS LINE
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JItemsProvider(),
      child: MaterialApp(title: 'Future Provider Example', home: DemoPage()),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Provider Example'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<JItemsProvider>(
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: () => value.getData(),
                      child: Text('Get Data'),
                    );
                  },
                ),
                Consumer<JItemsProvider>(
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: () => value.clear(),
                      child: Text('Clear Data'),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Consumer<JItemsProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(value.items[index].id.toString()),
                        subtitle: Text(value.items[index].title),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ), 
      ),
    );
  }
}

//4) Create the getData Function here!

