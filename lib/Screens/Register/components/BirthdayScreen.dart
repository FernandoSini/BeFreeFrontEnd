import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:be_free_front/Screens/Register/components/GenderScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:provider/provider.dart';

class BirthdayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
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
            fontSize: (defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS)
                ? 30
                : 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Select your birthday: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              margin: EdgeInsets.only(left: 35, right: 35),
              child: Consumer<RegisterProvider>(
                builder: (_, registerProvider, __) => DatePickerWidget(
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: Colors.transparent,
                    itemTextStyle: TextStyle(
                      color: Color(0xff9a00e6),
                    ),
                  ),
                  // dateFormat: "dd/MMMM/yyyy",
                  lastDate: DateTime.now(),
                  onChange: (DateTime newDate, _) {
                    registerProvider.setBirthiday(newDate);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 50, right: 50),
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
                onPressed: registerProvider.birthdayValue != null &&
                        !registerProvider.isAdult
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GenderScreen(),
                          ),
                        );
                      }, /* ??
                    null, */
              ),
            )
          ],
        ),
      ),
    );
  }
}
