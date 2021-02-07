// To parse this JSON data, do
//
//     final people = peopleFromJson(jsonString);

import 'dart:convert';

People peopleFromJson(String str) => People.fromJson(json.decode(str));

String peopleToJson(People data) => json.encode(data.toJson());

class People {
    People({
        this.adult,
        this.alsoKnownAs,
        this.biography,
        this.birthday,
        this.deathday,
        this.gender,
        this.homepage,
        this.id,
        this.imdbId,
        this.knownForDepartment,
        this.name,
        this.placeOfBirth,
        this.popularity,
        this.profilePath,
    });

    bool adult;
    List<String> alsoKnownAs;
    String biography;
    DateTime birthday;
    DateTime deathday;
    int gender;
    dynamic homepage;
    int id;
    String imdbId;
    String knownForDepartment;
    String name;
    String placeOfBirth;
    double popularity;
    String profilePath;

    factory People.fromJson(Map<String, dynamic> json) => People(
        adult: json["adult"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json["biography"],
        birthday: json["birthday"]!=null?DateTime.parse(json["birthday"]):DateTime.parse("1500-02-03"),
        deathday: json["deathday"]!=null?DateTime.parse(json["deathday"]):DateTime.parse("1500-02-03"),
        gender: json["gender"],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "also_known_as": List<dynamic>.from(alsoKnownAs.map((x) => x)),
        "biography": biography,
        "birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "deathday": "${deathday.year.toString().padLeft(4, '0')}-${deathday.month.toString().padLeft(2, '0')}-${deathday.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "known_for_department": knownForDepartment,
        "name": name,
        "place_of_birth": placeOfBirth,
        "popularity": popularity,
        "profile_path": profilePath,
    };
}
