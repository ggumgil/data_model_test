// To parse this JSON data, do
//
//     final album = albumfromMap(jsonString);

import 'dart:convert';

void main() async {
  String mealJsonString =
      '{ "id": 1, "albumType": "meal", "filePath": "temp_path", "comment": "comment_hi", "detail": { "mealType": "breakfast", "mealSubType": "subType" }, "ddayId": -1, "eventDate": 15512, "createDate": 15512, "modifyDate": 15512, "weekOfYear": 12}';
  print(mealJsonString);
  print(json.decode(mealJsonString));
  Album album = albumfromMap(mealJsonString);
  print(album.toMap());

  String workoutJsonString =
      '{ "id": 1, "albumType": "workOut", "filePath": "temp_path", "comment": "comment_hi", "detail": { "workoutType": "cardio", "workoutSubType": "subType", "workoutPart": "chest", "workoutTime": 50}, "ddayId": -1, "eventDate": 15512, "createDate": 15512, "modifyDate": 15512, "weekOfYear": 12}';
  print(workoutJsonString);
  print(json.decode(workoutJsonString));
  Album album2 = albumfromMap(workoutJsonString);
  print(album2.toMap());

  String nunbodyJsonString =
      '{ "id": 1, "albumType": "nunBody", "filePath": "temp_path", "comment": "comment_hi", "detail": { "type": "guide1", "weight": 55, "condition": ["good", "bad", "not good"] }, "ddayId": -1, "eventDate": 15512, "createDate": 15512, "modifyDate": 15512, "weekOfYear": 12}';
  print(nunbodyJsonString);
  print(json.decode(nunbodyJsonString));
  Album album3 = albumfromMap(nunbodyJsonString);
  print(album3.toMap());

  String slideshowJsonString =
      '{ "id": 1, "albumType": "slideShow", "filePath": "temp_path", "comment": "comment_hi", "detail": { "title": "안녕하세요", "representImagePath": "good, bad, not good" }, "ddayId": -1, "eventDate": 15512, "createDate": 15512, "modifyDate": 15512, "weekOfYear": 12}';
  print(slideshowJsonString);
  print(json.decode(slideshowJsonString));
  Album album4 = albumfromMap(slideshowJsonString);
  print(album4.toMap());

  print(Condition.bad.iconImagePath);
}

enum AlbumType { nunBody, meal, workOut, slideShow }

enum Condition {
  good('1'),
  notbad('2'),
  bad('3'),
  pain('4'),
  musclePain('5'),
  menstruation('6'),
  ovulation('7'),
  lossOfAppetite('8'),
  increasedAppetite('9'),
  indigestion('10'),
  constipation('11');

  const Condition(this.iconImagePath);

  final String iconImagePath;
}

enum WorkOutType { cardio, anaerobic }

enum CardioSubType { health, homeTraining, crossFit, yoga, pilates, etc }

enum Anaerobic { walking, running, swimming, climbing, cycling, stair }

enum WorkOutPart { chest, shoulder, back, bicep, tricep, abs }

enum MealType { breakfast, lunch, dinner, snack, midnightSnack }

enum MealSubType { clean, highProtein, lowCarbon, salad, general }

enum NunBodyType { pose1, pose2, pose3, pose4 }

Album albumfromMap(String str) => Album.fromMap(json.decode(str));

String albumtoMap(Album data) => json.encode(data.toMap());

class Album {
  Album({
    this.id,
    required this.albumType,
    required this.filePath,
    required this.comment,
    required this.detail,
    this.ddayId,
    required this.eventDate,
    required this.createDate,
    required this.modifyDate,
    required this.weekOfYear,
  });

  int? id;
  String albumType;
  String filePath;
  String comment;
  Detail detail;
  int? ddayId;
  int eventDate;
  int createDate;
  int modifyDate;
  int weekOfYear;

