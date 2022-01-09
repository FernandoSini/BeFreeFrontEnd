import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YourMessageCard extends StatelessWidget {
  YourMessageCard({this.content, this.timestamp, this.messageStatus});
  MessageStatus? messageStatus;
  String? content;
  DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    // //interface de mensagens
    // return Align(
    //   //alinhamentos
    //   alignment: Alignment.centerRight,
    //   //espaçamento entre os itens
    //   child: Padding(
    //     padding: EdgeInsets.all(6),
    //     child: Container(
    //       width: MediaQuery.of(context).size.width * 0.8,
    //       padding: EdgeInsets.all(16),
    //       decoration: BoxDecoration(
    //           color: Colors.lightBlue.withOpacity(0.5),
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
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.greenAccent.withOpacity(0.5),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: content!.length >= 20 ? 77 : 100,
                  top: 5,
                  bottom: 10,
                ),
                child: Text(
                  content!,
                  softWrap: true,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      DateFormat("HH:mm").format(timestamp!.toLocal()),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                   /*  Icon(
                      messageStatus == MessageStatus.DELIVERED
                          ? Icons.done_all
                          : Icons.done,
                      size: 20,
                      color: messageStatus == MessageStatus.DELIVERED
                          ? Colors.blueAccent
                          : null,
                    ), */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
