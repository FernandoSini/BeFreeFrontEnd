import 'dart:convert';

import 'package:be_free_front/Models/Event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateEventProvider extends ChangeNotifier {
  String? eventName;
  String? get eventNameData => eventName;
  String? eventDescription;
  String? get eventDescriptionData => eventDescription;
  String? eventLocation;
  String? get eventLocationData => eventLocation;
  String? eventCover;
  String? get eventCoverData => eventCover;
  DateTime? startDate;
  DateTime? get startDateValue => startDate;
  DateTime? endDate;
  DateTime? get endDateValue => endDate;
  bool? loading = false;
  bool? get isLoading => loading;
  bool? err = false;
  bool? get hasError => err;
  String? error;
  String? get errorData => error;
  bool? eventCreated = false;
  bool? get isEventCreated => true;

  Future<void>? createEvent(String? token, String? eventOwnerId) async {
    setLoading(true);
    String url = "http://192.168.0.136:8080/api/events/create/$eventOwnerId";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    //esta funfando
    // Map<String, dynamic> data = {
    //   "event_name": eventNameData,
    //   "event_description": eventDescriptionData,
    //   "event_cover": eventCoverData == null ? null : eventCoverData,
    //   "event_location": eventLocationData,
    //   "start_date":
    //       DateFormat("dd-MM-yyyy hh:mm:ss").format(startDateValue!).toString(),
    //   "end_date":
    //       DateFormat("dd-MM-yyyy hh:mm:ss").format(endDateValue!).toString()
    // };
    Event? data = new Event(
        eventName: eventNameData,
        eventCover: eventCoverData,
        eventDescription: eventDescriptionData,
        eventLocation: eventLocationData,
        startDate: startDateValue,
        endDate: endDateValue);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        setLoading(false);
        setError(false);
        setErrorText(null);
        setEventCreated(true);
      } else {
        setLoading(false);
        setError(true);
        setErrorText(
          json.decode(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes),
          ),
        );
        return Future.error(errorData!);
      }
    } catch (e) {
      setLoading(false);
      setError(true);
      setErrorText(e.toString());
      return Future.error(errorData!);
    }
  }

  void setEventName(value) {
    eventName = value;
    notifyListeners();
  }

  void setEventDescription(value) {
    eventDescription = value;
    notifyListeners();
  }

  void setEventCover(value) {
    eventCover = value;
    notifyListeners();
  }

  void setEventLocation(value) {
    eventLocation = value;
    notifyListeners();
  }

  void setEventStartDate(value) {
    startDate = value;
    notifyListeners();
  }

  void setEventEndDate(value) {
    endDate = value;
    notifyListeners();
  }

  void setError(
    bool? value,
  ) {
    err = value;
    notifyListeners();
  }

  void setErrorText(String? value) {
    error = value;
    notifyListeners();
  }

  void setEventCreated(bool newValue) {
    eventCreated = newValue;
    notifyListeners();
  }

  void setLoading(bool newValue) {
    loading = newValue;
    notifyListeners();
  }
}
