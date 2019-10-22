
import 'package:challenge_everyday/model/challenge/challenge.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

final String challengeTableName = 'and_challenge';

/// Challenge 도메인의 CRUD를 위한 리파지토리 클래스입니다.
/// 김정현
/// 2019.08.27
///
class ChallengeRepository {
  // 싱글톤으로 만들어야 하므로 생성자를 private 로 생성.
  ChallengeRepository._();

  // 외부에서 접근할 수 있도록 클래스 변수 선언
  static final ChallengeRepository _db = ChallengeRepository._();

  // 외부에서 'DbHelper()'로 접근할 수 있도록 함.
  factory ChallengeRepository() => _db;

  static Database _database;

  // 데이터베이스가 생성되지 않았을 경우 생성하여 반환한다.
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initChallengeDB();
    return _database;
  }

  //Challenge 테이블을 초기화하기 위한 함수
  initChallengeDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'challengeDB.db');

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $challengeTableName (
            n_index INTEGER PRIMARY KEY AUTOINCREMENT,
            s_title TEXT NOT NULL,
            d_startdate TEXT NOT NULL DEFAULT (datetime('now','localtime')),
            d_enddate TEXT NOT NULL DEFAULT (datetime('now','localtime')),
            s_weekday TEXT NOT NULL DEFAULT '12345',
            n_dotimes INTEGER DEFAULT 0,
            n_totaltimes INTEGER DEFAULT 0,
            n_maxdotimes INTEGER DEFAULT 0,
            n_continuedotimes INTEGER DEFAULT 0,
            d_lastdodate TEXT,
            s_dohistory TEXT DeFAULT '',
            s_challengeBackup TEXT DeFAULT '',
            b_valid INTEGER NOT NULL DEFAULT 1,
            n_userindex INTEGER NOT NULL DEFAULT 0,
            d_createdate TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
          )
          '''
          );
        },
        onUpgrade: (db, oldVersion, newVersion) {}
    );
  }

  /// Challenge 정보를 abh_challenge 테이블에 저장하기 위한 메소드입니다.
  insertChallenge(Challenge challenge) async {
    final db = await database;
    int result = await db.insert(challengeTableName, challenge.toDBMap());
    //TODO 로깅
    print('insert Challenge result : $result');
    return result;
  }

  /// n_index 컬럼을 이용해 Challenge 정보 1개를 가져오기 위한 메소드입니다.
  Future<Challenge> selectOneChallengeByIndex(int index) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
        challengeTableName,
        where: 'n_index=? and b_valid=1',
        whereArgs: [index]);
    //TODO 로깅
    print('selectOne Challenge result : $result');
    return result.isNotEmpty ? Challenge.fromJson(result.first) : null;
  }

  /// adh_Challenge 테이블의 모든 Challenge 정보를 가져오기 위한 메소드입니다.
  Future<List<Challenge>> selectAllChallenge() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(challengeTableName);
    List<Challenge> list = result.isNotEmpty ? result.map((res) => Challenge.fromJson(res)).toList() : [];
    return list;
  }

  /// b_valid 컬럼의 값이 1인 Challenge 목록을 가져오기 위한 리파지토리입니다.
  Future<List<Challenge>> selectChallengeByTrueValid() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
        challengeTableName,
      where: 'b_valid=1'
    );
    //TODO 로깅
    print('select Challenge by valid(true): $result');
    return result.isNotEmpty ? result.map((c) => Challenge.fromJson(c)).toList() : [];
  }

  /// 메인화면 목록에 표시를 위한 리파지토리입니다.
  Future<List<Challenge>> selectChallengeForMainListTile() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
        challengeTableName,
        where: '''
        b_valid=1 
        AND d_startdate <= '${DateTime.now().toString()}'
        AND d_enddate >= '${DateTime.now().toString()}'
        AND s_weekday LIKE '%${DateTime.now().weekday}%'
        '''
    );
    //TODO 로깅
    print('select Challenge for ListTile: $result');
    return result.isNotEmpty ? result.map((c) => Challenge.fromJson(c)).toList() : result;
  }

  /// Challenge 정보를 업데이트하기 위한 메소드입니다.
  updateChallenge(Challenge challenge) async {
    final db = await database;
    int result = await db.update(
        challengeTableName, challenge.toDBMap(),
        where: 'n_index=?',
        whereArgs: [challenge.index]);
    //TODO 로깅
    print('update Challenge result : $result');
    return result;
  }

  /// Challenge 의 마지막 날짜가 오늘보다
  updateChallengeValid() async {
    final db = await database;
    int resultCount = 0;
    List<Challenge> list = await selectChallengeByTrueValid();
    list.forEach((i) async {
      i.valid = false;
      int result = await db.update(
        challengeTableName,
        i.toDBMap(),
        where: '''
        n_index=? and
        d_enddate < '${DateTime.now().toString()}'
        ''',
        whereArgs: [i.index]
      );
      resultCount += result;
    });
    return resultCount;
  }

  /// index 에 해당하는 Challenge 정보를 삭제하기 위한 메소드입니다.
  deleteChallenge(int index) async {
    final db = await database;
    int result = await db.delete(challengeTableName, where: 'n_index=?', whereArgs: [index]);
    //TODO 로깅
    print('delete Challenge result : $result');
    return result;
  }
}