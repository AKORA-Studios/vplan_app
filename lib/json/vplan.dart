// To parse this JSON data, do
//
//     final vPlan = vPlanFromJson(jsonString);

import 'dart:convert';

VPlan vPlanFromJson(String str) => VPlan.fromJson(json.decode(str));

String vPlanToJson(VPlan data) => json.encode(data.toJson());

class VPlan {
  VPlan({
    required this.type,
    required this.head,
    required this.body,
    required this.info,
  });

  String type;
  Head head;
  List<Body> body;
  String info;

  factory VPlan.fromJson(Map<String, dynamic> json) => VPlan(
        type: json["_type"],
        head: Head.fromJson(json["head"]),
        body: List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "_type": type,
        "head": head.toJson(),
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "info": info,
      };
}

class Body {
  Body({
    required this.id,
    required this.bodyClass,
    required this.lesson,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.info,
    required this.changed,
  });

  int id;
  String bodyClass;
  String lesson;
  String subject;
  String teacher;
  String room;
  String info;
  List<ChangedElement> changed;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        id: json["_id"],
        bodyClass: json["class"],
        lesson: json["lesson"],
        subject: json["subject"],
        teacher: json["teacher"],
        room: json["room"],
        info: json["info"],
        changed: List<ChangedElement>.from(
            json["changed"].map((x) => changedElementValues.map[x])),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "class": bodyClass,
        "lesson": lesson,
        "subject": subject,
        "teacher": teacher,
        "room": room,
        "info": info,
        "changed": List<dynamic>.from(
            changed.map((x) => changedElementValues.reverse[x])),
      };
}

enum ChangedElement { SUBJECT, TEACHER, ROOM }

final changedElementValues = EnumValues({
  "room": ChangedElement.ROOM,
  "subject": ChangedElement.SUBJECT,
  "teacher": ChangedElement.TEACHER
});

class Head {
  Head({
    required this.title,
    required this.schoolname,
    required this.created,
    required this.changed,
    required this.missing,
  });

  String title;
  String schoolname;
  String created;
  ChangedClass changed;
  ChangedClass missing;

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        title: json["title"],
        schoolname: json["schoolname"],
        created: json["created"],
        changed: ChangedClass.fromJson(json["changed"]),
        missing: ChangedClass.fromJson(json["missing"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "schoolname": schoolname,
        "created": created,
        "changed": changed.toJson(),
        "missing": missing.toJson(),
      };
}

class ChangedClass {
  ChangedClass({
    required this.classes,
    required this.teachers,
  });

  String classes;
  String teachers;

  factory ChangedClass.fromJson(Map<String, dynamic> json) => ChangedClass(
        classes: json["classes"],
        teachers: json["teachers"],
      );

  Map<String, dynamic> toJson() => {
        "classes": classes,
        "teachers": teachers,
      };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    //@ignore
    //reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
