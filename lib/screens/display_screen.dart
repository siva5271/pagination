import 'dart:convert';

import 'package:airfintech_task1/screens/post_screen.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

const String _url = "https://jsonplaceholder.typicode.com/posts";
int _currentPage = 0;
const int _pageSize = 20;
bool _isLoadingInitialRunning = false;
List _data = [];
bool _gotNextPage = true;
bool _isLoadingMoreRunning = false;
late ScrollController _scrollController;
final TextEditingController titleTextEditingController =
    TextEditingController();
final TextEditingController bodyTextEditingController = TextEditingController();

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  static const batteryChannel = MethodChannel('battery_level');
  String batteryLevel = 'calculating....';
  @override
  void initState() {
    super.initState();
    getBatteryLevel();
    _scrollController = ScrollController()..addListener(LoadMore);
  }

  Future<void> getBatteryLevel() async {
    final int batteryLevel =
        await batteryChannel.invokeMethod('getBatteryLevel');
    FBroadcast.instance().broadcast(
      "Key_Message",
      value: batteryLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    FBroadcast.instance().register("Key_Message", (value, callback) {
      setState(() {
        batteryLevel = value.toString();
      });
    });
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 70),
        child: FloatingActionButton.extended(
          label: const Text('Post'),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom), //This is used to make the popped up bottom sheet to be adjustable even when the keyboard is popped up
                child:
                    postScreen(), //The flow of code is diverted to the section concerning the addition of new tasks
              )),
            );
          },
          icon: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text('Battery Level:$batteryLevel'),
        centerTitle: true,
      ),
      body: _isLoadingInitialRunning
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: ((context, index) => Card(
                            child: ListTile(
                              title: Text(_data[index]['title']),
                              subtitle: Text(_data[index]['body']),
                            ),
                          )),
                      separatorBuilder: ((context, index) => const SizedBox(
                            height: 20,
                          )),
                      itemCount: _data.length),
                ),
                if (_isLoadingMoreRunning)
                  const SizedBox(
                    child: CircularProgressIndicator(),
                    height: 50,
                  ),
              ],
            ),
    );
  }

  Future<void> LoadMore() async {
    if (_gotNextPage == true &&
        _isLoadingInitialRunning == false &&
        _isLoadingMoreRunning == false) {
      setState(() {
        _isLoadingMoreRunning = true;
      });
      _currentPage++;
      try {
        final response = await http
            .get(Uri.parse('$_url?_page=$_currentPage?_limit=$_pageSize'));
        final List newData = jsonDecode(response.body);
        if (newData.isNotEmpty) {
          setState(() {
            _data.addAll(newData);
          });
        } else {
          _gotNextPage = false;
        }
      } catch (e) {
        print(e);
      }
      setState(() {
        _isLoadingMoreRunning = false;
      });
    }
  }
}

void firstFetch(BuildContext context) async {
  final response = await http
      .get(Uri.parse('${_url}?_page=$_currentPage?_limit=$_pageSize'));
  if (response.body.isNotEmpty) {
    _data = jsonDecode(response.body);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => DisplayScreen())));
  }
}
