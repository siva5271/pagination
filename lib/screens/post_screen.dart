import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class postScreen extends StatefulWidget {
  @override
  State<postScreen> createState() => _postScreenState();
}

class _postScreenState extends State<postScreen> {
  String _url = "https://jsonplaceholder.typicode.com/posts";

  late String newPost;

  Color buttonColor = Colors.blue;
  String buttonText = 'Post';

  TextEditingController titleTextEditingController = TextEditingController();

  TextEditingController bodyTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //Two containers are laid over  one another to make the radius of curvature visible
      color: const Color(
          0xff757575), //This is the inner component and is given the same colour as that of the background
      child: Container(
        //This is the component  which will be visible to the user
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: titleTextEditingController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent, width: 3)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 5.0)),
                    labelText: 'Enter the title'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                autofocus: true,
                controller: bodyTextEditingController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlueAccent, width: 3)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 5.0)),
                    labelText: 'Enter the body'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final response = await http.post(Uri.parse(_url), body: {
                      "title": titleTextEditingController.text,
                      "body": bodyTextEditingController.text,
                      "userId": "11"
                    });
                    print(response.statusCode);
                    if (response.statusCode == 201) {
                      setState(() {
                        buttonColor = Colors.green;
                        buttonText = 'Successfull!';
                      });

                      Navigator.pop(context);
                    } else {
                      setState(() {
                        buttonColor = Colors.red;
                        buttonText = 'Failed!';
                      });
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(buttonColor)),
                  child: Text(buttonText))
            ],
          ),
        ),
      ),
    );
  }
}
