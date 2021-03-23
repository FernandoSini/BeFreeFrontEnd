import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:be_free_front/Register/components/GenderScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class BirthdayScreen extends StatelessWidget {
  BirthdayScreen(this.registerProvider);
  final RegisterProvider registerProvider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "BeFree",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Color(0xFF9a00e6),
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            DatePickerWidget(
              pickerTheme: DateTimePickerTheme(
                backgroundColor: Colors.transparent,
                itemTextStyle: TextStyle(
                  color: Color(0xff9a00e6),
                ),
              ),
              // dateFormat: "dd/MMMM/yyyy",
              lastDate: DateTime.now(),
              onChange: (DateTime newDate, _) => registerProvider.birthday,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 55,
              child: ElevatedButton(
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff9a00e6),
                  elevation: 5,
                  // backgroundColor: Color(0xff9a00e6) ?? Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GenderScreen(
                            registerProvider: registerProvider,
                          ),
                        ),
                      );
                    } ??
                    null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
