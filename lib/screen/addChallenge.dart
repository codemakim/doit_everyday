import 'package:challenge_everyday/model/challenge/challenge.dart';
import 'package:challenge_everyday/repository/challengeRepository.dart';
import 'package:challenge_everyday/widget/RaisedGradientButton.dart';
import 'package:challenge_everyday/widget/SpaceBannerContainer.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

/// 도전을 추가하기 위한 화면입니다.
class AddChallengeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AddChallengeFormWidget();
  }
}

class AddChallengeFormWidget extends State<AddChallengeScreen> {
  List<DateTime> _dateList;
  final _challengeTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _mon = true;
  bool _tue = true;
  bool _wed = true;
  bool _thu = true;
  bool _fri = true;
  bool _sat = false;
  bool _sun = false;

  @override
  void dispose() {
    _challengeTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            appBar: GradientAppBar(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Colors.greenAccent[400]],
              ),
              title: Text('도전 추가하기!'),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange[50],
                    Colors.pink[100],
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: MediaQuery.of(context).size.height * 0.1),
                              child: Column(
                                children: <Widget>[
                                  // 도전 제목을 입력받기 위한 텍스트 폼
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "도전 제목",
                                      hintText: "도전 제목을 입력하세요.",
                                    ),
                                    controller: _challengeTitleController,
                                    validator: (value) {
                                      if (value.isEmpty) return '도전 제목을 입력하세요.';
                                      return null;
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                  // 도전 수행 기간 설정을 위한 버튼 위젯
                                  ButtonBar(
                                    children: <Widget>[
                                      Text(
                                        _dateList == null
                                            ? '기간을 설정해주세요.'
                                            : '${DateFormat('yyyy.MM.dd').format(_dateList[0]).toString()} 부터 \n${DateFormat('yyyy.MM.dd').format(_dateList[1]).toString()} 까지',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      // 도전 수행 기간 설정 버튼
                                      RaisedButton(
                                        onPressed: () {
                                          runDateRangePicker();
                                        }, // onPressed()
                                        child: Text(
                                          '기간 설정',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        color: Colors.indigo,
                                      ), // RaisedButton
                                    ], // <Widget>[]
                                  ), // ButtonBar
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: weekDayColumn(),
                                    ), // Row
                                  ), // Padding
                                ], // <Widget>[]
                              ), // Column end.
                            ),
                          ),
                        ), // Padding
                      ], // <Widget>[]
                    ), // Column end
                  ), // Form end
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: RaisedGradientButton(
                        child: Text(
                          '추가하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          var validateResult = _formKey.currentState.validate();
                          if (!validateResult) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('필수 항목을 모두 입력해주세요.')));
                          } else if (_dateList == null) {
                            runDateRangePicker();
                          } else {
                            // weekday 를 구하기 위한 코드 시작
                            String weekday = '';
                            if (_mon) weekday += '1';
                            if (_tue) weekday += '2';
                            if (_wed) weekday += '3';
                            if (_thu) weekday += '4';
                            if (_fri) weekday += '5';
                            if (_sat) weekday += '6';
                            if (_sun) weekday += '7';
                            if (weekday.length < 1) weekday = '12345';
                            // weekday 를 구하기 위한 코드 끝

                            // totalTimes 를 구하기 위한 코드 시작
                            int totalTimes = 0;
                            Duration duration = _dateList[1].difference(_dateList[0]);
                            //int diffDays = duration.inDays - (duration.inDays*2);
                            for (int i = 0; i <= duration.inDays; i++) {
                              if (weekday.contains(_dateList[0]
                                  .add(Duration(days: i))
                                  .weekday
                                  .toString())) {
                                totalTimes++;
                              }
                            }
                            // totalTimes 를 구하기 위한 코드 끝

                            var challenge = new Challenge(
                                title: _challengeTitleController.text,
                                startDate: _dateList[0],
                                endDate: _dateList[1].add(
                                    Duration(hours: 23, minutes: 59, seconds: 59)),
                                weekDay: weekday,
                                doTimes: 0,
                                totalTimes: totalTimes,
                                maxDoTimes: 0,
                                createDate: DateTime.now());

                            // Challenge 추가
                            ChallengeRepository().insertChallenge(challenge);
                            print(challenge.toString());
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        gradient: LinearGradient(
                          colors: [Colors.lightBlue, Colors.greenAccent[400]],
                        ),
                      ) // RaisedButton end,
                      ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: RaisedGradientButton(
                        child: Text(
                          '되돌아가기',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.pink],
                        ),
                      ) // RaisedButton end,
                      ),
                ],
              ),
            ),
          ),
        ),
        SpaceBannerContainer(),
      ],
    );
  }

  /// 요일 설정 체크박스 리스트 생성
  List<Widget> weekDayColumn() {
    List<Widget> columnList = <Widget>[
      Column(
        children: <Widget>[
          Text('Mon'),
          Checkbox(
            value: _mon,
            onChanged: (value) => setState(() {
              _mon = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
      Column(
        children: <Widget>[
          Text('Tue'),
          Checkbox(
            value: _tue,
            onChanged: (value) => setState(() {
              _tue = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
      Column(
        children: <Widget>[
          Text('Wed'),
          Checkbox(
            value: _wed,
            onChanged: (value) => setState(() {
              _wed = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
      Column(
        children: <Widget>[
          Text('Thu'),
          Checkbox(
            value: _thu,
            onChanged: (value) => setState(() {
              _thu = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
      Column(
        children: <Widget>[
          Text('Fri'),
          Checkbox(
            value: _fri,
            onChanged: (value) => setState(() {
              _fri = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
      Column(
        children: <Widget>[
          Text('Sat'),
          Checkbox(
            value: _sat,
            onChanged: (value) => setState(() {
              _sat = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
      Column(
        children: <Widget>[
          Text('Sun'),
          Checkbox(
            value: _sun,
            onChanged: (value) => setState(() {
              _sun = value;
            }),
            activeColor: Colors.indigo,
          )
        ],
      ),
    ];
    return columnList;
  }

  /// 도전 기간 설정 버튼 클릭시 실행되는 함수입니다.
  void runDateRangePicker() {
    DateTime now = DateTime.now();
    DateRangePicker.showDatePicker(
            context: context,
            initialFirstDate: DateTime.now(),
            initialLastDate: DateTime.now().add(Duration(days: 1)),
            firstDate: DateTime(now.year, now.month, now.day),
            lastDate: DateTime(DateTime.now().year + 3, DateTime.now().month,
                DateTime.now().day))
        .then((dateList) {
      if (dateList.length < 2) {
        dateList.add(dateList[0]);
        dateList[0] = DateTime(now.year, now.month, now.day);
      }
      setState(() {
        _dateList = dateList;
      });
    });
  }
}
