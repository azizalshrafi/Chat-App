import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custom_chat_buble.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';
  String? mesage;
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    //to get data saved in arguments here i mien email from login and signup
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
              appBar: AppBar(
                //to cansle bake iconButton in app par
                automaticallyImplyLeading: false,
                backgroundColor: kPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogo,
                      height: 50,
                    ),
                    Text('Scholar chat'),
                  ],
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        controller: _controller,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return messagesList[index].id == email
                              ? ChatBuble(
                                  message: messagesList[index],
                                )
                              : ChatBubleForFriend(
                                  message: messagesList[index],
                                );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: controller,
                      onChanged: (data) {
                        mesage = data;
                      },
                      onSubmitted: (data) {
                        messages.add({
                          'message': data,
                          kCreatedAt: DateTime.now(),
                          'id': email,
                        });

                        controller.clear();
                        _controller.animateTo(
                          // _controller.position.maxScrollExtent,
                          0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          color: kPrimaryColor,
                          onPressed: () {
                            messages.add({
                              'message': mesage,
                              kCreatedAt: DateTime.now(),
                              'id': email,
                            }); 
                            controller.clear();
                            _controller.animateTo(
                              // _controller.position.maxScrollExtent,
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('Loading...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            );
          }
        });
  }
}
