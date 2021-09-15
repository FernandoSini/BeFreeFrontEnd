import 'dart:convert';
import 'dart:io';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

class UpdateEventProvider extends ChangeNotifier {
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
  bool? eventUpdated = false;
  bool? get isEventUpdated => eventUpdated;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<void>? updateEvent(User? you, File? avatar, String? eventId) async {
    setLoading(true);
    String url =
        "${api.url}api/event/$eventId/edit";

    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer ${you?.token}"
    };
    Event? event = new Event(
      eventOwner: you,
      eventName: eventNameData,
      //eventPhoto: eventCoverData,
      eventStatus: EventStatus.INCOMING,
      eventDescription: eventDescriptionData,
      eventLocation: eventLocationData,
      startDate: startDateValue,
      endDate: endDateValue,
    );

    try {
      var request = new http.MultipartRequest("PUT", Uri.parse(url));
      request.headers.addAll(headers);
      if (event.toJson().isNotEmpty) {
        // request.fields.forEach((requestKey, requestValue) {
        //   event.toJson().forEach((eventKey, eventValue) {
        //     requestKey = eventKey;
        //     requestValue = eventValue;
        //   });
        // });
        request.fields.addAll(event.toJson());
      }
      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath("img", avatar.path,
            contentType: avatar.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        setLoading(false);
        setError(false);
        setErrorText(null);
        setEventUpdated(true);
      } else {
        setLoading(false);
        setError(true);
        setEventUpdated(false);
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
      setEventUpdated(false);
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

  void setEventUpdated(bool newValue) {
    eventUpdated = newValue;
    notifyListeners();
  }

  void setLoading(bool newValue) {
    loading = newValue;
    notifyListeners();
  }
}
