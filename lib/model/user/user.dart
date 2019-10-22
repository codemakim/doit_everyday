
///
/// @Author jhkim
/// @Since 2019.07.24
/// 회원 정보를 저장하기 위한 도메인입니다.
/// TODO 지속적인 수저을 통해 도메인 및 테이블을 보완해야합니다.

class User {
  int _index;              // 기본키
  String _name;            // 이름
  String _nickName;        // 별명
  String _email;           // 이메일
  String _imageUrl;        // 프로필 이미지
  int _facebook;           // 페이스북 회원 여부
  String _facebookKey;     // 페이스북 키
  int _google;             // 구글 회원 여부
  String _googleKey;       // 구글 키
  String _memo;            // 메모
  DateTime _createDate;    // 가입일

  User({
        int index,
        String name,
        String nickName,
        String email,
        String imageUrl,
        int facebook,
        String facebookKey,
        int google,
        String googleKey,
        String memo,
        DateTime createDate
      }) {
    _index = index;
    _name = name;
    _nickName = nickName;
    _email = email;
    _imageUrl = imageUrl;
    _facebook = facebook;
    _facebookKey = facebookKey;
    _google = google;
    _googleKey = googleKey;
    _memo = memo;
    _createDate = createDate;
  }

  DateTime get createDate => _createDate; // ignore: unnecessary_getters_setters

  set createDate(DateTime value) { // ignore: unnecessary_getters_setters
    _createDate = value;
  }

  String get memo => _memo; // ignore: unnecessary_getters_setters

  set memo(String value) { // ignore: unnecessary_getters_setters
    _memo = value;
  }

  String get googleKey => _googleKey; // ignore: unnecessary_getters_setters

  set googleKey(String value) { // ignore: unnecessary_getters_setters
    _googleKey = value;
  }

  int get google => _google; // ignore: unnecessary_getters_setters

  set google(int value) { // ignore: unnecessary_getters_setters
    _google = value;
  }

  String get facebookKey => _facebookKey; // ignore: unnecessary_getters_setters

  set facebookKey(String value) { // ignore: unnecessary_getters_setters
    _facebookKey = value;
  }

  int get facebook => _facebook; // ignore: unnecessary_getters_setters

  set facebook(int value) { // ignore: unnecessary_getters_setters
    _facebook = value;
  }

  String get imageUrl => _imageUrl; // ignore: unnecessary_getters_setters

  set imageUrl(String value) { // ignore: unnecessary_getters_setters
    _imageUrl = value;
  }

  String get email => _email; // ignore: unnecessary_getters_setters

  set email(String value) { // ignore: unnecessary_getters_setters
    _email = value;
  }

  String get nickName => _nickName; // ignore: unnecessary_getters_setters

  set nickName(String value) { // ignore: unnecessary_getters_setters
    _nickName = value;
  }

  String get name => _name; // ignore: unnecessary_getters_setters

  set name(String value) { // ignore: unnecessary_getters_setters
    _name = value;
  }

  int get index => _index; // ignore: unnecessary_getters_setters

  set index(int value) { // ignore: unnecessary_getters_setters
    _index = value;
  }

  @override
  String toString() {
    return 'User{_index: $_index, _name: $_name, _nickName: $_nickName, _email: $_email, _imageUrl: $_imageUrl, _facebook: $_facebook, _facebookKey: $_facebookKey, _google: $_google, _googleKey: $_googleKey, _memo: $_memo, _createDate: $_createDate}';
  }
}