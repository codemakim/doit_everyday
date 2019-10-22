class ChallengeBackup {
  int doTimes;          // 수행 총 횟수
  int maxDoTimes;       // 최대 연속 수행일 수
  int continueDoTimes;  // 현재 연속 수행일 수
  DateTime lastDoDate;  // 최근 수행일시
  String doHistory;     // 일별 수행 여부 ex) 0,1,0,1,0,0,0,1,1,...

  ChallengeBackup({
    this.doTimes,
    this.maxDoTimes,
    this.continueDoTimes,
    this.lastDoDate,
    this.doHistory,
  });

  Map<String, dynamic> toJson() => {
    'n_dotimes': doTimes,
    'n_maxdotimes': maxDoTimes,
    'n_continuedotimes': continueDoTimes,
    'd_lastdodate': lastDoDate.toString(),
    's_dohistory': doHistory,
  };

  factory ChallengeBackup.fromJson(Map<String, dynamic> json) {
    return ChallengeBackup(
      doTimes: json['n_dotimes'],
      maxDoTimes: json['n_maxdotimes'],
      continueDoTimes: json['n_continuedotimes'],
      lastDoDate: json['d_lastdodate'] == 'null'
          ? DateTime(2000, 01, 01)
          : DateTime.parse(json['d_lastdodate']),
      doHistory: json['s_dohistory'],
    );
  }
}