  factory Album.fromMap(Map<String, dynamic> json) {
    Detail tempDetail;
    final albumType = AlbumType.values.byName(json["albumType"]);

    switch (albumType) {
      case AlbumType.nunBody:
        tempDetail = NunbodyDetail.fromMap(json["detail"]);
        break;
      case AlbumType.workOut:
        tempDetail = WorkoutDetail.fromMap(json["detail"]);
        break;
      case AlbumType.meal:
        tempDetail = MealDetail.fromMap(json["detail"]);
        break;
      case AlbumType.slideShow:
        tempDetail = SlideShowDetail.fromMap(json["detail"]);
        break;
      default:
        tempDetail = UnfiguredDetail.fromMap(json["detail"]);
    }

    return Album(
      id: json["id"],
      albumType: json["albumType"],
      filePath: json["filePath"],
      detail: tempDetail,
      comment: json["comment"],
      ddayId: json["ddayId"],
      eventDate: json["eventDate"],
      createDate: json["createDate"],
      modifyDate: json["modifyDate"],
      weekOfYear: json["weekOfYear"],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map["id"] = id;
    }
    if (ddayId != null) {
      map["ddayId"] = ddayId;
    } else {
      map["ddayId"] = -1;
    }
    map["albumType"] = albumType;
    map["filePath"] = filePath;
    map["comment"] = comment;
    map["detail"] = detail;
    map["eventDate"] = eventDate;
    map["createDate"] = createDate;
    map["modifyDate"] = modifyDate;
    map["weekOfYear"] = weekOfYear;

    return map;
  }
}

abstract class Detail {
  Detail();
  factory Detail.fromMap(Map<String, dynamic> json) {
    throw TypeError();
  }

  Map<String, dynamic> toMap();
}

class UnfiguredDetail extends Detail {
  UnfiguredDetail();
  @override
  factory UnfiguredDetail.fromMap(Map<String, dynamic> json) {
    throw TypeError();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class NunbodyDetail extends Detail {
  NunbodyDetail({
    required this.type,
    required this.weight,
    required this.condition,
  });

  String type;
  int weight;
  List<String> condition;

  @override
  factory NunbodyDetail.fromMap(Map<String, dynamic> json) => NunbodyDetail(
        type: json["type"],
        weight: json["weight"],
        condition: List<String>.from(json["condition"].map((x) => x)),
      );

  @override
  Map<String, dynamic> toMap() => {
        "type": type,
        "weight": weight,
        "condition": List<dynamic>.from(condition.map((x) => x)),
      };
}

class WorkoutDetail extends Detail {
  WorkoutDetail({
    required this.workoutType,
    required this.workoutSubType,
    required this.workoutPart,
    required this.workoutTime,
  });

  String workoutType;
  String workoutSubType;
  String workoutPart;
  int workoutTime;

  @override
  factory WorkoutDetail.fromMap(Map<String, dynamic> json) => WorkoutDetail(
        workoutType: json["workoutType"],
        workoutSubType: json["workoutSubType"],
        workoutPart: json["workoutPart"],
        workoutTime: json["workoutTime"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "workoutType": workoutType,
        "workoutSubType": workoutSubType,
        "workoutPart": workoutPart,
        "workoutTime": workoutTime,
      };
}

class MealDetail extends Detail {
  MealDetail({
    required this.mealType,
    required this.mealSubType,
  });

  String mealType;
  String mealSubType;

  @override
  factory MealDetail.fromMap(Map<String, dynamic> json) => MealDetail(
        mealType: json["mealType"],
        mealSubType: json["mealSubType"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "mealType": mealType,
        "mealSubType": mealSubType,
      };
}

class SlideShowDetail extends Detail {
  SlideShowDetail({
    required this.title,
    required this.representImagePath,
  });

  String title;
  String representImagePath;

  @override
  factory SlideShowDetail.fromMap(Map<String, dynamic> json) => SlideShowDetail(
        title: json["title"],
        representImagePath: json["representImagePath"],
      );
  @override
  Map<String, dynamic> toMap() => {
        "title": title,
        "representImagePath": representImagePath,
      };
}
