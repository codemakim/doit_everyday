class ChallengeBackup {
  int doTimes = 0; // 수행 총 횟수
  int maxDoTimes = 0; // 최대 연속 수행일 수
  int continueDoTimes = 0; // 현재 연속 수행일 수
  DateTime? lastDoDate; // 최근 수행일시
  String doHistory = ''; // 일별 수행 여부 ex) 0,1,0,1,0,0,0,1,1,...

  ChallengeBackup({
    this.doTimes = 0,
    this.maxDoTimes = 0,
    this.continueDoTimes = 0,
    this.lastDoDate,
    this.doHistory = '',
  });

  Map<String, dynamic> toJson() => {
        'n_dotimes': doTimes,
        'n_maxdotimes': maxDoTimes,
        'n_continuedotimes': continueDoTimes,
        'd_lastdodate': lastDoDate?.toString() ?? 'null',
        's_dohistory': doHistory,
      };

  factory ChallengeBackup.fromJson(Map<String, dynamic> json) {
    return ChallengeBackup(
      doTimes: json['n_dotimes'] ?? 0,
      maxDoTimes: json['n_maxdotimes'] ?? 0,
      continueDoTimes: json['n_continuedotimes'] ?? 0,
      lastDoDate: json['d_lastdodate'] == 'null'
          ? null
          : DateTime.parse(json['d_lastdodate']),
      doHistory: json['s_dohistory'] ?? '',
    );
  }
}
