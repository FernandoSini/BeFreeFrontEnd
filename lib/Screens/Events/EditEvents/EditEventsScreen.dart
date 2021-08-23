import 'dart:io';

import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/UpdateEventProvider.dart';
import 'package:be_free_v1/Screens/Events/EditEvents/components/ChooseFromScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class EditEventsScreen extends StatefulWidget {
  EditEventsScreen({this.event, this.user});
  Event? event;
  User? user;

  @override
  _EditEventsScreenState createState() => _EditEventsScreenState();
}

class _EditEventsScreenState extends State<EditEventsScreen> {
  TextEditingController eventNameController = TextEditingController(text: "");
  TextEditingController eventDescriptionController =
      TextEditingController(text: "");
  TextEditingController eventLocationController =
      TextEditingController(text: "");
  File? imageData;

  Future<void> showDialogSuccess() {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Success"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 100),
                child: TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF9a00e6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Icon(
                    Icons.check_circle_sharp,
                    color: Colors.green,
                    size: 80,
                  ),
                  Text("Event Created Successfully"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Error"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 100),
                child: TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF9a00e6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Icon(
                    Icons.cancel_sharp,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text(
                      "${Provider.of<UpdateEventProvider>(context, listen: false).errorData}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UpdateEventProvider>(context, listen: false).dispose();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateEventProvider = context.read<UpdateEventProvider>();
    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit your events",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Colors.pinkAccent[400],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // actionsIconTheme: IconThemeData(color: Colors.pinkAccent[400]),
        iconTheme: IconThemeData(color: Colors.pinkAccent[400]),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 25, bottom: 10, top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose one picture: ",
                  style: TextStyle(
                    fontFamily: "Segoe",
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent[400],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var data = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChooseFromScreen(),
                    ),
                  );
                  setState(() {
                    imageData = data;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.pinkAccent.shade400,
                      ),
                      image: imageData != null
                          ? DecorationImage(
                              image: FileImage(imageData!), fit: BoxFit.cover)
                          : null),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Center(child: Consumer<UpdateEventProvider>(
                  builder: (_, updateEventProvider, __) {
                    return TextFormField(
                      minLines: 1,
                      maxLines: null,
                      maxLength: 250,
                      controller: eventNameController,
                      decoration: InputDecoration(
                        // hintText: "Update your username",
                        labelText: "Type name of your event",
                        labelStyle:
                            TextStyle(color: Colors.pinkAccent.shade400),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent.shade400,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pinkAccent.shade400,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        updateEventProvider.setEventName(value);
                      },
                    );
                  },
                )),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Center(
                  child: Consumer<UpdateEventProvider>(
                    builder: (_, updateEventProvider, __) {
                      return TextFormField(
                        minLines: 1,
                        maxLines: null,
                        maxLength: 250,
                        controller: eventLocationController,
                        decoration: InputDecoration(
                          // hintText: "Update your username",
                          labelText: "Where is the event?",
                          labelStyle:
                              TextStyle(color: Colors.pinkAccent.shade400),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent.shade400,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent.shade400,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          updateEventProvider.setEventLocation(value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Center(
                  child: Consumer<UpdateEventProvider>(
                    builder: (_, updateEventProvider, __) {
                      return TextFormField(
                        minLines: 1,
                        maxLines: null,
                        maxLength: 250,
                        controller: eventDescriptionController,
                        decoration: InputDecoration(
                          // hintText: "Update your username",
                          labelText: "Add description to your event",
                          labelStyle: TextStyle(color: Colors.pinkAccent[400]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent.shade400,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pinkAccent.shade400,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          updateEventProvider.setEventDescription(value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    // DatePickerWidget(
                    //   pickerTheme: DateTimePickerTheme(
                    //     backgroundColor: Colors.transparent,
                    //     itemTextStyle: TextStyle(
                    //       color: Color(0xff9a00e6),
                    //     ),
                    //   ),
                    //   // dateFormat: "dd/MMMM/yyyy",
                    //   lastDate: DateTime.now(),
                    //   onChange: (DateTime newDate, _) {},
                    // ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Consumer<UpdateEventProvider>(
                        builder: (_, updateEventProvider, __) {
                          return TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                theme: DatePickerTheme(
                                  headerColor: Colors.pinkAccent[400],
                                  backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Colors.pinkAccent[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                },
                                onConfirm: (date) {
                                  updateEventProvider.setEventStartDate(date);
                                  print('confirm $date');
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                            child: Text(
                              '${updateEventProvider.startDateValue != null ? "Selected Started Date" : "Select Start Date"}',
                              style: TextStyle(
                                color: Colors.pinkAccent[400],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Consumer<UpdateEventProvider>(
                        builder: (_, updateEventProvider, __) {
                          return TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                theme: DatePickerTheme(
                                  headerColor: Colors.pinkAccent[400],
                                  backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Colors.pinkAccent[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                },
                                onConfirm: (date) {
                                  updateEventProvider.setEventEndDate(date);
                                  print('confirm $date');
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                            child: Text(
                              '${updateEventProvider.endDateValue != null ? "Selected End Date" : "Select End Date"}',
                              style: TextStyle(
                                color: Colors.pinkAccent[400],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.height * 0.5,
                      child: Consumer<UpdateEventProvider>(
                        builder: (_, createEventProvider, __) {
                          return ElevatedButton(
                            child: updateEventProvider.isLoading!
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text("Update Event"),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff9a00e6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () async {
                              //lembrar amanhã que parei aqui e que o falta fazer uploadar no server
                              await updateEventProvider.updateEvent(
                                  widget.user!, imageData, widget.event!.id);
                              if (updateEventProvider.isEventUpdated!) {
                                await showDialogSuccess();
                                eventNameController.clear();
                                eventLocationController.clear();
                                eventDescriptionController.clear();
                                updateEventProvider.setEventName(null);
                                updateEventProvider.setEventLocation(null);
                                updateEventProvider.setEventDescription(null);
                                updateEventProvider.setEventStartDate(null);
                                updateEventProvider.setEventEndDate(null);
                                setState(() {
                                  imageData = null;
                                });
                              }
                              if (updateEventProvider.hasError!) {
                                await showErrorDialog();
                              }
                            },
                          );
                        },
                      ),
                    ),
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
