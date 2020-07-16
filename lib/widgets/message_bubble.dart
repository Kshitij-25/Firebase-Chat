import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  MessageBubble(this.message, this.isMe, {this.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: !isMe ? Colors.grey[800] : kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(15),
              bottomRight: !isMe ? Radius.circular(15) : Radius.circular(0),
            ),
          ),
          width: MediaQuery.of(context).size.width * .3,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 8,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
