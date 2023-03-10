
// class Track {
//   final String trackName;//
//   final String artistName;//
//   final String trackImg;//
//   final String albumName;//
//   final int playbackSeconds;//
//   final String artistId;
//   final String albumId;
//   final String trackLink;//
//    String imageUrl;//
//
//   Track(
//       {this.imageUrl="",
//         required this.trackImg,
//       required this.albumId,
//       required this.albumName,
//       required this.artistId,
//       required this.artistName,
//       required this.playbackSeconds,
//       required this.trackLink,
//       required this.trackName});
// }
// To parse this JSON data, do
//
//     final tracks = tracksFromJson(jsonString);

// To parse this JSON data, do
//
//     final track = trackFromJson(jsonString);

import 'dart:convert';

Track trackFromJson(String str) => Track.fromJson(json.decode(str));

String trackToJson(Track data) => json.encode(data.toJson());

class Track {
  Track({
    this.meta,
    this.tracks,
  });

  Meta? meta;
  List<TrackElement>? tracks;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    tracks: json["tracks"] == null ? [] : List<TrackElement>.from(json["tracks"]!.map((x) => TrackElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "tracks": tracks == null ? [] : List<dynamic>.from(tracks!.map((x) => x.toJson())),
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

class TrackElement {
  TrackElement({
    this.type,
    this.id,
    this.index,
    this.disc,
    this.href,
    this.playbackSeconds,
    this.isExplicit,
    this.isStreamable,
    this.isAvailableInHiRes,
    this.name,
    this.isrc,
    this.shortcut,
    this.blurbs,
    this.artistId,
    this.artistName,
    this.albumName,
    this.formats,
    this.losslessFormats,
    this.albumId,
    this.isAvailableInAtmos,
    this.contributors,
    this.links,
    this.previewUrl,
    this.imageUrl=""
  });

  TrackType? type;
  String? id;
  int? index;
  int? disc;
  String? href;
  int? playbackSeconds;
  bool? isExplicit;
  bool? isStreamable;
  bool? isAvailableInHiRes;
  String? name;
  String? isrc;
  String? shortcut;
  List<dynamic>? blurbs;
  String? artistId;
  String? artistName;
  String? albumName;
  List<Format>? formats;
  List<Format>? losslessFormats;
  String? albumId;
  bool? isAvailableInAtmos;
  Contributors? contributors;
  Links? links;
  String? previewUrl;
  String? imageUrl;

  factory TrackElement.fromJson(Map<String, dynamic> json) => TrackElement(
    type: trackTypeValues.map[json["type"]]!,
    id: json["id"],
    index: json["index"],
    disc: json["disc"],
    href: json["href"],
    playbackSeconds: json["playbackSeconds"],
    isExplicit: json["isExplicit"],
    isStreamable: json["isStreamable"],
    isAvailableInHiRes: json["isAvailableInHiRes"],
    name: json["name"],
    isrc: json["isrc"],
    shortcut: json["shortcut"],
    blurbs: json["blurbs"] == null ? [] : List<dynamic>.from(json["blurbs"]!.map((x) => x)),
    artistId: json["artistId"],
    artistName: json["artistName"],
    albumName: json["albumName"],
    formats: json["formats"] == null ? [] : List<Format>.from(json["formats"]!.map((x) => Format.fromJson(x))),
    losslessFormats: json["losslessFormats"] == null ? [] : List<Format>.from(json["losslessFormats"]!.map((x) => Format.fromJson(x))),
    albumId: json["albumId"],
    isAvailableInAtmos: json["isAvailableInAtmos"],
    contributors: json["contributors"] == null ? null : Contributors.fromJson(json["contributors"]),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    previewUrl: json["previewURL"],
  );

  Map<String, dynamic> toJson() => {
    "type": trackTypeValues.reverse[type],
    "id": id,
    "index": index,
    "disc": disc,
    "href": href,
    "playbackSeconds": playbackSeconds,
    "isExplicit": isExplicit,
    "isStreamable": isStreamable,
    "isAvailableInHiRes": isAvailableInHiRes,
    "name": name,
    "isrc": isrc,
    "shortcut": shortcut,
    "blurbs": blurbs == null ? [] : List<dynamic>.from(blurbs!.map((x) => x)),
    "artistId": artistId,
    "artistName": artistName,
    "albumName": albumName,
    "formats": formats == null ? [] : List<dynamic>.from(formats!.map((x) => x.toJson())),
    "losslessFormats": losslessFormats == null ? [] : List<dynamic>.from(losslessFormats!.map((x) => x.toJson())),
    "albumId": albumId,
    "isAvailableInAtmos": isAvailableInAtmos,
    "contributors": contributors?.toJson(),
    "links": links?.toJson(),
    "previewURL": previewUrl,
  };
}

class Contributors {
  Contributors({
    this.composer,
    this.featuredPerformer,
    this.guestVocals,
    this.guestMusician,
    this.producer,
    this.primaryArtist,
    this.engineer,
    this.nonPrimary,
    this.remixer,
    this.collaborator,
  });

  String? composer;
  String? featuredPerformer;
  String? guestVocals;
  String? guestMusician;
  String? producer;
  String? primaryArtist;
  String? engineer;
  String? nonPrimary;
  String? remixer;
  String? collaborator;

  factory Contributors.fromJson(Map<String, dynamic> json) => Contributors(
    composer: json["composer"],
    featuredPerformer: json["featuredPerformer"],
    guestVocals: json["guestVocals"],
    guestMusician: json["guestMusician"],
    producer: json["producer"],
    primaryArtist: json["primaryArtist"],
    engineer: json["engineer"],
    nonPrimary: json["nonPrimary"],
    remixer: json["remixer"],
    collaborator: json["collaborator"],
  );

  Map<String, dynamic> toJson() => {
    "composer": composer,
    "featuredPerformer": featuredPerformer,
    "guestVocals": guestVocals,
    "guestMusician": guestMusician,
    "producer": producer,
    "primaryArtist": primaryArtist,
    "engineer": engineer,
    "nonPrimary": nonPrimary,
    "remixer": remixer,
    "collaborator": collaborator,
  };
}

class Format {
  Format({
    this.type,
    this.bitrate,
    this.name,
    this.sampleBits,
    this.sampleRate,
  });

  FormatType? type;
  int? bitrate;
  Name? name;
  int? sampleBits;
  int? sampleRate;

  factory Format.fromJson(Map<String, dynamic> json) => Format(
    type: formatTypeValues.map[json["type"]]!,
    bitrate: json["bitrate"],
    name: nameValues.map[json["name"]]!,
    sampleBits: json["sampleBits"],
    sampleRate: json["sampleRate"],
  );

  Map<String, dynamic> toJson() => {
    "type": formatTypeValues.reverse[type],
    "bitrate": bitrate,
    "name": nameValues.reverse[name],
    "sampleBits": sampleBits,
    "sampleRate": sampleRate,
  };
}

enum Name { MP3, AAC, AAC_PLUS, FLAC }

final nameValues = EnumValues({
  "AAC": Name.AAC,
  "AAC PLUS": Name.AAC_PLUS,
  "FLAC": Name.FLAC,
  "MP3": Name.MP3
});

enum FormatType { FORMAT }

final formatTypeValues = EnumValues({
  "format": FormatType.FORMAT
});

class Links {
  Links({
    this.artists,
    this.albums,
    this.composers,
    this.genres,
    this.tags,
  });

  Albums? artists;
  Albums? albums;
  Albums? composers;
  Albums? genres;
  Albums? tags;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    artists: json["artists"] == null ? null : Albums.fromJson(json["artists"]),
    albums: json["albums"] == null ? null : Albums.fromJson(json["albums"]),
    composers: json["composers"] == null ? null : Albums.fromJson(json["composers"]),
    genres: json["genres"] == null ? null : Albums.fromJson(json["genres"]),
    tags: json["tags"] == null ? null : Albums.fromJson(json["tags"]),
  );

  Map<String, dynamic> toJson() => {
    "artists": artists?.toJson(),
    "albums": albums?.toJson(),
    "composers": composers?.toJson(),
    "genres": genres?.toJson(),
    "tags": tags?.toJson(),
  };
}

class Albums {
  Albums({
    this.ids,
    this.href,
  });

  List<String>? ids;
  String? href;

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    ids: json["ids"] == null ? [] : List<String>.from(json["ids"]!.map((x) => x)),
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
    "href": href,
  };
}

enum TrackType { TRACK }

final trackTypeValues = EnumValues({
  "track": TrackType.TRACK
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
