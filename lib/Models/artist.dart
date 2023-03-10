import 'dart:convert';

Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

String artistToJson(Artist data) => json.encode(data.toJson());

class Artist {
  Artist({
    this.artists,
    this.meta,
  });

  List<ArtistElement>? artists;
  Meta? meta;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    artists: json["artists"] == null ? [] : List<ArtistElement>.from(json["artists"]!.map((x) => ArtistElement.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "artists": artists == null ? [] : List<dynamic>.from(artists!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class ArtistElement {
  ArtistElement({
    this.type,
    this.id,
    this.href,
    this.name,
    this.shortcut,
    this.amg,
    this.blurbs,
    this.bios,
    this.albumGroups,
    this.links,
    this.imageUrl=""
  });

  Type? type;
  String? id;
  String? href;
  String? name;
  String? shortcut;
  String? amg;
  List<String>? blurbs;
  List<Bio>? bios;
  AlbumGroups? albumGroups;
  Links? links;
  String imageUrl;

  factory ArtistElement.fromJson(Map<String, dynamic> json) => ArtistElement(
    type: typeValues.map[json["type"]]!,
    id: json["id"],
    href: json["href"],
    name: json["name"],
    shortcut: json["shortcut"],
    amg: json["amg"],
    blurbs: json["blurbs"] == null ? [] : List<String>.from(json["blurbs"]!.map((x) => x)),
    bios: json["bios"] == null ? [] : List<Bio>.from(json["bios"]!.map((x) => Bio.fromJson(x))),
    albumGroups: json["albumGroups"] == null ? null : AlbumGroups.fromJson(json["albumGroups"]),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "id": id,
    "href": href,
    "name": name,
    "shortcut": shortcut,
    "amg": amg,
    "blurbs": blurbs == null ? [] : List<dynamic>.from(blurbs!.map((x) => x)),
    "bios": bios == null ? [] : List<dynamic>.from(bios!.map((x) => x.toJson())),
    "albumGroups": albumGroups?.toJson(),
    "links": links?.toJson(),
  };
}

class AlbumGroups {
  AlbumGroups({
    this.others,
    this.compilations,
    this.singlesAndEPs,
    this.main,
  });

  List<String>? others;
  List<String>? compilations;
  List<String>? singlesAndEPs;
  List<String>? main;

  factory AlbumGroups.fromJson(Map<String, dynamic> json) => AlbumGroups(
    others: json["others"] == null ? [] : List<String>.from(json["others"]!.map((x) => x)),
    compilations: json["compilations"] == null ? [] : List<String>.from(json["compilations"]!.map((x) => x)),
    singlesAndEPs: json["singlesAndEPs"] == null ? [] : List<String>.from(json["singlesAndEPs"]!.map((x) => x)),
    main: json["main"] == null ? [] : List<String>.from(json["main"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "others": others == null ? [] : List<dynamic>.from(others!.map((x) => x)),
    "compilations": compilations == null ? [] : List<dynamic>.from(compilations!.map((x) => x)),
    "singlesAndEPs": singlesAndEPs == null ? [] : List<dynamic>.from(singlesAndEPs!.map((x) => x)),
    "main": main == null ? [] : List<dynamic>.from(main!.map((x) => x)),
  };
}

class Bio {
  Bio({
    this.title,
    this.author,
    this.publishDate,
    this.bio,
  });

  String? title;
  String? author;
  String? publishDate;
  String? bio;

  factory Bio.fromJson(Map<String, dynamic> json) => Bio(
    title: json["title"],
    author: json["author"],
    publishDate: json["publishDate"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "author": author,
    "publishDate": publishDate,
    "bio": bio,
  };
}

class Links {
  Links({
    this.albums,
    this.images,
    this.posts,
    this.topTracks,
    this.genres,
    this.stations,
    this.contemporaries,
    this.followers,
    this.influences,
    this.relatedProjects,
  });

  Albums? albums;
  Albums? images;
  Albums? posts;
  Albums? topTracks;
  Contemporaries? genres;
  Contemporaries? stations;
  Contemporaries? contemporaries;
  Contemporaries? followers;
  Contemporaries? influences;
  Contemporaries? relatedProjects;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    albums: json["albums"] == null ? null : Albums.fromJson(json["albums"]),
    images: json["images"] == null ? null : Albums.fromJson(json["images"]),
    posts: json["posts"] == null ? null : Albums.fromJson(json["posts"]),
    topTracks: json["topTracks"] == null ? null : Albums.fromJson(json["topTracks"]),
    genres: json["genres"] == null ? null : Contemporaries.fromJson(json["genres"]),
    stations: json["stations"] == null ? null : Contemporaries.fromJson(json["stations"]),
    contemporaries: json["contemporaries"] == null ? null : Contemporaries.fromJson(json["contemporaries"]),
    followers: json["followers"] == null ? null : Contemporaries.fromJson(json["followers"]),
    influences: json["influences"] == null ? null : Contemporaries.fromJson(json["influences"]),
    relatedProjects: json["relatedProjects"] == null ? null : Contemporaries.fromJson(json["relatedProjects"]),
  );

  Map<String, dynamic> toJson() => {
    "albums": albums?.toJson(),
    "images": images?.toJson(),
    "posts": posts?.toJson(),
    "topTracks": topTracks?.toJson(),
    "genres": genres?.toJson(),
    "stations": stations?.toJson(),
    "contemporaries": contemporaries?.toJson(),
    "followers": followers?.toJson(),
    "influences": influences?.toJson(),
    "relatedProjects": relatedProjects?.toJson(),
  };
}

class Albums {
  Albums({
    this.href,
  });

  String? href;

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class Contemporaries {
  Contemporaries({
    this.ids,
    this.href,
  });

  List<String>? ids;
  String? href;

  factory Contemporaries.fromJson(Map<String, dynamic> json) => Contemporaries(
    ids: json["ids"] == null ? [] : List<String>.from(json["ids"]!.map((x) => x)),
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
    "href": href,
  };
}

enum Type { ARTIST }

final typeValues = EnumValues({
  "artist": Type.ARTIST
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
