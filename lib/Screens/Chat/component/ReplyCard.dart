import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReplyCard extends StatelessWidget {
  ReplyCard({this.content, this.timestamp, this.messageStatus});
  String? content;
  DateTime? timestamp;
  MessageStatus? messageStatus;

  @override
  Widget build(BuildContext context) {
    // return Align(
    //   //alinhamentos
    //   alignment: Alignment.centerLeft,
    //   //espaçamento entre os itens
    //   child: Padding(
    //     padding: EdgeInsets.all(6),
    //     child: Container(
    //       width: MediaQuery.of(context).size.width * 0.8,
    //       padding: EdgeInsets.all(16),
    //       decoration: BoxDecoration(
    //           color: Colors.purple.shade600.withOpacity(0.7),
    //           borderRadius: BorderRadius.all(Radius.circular(8))),
    //       child: //verificando se o item for do tipo texto edntro do child vai gcarregar o text se não vai carregar a imagem
    //           content != null
    //               ? Text(
    //                   content!,
    //                   style: TextStyle(fontSize: 15),
    //                 )
    //               : Text(""),
    //     ),
    //   ),
    // );
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          color: Colors.pinkAccent.shade400.withOpacity(0.5),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 60,
                  top: 5,
                  bottom: 10,
                ),
                child: Text(
                  content!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  DateFormat("HH:mm").format(timestamp!.toLocal()),
                  style: TextStyle(
                      fontSize: 13,
                      // color: Colors.grey[600],
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
