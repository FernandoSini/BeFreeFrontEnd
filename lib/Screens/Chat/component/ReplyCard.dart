import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  ReplyCard({this.content, this.timestamp});
  String? content;
  DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return Align(
      //alinhamentos
      alignment: Alignment.centerLeft,
      //espaçamento entre os itens
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.purple.shade600.withOpacity(0.7),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: //verificando se o item for do tipo texto edntro do child vai gcarregar o text se não vai carregar a imagem
              content != null
                  ? Text(
                      content!,
                      style: TextStyle(fontSize: 15),
                    )
                  : Text(""),
        ),
      ),
    );
  }
}
