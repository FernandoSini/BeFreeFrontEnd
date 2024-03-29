import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/CreateEventProvider.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  CreateEventScreen(this.eventOwner);
  User? eventOwner;
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController eventNameController = TextEditingController(text: "");
  TextEditingController eventDescriptionController =
      TextEditingController(text: "");
  TextEditingController eventLocationController =
      TextEditingController(text: "");

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CreateEventProvider>(context, listen: false).clear();
      }
    });

    super.initState();
  }

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
                  SizedBox(height: Responsive.isSmallScreen(context) ? 15 : 30),
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
                  SizedBox(height: Responsive.isSmallScreen(context) ? 15 : 30),
                  Icon(
                    Icons.cancel_sharp,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text(
                      "${Provider.of<CreateEventProvider>(context, listen: false).errorData}"),
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
        Provider.of<CreateEventProvider>(context, listen: false).clear();
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          title: Text(
            "Create Event",
            style: TextStyle(
              fontFamily: "Segoe",
              color: Colors.pinkAccent[400],
              fontWeight: FontWeight.w200,
            ),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF9a00e6),
          ),
          centerTitle: true,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          child: ListView(
            children: [
              // Container( /////desativei isso aqui temporário
              //   margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              //   child: GridView.builder(
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     physics: NeverScrollableScrollPhysics(),
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 3,
              //         mainAxisSpacing: 3,
              //         childAspectRatio: 0.8),
              //     shrinkWrap: true,
              //     itemCount: 3,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         margin: EdgeInsets.only(right: 5, left: 5),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           border: Border.all(
              //               color: Colors.pinkAccent[400]!, width: 0.5),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Center(child: Consumer<CreateEventProvider>(
                  builder: (_, createEvent, __) {
                    return TextFormField(
                      minLines: 1,
                      maxLines: null,
                      maxLength: 250,
                      controller: eventNameController,
                      decoration: InputDecoration(
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
                        createEvent.setEventName(value);
                      },
                    );
                  },
                )),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Center(
                  child: Consumer<CreateEventProvider>(
                    builder: (_, createEventProvider, __) {
                      return TextFormField(
                        minLines: 1,
                        maxLines: null,
                        maxLength: 250,
                        controller: eventLocationController,
                        decoration: InputDecoration(
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
                          createEventProvider.setEventLocation(value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: Center(
                  child: Consumer<CreateEventProvider>(
                    builder: (_, createEventProvider, __) {
                      return TextFormField(
                        minLines: 1,
                        maxLines: null,
                        maxLength: 250,
                        controller: eventDescriptionController,
                        decoration: InputDecoration(
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
                          createEventProvider.setEventDescription(value);
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
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Consumer<CreateEventProvider>(
                        builder: (_, createEventProvider, __) {
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
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  createEventProvider.setEventStartDate(date);
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                            child: Text(
                              '${createEventProvider.startDateValue != null ? "Selected Started Date" : "Select Start Date"}',
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
                      child: Consumer<CreateEventProvider>(
                        builder: (_, createEventProvider, __) {
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
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  createEventProvider.setEventEndDate(date);
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                            child: Text(
                              '${createEventProvider.endDateValue != null ? "Selected End Date" : "Select End Date"}',
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
                      child: Consumer<CreateEventProvider>(
                        builder: (_, createEventProvider, __) {
                          return ElevatedButton(
                            child: createEventProvider.isLoading!
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text("Create Event"),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff9a00e6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: (createEventProvider.endDate == null ||
                                    createEventProvider.startDate == null)
                                ? null
                                : () async {
                                    await createEventProvider.createEvent(
                                        widget.eventOwner!.token,
                                        widget.eventOwner!);
                                    if (createEventProvider.isEventCreated!) {
                                      await showDialogSuccess();
                                      eventNameController.clear();
                                      eventLocationController.clear();
                                      eventDescriptionController.clear();
                                      createEventProvider.clear();
                                    }
                                    if (createEventProvider.hasError!) {
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
