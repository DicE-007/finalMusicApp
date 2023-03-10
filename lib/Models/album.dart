import 'dart:convert';

Album albumFromJson(String str) => Album.fromJson(json.decode(str));

String albumToJson(Album data) => json.encode(data.toJson());

class Album {
  Album({
    this.meta,
    this.albums,
  });

  Meta? meta;
  List<AlbumElement>? albums;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    albums: json["albums"] == null ? [] : List<AlbumElement>.from(json["albums"]!.map((x) => AlbumElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "albums": albums == null ? [] : List<dynamic>.from(albums!.map((x) => x.toJson())),
  };
}

class AlbumElement {
  AlbumElement({
    this.type,
    this.id,
    this.upc,
    this.shortcut,
    this.href,
    this.name,
    this.released,
    this.originallyReleased,
    this.label,
    this.copyright,
    // this.tags,
    this.discCount,
    this.trackCount,
    this.isExplicit,
    this.isSingle,
    // this.accountPartner,
    this.artistName,
    this.isAvailableInHiRes,
    this.isAvailableInAtmos,
    this.contributingArtists,
    this.discographies,
    this.links,
    this.isStreamable,
    this.amg,
    this.imageUrl=""
  });

  Type? type;
  String? id;
  String? upc;
  String? shortcut;
  String? href;
  String? name;
  String? released;
  DateTime? originallyReleased;
  String? label;
  String? copyright;
  // List<Tag>? tags;
  int? discCount;
  int? trackCount;
  bool? isExplicit;
  bool? isSingle;
  // AccountPartner? accountPartner;
  String? artistName;
  bool? isAvailableInHiRes;
  bool? isAvailableInAtmos;
  ContributingArtists? contributingArtists;
  Discographies? discographies;
  Links? links;
  bool? isStreamable;
  String? amg;
  String? imageUrl;

  factory AlbumElement.fromJson(Map<String, dynamic> json) => AlbumElement(
    type: typeValues.map[json["type"]]!,
    id: json["id"],
    upc: json["upc"],
    shortcut: json["shortcut"],
    href: json["href"],
    name: json["name"],
    released: json["released"],
    originallyReleased: json["originallyReleased"] == null ? null : DateTime.parse(json["originallyReleased"]),
    label: json["label"],
    copyright: json["copyright"],
    // tags: json["tags"] == null ? [] : List<Tag>.from(json["tags"]!.map((x) => tagValues.map[x]!)),
    discCount: json["discCount"],
    trackCount: json["trackCount"],
    isExplicit: json["isExplicit"],
    isSingle: json["isSingle"],
    // accountPartner: accountPartnerValues.map[json["accountPartner"]]!,
    artistName: json["artistName"],
    isAvailableInHiRes: json["isAvailableInHiRes"],
    isAvailableInAtmos: json["isAvailableInAtmos"],
    contributingArtists: json["contributingArtists"] == null ? null : ContributingArtists.fromJson(json["contributingArtists"]),
    discographies: json["discographies"] == null ? null : Discographies.fromJson(json["discographies"]),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    isStreamable: json["isStreamable"],
    amg: json["amg"],
  );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "id": id,
    "upc": upc,
    "shortcut": shortcut,
    "href": href,
    "name": name,
    "released": released,
    "originallyReleased": originallyReleased?.toIso8601String(),
    "label": label,
    "copyright": copyright,
    // "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => tagValues.reverse[x])),
    "discCount": discCount,
    "trackCount": trackCount,
    "isExplicit": isExplicit,
    "isSingle": isSingle,
    // "accountPartner": accountPartnerValues.reverse[accountPartner],
    "artistName": artistName,
    "isAvailableInHiRes": isAvailableInHiRes,
    "isAvailableInAtmos": isAvailableInAtmos,
    "contributingArtists": contributingArtists?.toJson(),
    "discographies": discographies?.toJson(),
    "links": links?.toJson(),
    "isStreamable": isStreamable,
    "amg": amg,
  };
}

enum AccountPartner { SONY, UMG_GLOBAL, ORCHARD_ENTERPRISES_INC, WARNER }

final accountPartnerValues = EnumValues({
  "Orchard Enterprises Inc": AccountPartner.ORCHARD_ENTERPRISES_INC,
  "Sony": AccountPartner.SONY,
  "UMG Global": AccountPartner.UMG_GLOBAL,
  "Warner": AccountPartner.WARNER
});

class ContributingArtists {
  ContributingArtists({
    this.primaryArtist,
  });

  String? primaryArtist;

  factory ContributingArtists.fromJson(Map<String, dynamic> json) => ContributingArtists(
    primaryArtist: json["primaryArtist"],
  );

  Map<String, dynamic> toJson() => {
    "primaryArtist": primaryArtist,
  };
}

class Discographies {
  Discographies({
    this.others,
    this.main,
  });

  List<String>? others;
  List<String>? main;

  factory Discographies.fromJson(Map<String, dynamic> json) => Discographies(
    others: json["others"] == null ? [] : List<String>.from(json["others"]!.map((x) => x)),
    main: json["main"] == null ? [] : List<String>.from(json["main"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "others": others == null ? [] : List<dynamic>.from(others!.map((x) => x)),
    "main": main == null ? [] : List<dynamic>.from(main!.map((x) => x)),
  };
}

class Links {
  Links({
    this.images,
    this.tracks,
    this.posts,
    this.artists,
    this.genres,
    this.reviews,
  });

  Images? images;
  Images? tracks;
  Images? posts;
  Artists? artists;
  Artists? genres;
  Artists? reviews;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    images: json["images"] == null ? null : Images.fromJson(json["images"]),
    tracks: json["tracks"] == null ? null : Images.fromJson(json["tracks"]),
    posts: json["posts"] == null ? null : Images.fromJson(json["posts"]),
    artists: json["artists"] == null ? null : Artists.fromJson(json["artists"]),
    genres: json["genres"] == null ? null : Artists.fromJson(json["genres"]),
    reviews: json["reviews"] == null ? null : Artists.fromJson(json["reviews"]),
  );

  Map<String, dynamic> toJson() => {
    "images": images?.toJson(),
    "tracks": tracks?.toJson(),
    "posts": posts?.toJson(),
    "artists": artists?.toJson(),
    "genres": genres?.toJson(),
    "reviews": reviews?.toJson(),
  };
}

class Artists {
  Artists({
    this.ids,
    this.href,
  });

  List<String>? ids;
  String? href;

  factory Artists.fromJson(Map<String, dynamic> json) => Artists(
    ids: json["ids"] == null ? [] : List<String>.from(json["ids"]!.map((x) => x)),
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
    "href": href,
  };
}

class Images {
  Images({
    this.href,
  });

  String? href;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

enum Tag { EXPLICIT }

final tagValues = EnumValues({
  "Explicit": Tag.EXPLICIT
});

enum Type { ALBUM }

final typeValues = EnumValues({
  "album": Type.ALBUM
});

class Meta {
  Meta({
    this.returnedCount,
    this.totalCount,
  });

  int? returnedCount;
  int? totalCount;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    returnedCount: json["returnedCount"],
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "returnedCount": returnedCount,
    "totalCount": totalCount,
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
