import 'dart:convert';
import 'dart:core';

import 'package:challenge_everyday/model/challenge/challenge_backup.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

///
/// @Author jhkim
/// @Since 2019.07.15
/// 습관을 관리하기 위한 도메인입니다. 기초적인 속성만 정의해있습니다.
/// TODO 일주일 중 어느 요일에 할 계획인지 설정할 수 있는 항목, 습관 색상 지정 항목이 필요함.

// ignore: unnecessary_getters_setters
class Challenge {
  int index; // primary key
  String title; // 도전 제목
  DateTime startDate; // 도전 시작일
  DateTime endDate; // 도전 종료일
  String weekDay; // 수행 요일
  int doTimes; // 수행 총 횟수
  int totalTimes; // 도전 총 일수
  int maxDoTimes; // 최대 연속 수행 일 수
  int continueDoTimes; // 현재 연속 수행 일 수
  DateTime lastDoDate; // 최근 수행 일시
  String doHistory; // 일별 수행 여부 ex) 1,0,1,1,1,0,0,1,...
  ChallengeBackup challengeBackup; // 수행 취소 대비 백업
  bool valid; // 유효성 true/false
  int userIndex; // 회원번호
  DateTime createDate; // 생성 일시

  Challenge(
      {this.index,
      @required this.title,
      @required this.startDate,
      @required this.endDate,
      String weekDay,
      int doTimes,
      int totalTimes,
      int maxDoTimes,
      int continueDoTimes,
      this.lastDoDate,
      String doHistory,
      ChallengeBackup challengeBackup,
      this.valid = true,
      int userIndex,
      DateTime createDate})
      : this.weekDay = weekDay ?? '12345',
        this.doTimes = doTimes ?? 0,
        this.totalTimes =
            totalTimes ?? startDate.difference(endDate).inDays + 1,
        this.maxDoTimes = maxDoTimes ?? 0,
        this.continueDoTimes = continueDoTimes ?? 0,
        this.doHistory = doHistory ?? '',
        this.challengeBackup = challengeBackup ?? ChallengeBackup(),
        this.userIndex = userIndex ?? 0,
        this.createDate = createDate ?? DateTime.now();

  // '시작일 ~ 마지막일' 형식의 문자열을 반환하는 메소드
  String getDateRange() {
    return '${DateFormat('yyyy.MM.dd').format(this.startDate)} ~ ${DateFormat('yyyy.MM.dd').format(this.endDate)}';
  }

  //
  String getWeekdayString(String separator) {
    String data = this.weekDay;
    List<String> dataString = ['월', '화', '수', '목', '금', '토', '일'];
    List<String> result = [];
    for (int i = 1; i < 8; i++) {
      if (data.contains(i.toString())) result.add(dataString[i - 1]);
    }
    return result.join(separator);
  }

  String getSuccessPercent(int round) {
    return (this.doTimes / this.totalTimes * 100).toStringAsFixed(round);
  }

  void backup() {
    this.challengeBackup = ChallengeBackup(
      doTimes: this.doTimes,
      maxDoTimes: this.maxDoTimes,
      continueDoTimes: this.continueDoTimes,
      doHistory: this.doHistory,
      lastDoDate: this.lastDoDate
    );
  }

  void restore() {
    this.doTimes = this.challengeBackup.doTimes;
    this.maxDoTimes = this.challengeBackup.maxDoTimes;
    this.continueDoTimes = this.challengeBackup.continueDoTimes;
    this.doHistory = this.challengeBackup.doHistory;
    this.lastDoDate = this.challengeBackup.lastDoDate;
  }

  @override
  String toString() {
    return 'Challenge{index: $index, title: $title, startDate: $startDate, endDate: $endDate, weekDay: $weekDay, doTimes: $doTimes, totalTimes: $totalTimes, maxDoTimes: $maxDoTimes, continueDoTimes: $continueDoTimes, lastDoDate: $lastDoDate, doHistory: $doHistory, challengeBackup: $challengeBackup, valid: $valid, userIndex: $userIndex, createDate: $createDate}';
  }

  Map<String, dynamic> toDBMap() => {
        'n_index': index,
        's_title': title,
        'd_startdate': startDate.toString(),
        'd_enddate': endDate.toString(),
        's_weekday': weekDay,
        'n_dotimes': doTimes,
        'n_totaltimes': totalTimes,
        'n_maxdotimes': maxDoTimes,
        'n_continuedotimes': continueDoTimes,
        'd_lastdodate': lastDoDate.toString(),
        's_dohistory': doHistory,
        's_challengeBackup': jsonEncode(challengeBackup),
        'b_valid': valid ? 1 : 0,
        'n_userindex': userIndex,
        'd_createdate': createDate.toString()
      };

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return new Challenge(
      index: json['n_index'],
      title: json['s_title'],
      startDate: DateTime.parse(json['d_startdate']),
      endDate: DateTime.parse(json['d_enddate']),
      weekDay: json['s_weekday'],
      doTimes: json['n_dotimes'],
      totalTimes: json['n_totaltimes'],
      maxDoTimes: json['n_maxdotimes'],
      continueDoTimes: json['n_continuedotimes'],
      lastDoDate: json['d_lastdodate'] == 'null'
          ? DateTime(2000, 01, 01)
          : DateTime.parse(json['d_lastdodate']),
      doHistory: json['s_dohistory'],
      challengeBackup: ChallengeBackup.fromJson(jsonDecode(json['s_challengeBackup'])),
      valid: json['b_valid'] > 0 ? true : false,
      userIndex: json['n_userindex'],
      createDate: DateTime.parse(json['d_createdate']),
    );
  }
}
