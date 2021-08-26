import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Providers/SearchUserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _ageValues = RangeValues(18, 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF9a00e6),
        ),
        title: Text(
          "Filter your search",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Colors.pink[400],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40, top: 20, right: 40),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Filter by age:",
                  style: TextStyle(
                    fontFamily: "Segoe",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9a00e6),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: SliderTheme(
                  data: SliderThemeData(
                      activeTrackColor: Colors.grey,
                      overlayColor: Colors.pink.shade400.withOpacity(0.3),
                      thumbColor: Colors.pink[400],
                      showValueIndicator: ShowValueIndicator.onlyForContinuous),
                  child: RangeSlider(
                    values: _ageValues,
                    min: 18,
                    max: 100,
                    labels: RangeLabels(_ageValues.start.round().toString(),
                        _ageValues.end.round().toString()),
                    inactiveColor: Colors.grey,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _ageValues = values;
                      });
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 20, right: 40),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search by username or first name:",
                  style: TextStyle(
                    fontFamily: "Segoe",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9a00e6),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, bottom: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF9a00e6),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.grey,
                      onPressed: () async {},
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 20, right: 40),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search by gender:",
                  style: TextStyle(
                    fontFamily: "Segoe",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9a00e6),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Consumer<SearchUserProvider>(
                      builder: (_, searchUserProvider, __) {
                        return Container(
                          padding: EdgeInsets.only(left: 40),
                          child: Row(
                            children: [
                              Text(
                                "Male",
                                style: TextStyle(color: Color(0xFF9a00e6)),
                              ),
                              Radio(
                                value: Gender.MALE,
                                groupValue: searchUserProvider.gender,
                                onChanged: (value) {
                                  searchUserProvider.setGender(value);
                                },
                                focusColor: Colors.white,
                                hoverColor: Colors.pink[400],
                                activeColor: Colors.pink[400],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Consumer<SearchUserProvider>(
                      builder: (_, searchUserProvider, __) {
                        return Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                "Female",
                                style: TextStyle(
                                  color: Color(0xFF9a00e6),
                                ),
                              ),
                              Radio(
                                value: Gender.FEMALE,
                                groupValue: searchUserProvider.gender,
                                onChanged: (value) {
                                  searchUserProvider.setGender(value);
                                },
                                focusColor: Color(0xFF9a00e6),
                                hoverColor: Colors.pink[400],
                                activeColor: Colors.pink[400],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Consumer<SearchUserProvider>(
                      builder: (_, searchUserProvider, __) {
                        return Container(
                          child: Row(
                            children: [
                              Text(
                                "NonBinary",
                                style: TextStyle(color: Color(0xFF9a00e6)),
                              ),
                              Radio(
                                value: Gender.NONBINARY,
                                groupValue: searchUserProvider.gender,
                                onChanged: (value) {
                                  searchUserProvider.setGender(value);
                                },
                                focusColor: Color(0xFF9a00e6),
                                hoverColor: Colors.pink[400],
                                activeColor: Colors.pink[400],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  child: Text("Search"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pink[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
