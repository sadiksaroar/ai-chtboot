import 'package:ai_chaboot/message/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Ui_chatBoot extends StatefulWidget {
  const Ui_chatBoot({super.key});

  @override
  State<Ui_chatBoot> createState() => _Ui_chatBootState();
}

class _Ui_chatBootState extends State<Ui_chatBoot> {
  TextEditingController _userInput = TextEditingController();
  final apikey = 'AIzaSyDD_qd4Zbj7Wq8HeTdgojXflTYExz4xrQM';

  final List<Message> _message = [];

  Future<void> talkWithGemini() async {
    try {
      final usrMsg = _userInput.text;
      setState(() {
        _message.add(
          Message(
            isUser: true,
            message: usrMsg,
            date: DateTime.now(),
          ),
        );
      });

      final model = GenerativeModel(model: 'text-bison-001', apiKey: apikey);

      final content = Content.text(usrMsg);
      final response = await model.generateContent([content]);

      setState(() {
        _message.add(
          Message(
            isUser: false,
            message: response.text ?? "No response received.",
            date: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _message.add(
          Message(
            isUser: false,
            message: "Error: $e",
            date: DateTime.now(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api_chtBoot'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.dstATop),
            image: NetworkImage(
                'https://plus.unsplash.com/premium_photo-1672116453187-3aa64afe04ad?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _message.length,
                itemBuilder: (context, index) {
                  final message = _message[index];

                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _userInput,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: Text('Enter Your Messge')),
                    ),
                  ),
                  // Spacer(),
                  IconButton(
                      padding: EdgeInsets.all(12),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(CircleBorder())),
                      onPressed: () {
                        talkWithGemini();
                      },
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
