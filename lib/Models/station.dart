// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

Station stationFromJson(String str) => Station.fromJson(json.decode(str));

String stationToJson(Station data) => json.encode(data.toJson());

class Station {
  Station({
    this.meta,
    this.stations,
  });

  Meta? meta;
  List<StationElement>? stations;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    stations: json["stations"] == null ? [] : List<StationElement>.from(json["stations"]!.map((x) => StationElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "stations": stations == null ? [] : List<dynamic>.from(stations!.map((x) => x.toJson())),
  };
}

class Meta {
  Meta({
    this.totalCount,
    this.returnedCount,
  });

  int? totalCount;
  int? returnedCount;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    totalCount: json["totalCount"],
    returnedCount: json["returnedCount"],
  );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "returnedCount": returnedCount,
  };
}

class StationElement {
  StationElement({
    this.id,
    this.type,
    this.href,
    this.subType,
    this.name,
    this.author,
    this.description,
    this.summary,
    this.artists,
    this.links,
  });

  String? id;
  Type? type;
  String? href;
  SubType? subType;
  String? name;
  String? author;
  String? description;
  String? summary;
  String? artists;
  Links? links;

  factory StationElement.fromJson(Map<String, dynamic> json) => StationElement(
    id: json["id"],
    type: typeValues.map[json["type"]]!,
    href: json["href"],
    subType: subTypeValues.map[json["subType"]]!,
    name: json["name"],
    author: json["author"],
    description: json["description"],
    summary: json["summary"],
    artists: json["artists"],
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": typeValues.reverse[type],
    "href": href,
    "subType": subTypeValues.reverse[subType],
    "name": name,
    "author": author,
    "description": description,
    "summary": summary,
    "artists": artists,
    "links": links?.toJson(),
  };
}

class Links {
  Links({
    this.genres,
    this.mediumImage,
    this.largeImage,
  });

  Genres? genres;
  Image? mediumImage;
  Image? largeImage;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    genres: json["genres"] == null ? null : Genres.fromJson(json["genres"]),
    mediumImage: json["mediumImage"] == null ? null : Image.fromJson(json["mediumImage"]),
    largeImage: json["largeImage"] == null ? null : Image.fromJson(json["largeImage"]),
  );

  Map<String, dynamic> toJson() => {
    "genres": genres?.toJson(),
    "mediumImage": mediumImage?.toJson(),
    "largeImage": largeImage?.toJson(),
  };
}

class Genres {
  Genres({
    this.ids,
    this.href,
  });

  List<String>? ids;
  String? href;

  factory Genres.fromJson(Map<String, dynamic> json) => Genres(
    ids: json["ids"] == null ? [] : List<String>.from(json["ids"]!.map((x) => x)),
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
    "href": href,
  };
}

class Image {
  Image({
    this.href,
  });

  String? href;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

enum SubType { PROGRAMMED_STATION }

final subTypeValues = EnumValues({
  "Programmed Station": SubType.PROGRAMMED_STATION
});

enum Type { STATION }

final typeValues = EnumValues({
  "station": Type.STATION
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

