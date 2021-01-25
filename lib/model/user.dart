class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.status,
    this.avatar,
  });

  String id;
  String firstName;
  String lastName;
  Gender gender;
  DateTime dob;
  String email;
  String phone;
  String website;
  String address;
  Status status;
  String avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: genderValues.map[json["gender"]],
        dob: DateTime.parse(json["dob"]),
        email: json["email"],
        phone: json["phone"],
        website: json["website"],
        address: json["address"],
        status: statusValues.map[json["status"]],
        avatar: json["_links"]["avatar"]["href"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "gender": genderValues.reverse[gender],
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "email": email,
        "phone": phone,
        "website": website,
        "address": address,
        "status": statusValues.reverse[status],
        "avatar": avatar,
      };
}

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({"female": Gender.FEMALE, "male": Gender.MALE});

enum Status { ACTIVE, INACTIVE }

final statusValues =
    EnumValues({"active": Status.ACTIVE, "inactive": Status.INACTIVE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class Meta {
  Meta({
    this.success,
    this.code,
    this.message,
    this.totalCount,
    this.pageCount,
    this.currentPage,
    this.perPage,
    this.rateLimit,
  });

  bool success;
  int code;
  String message;
  int totalCount;
  int pageCount;
  int currentPage;
  int perPage;
  RateLimit rateLimit;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    totalCount: json["totalCount"],
    pageCount: json["pageCount"],
    currentPage: json["currentPage"],
    perPage: json["perPage"],
    rateLimit: RateLimit.fromJson(json["rateLimit"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "totalCount": totalCount,
    "pageCount": pageCount,
    "currentPage": currentPage,
    "perPage": perPage,
    "rateLimit": rateLimit.toJson(),
  };
}

class RateLimit {
  RateLimit({
    this.limit,
    this.remaining,
    this.reset,
  });

  int limit;
  int remaining;
  int reset;

  factory RateLimit.fromJson(Map<String, dynamic> json) => RateLimit(
    limit: json["limit"],
    remaining: json["remaining"],
    reset: json["reset"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "remaining": remaining,
    "reset": reset,
  };
}
