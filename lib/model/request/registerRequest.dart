// To parse this JSON data, do
//
//     final registerRequest = registerRequestFromJson(jsonString);

import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) => RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) => json.encode(data.toJson());

class RegisterRequest {
    String? fullname;
    String? phone;
    String? email;
    String? image;
    String? password;

    RegisterRequest({
        this.fullname,
        this.phone,
        this.email,
        this.image,
        this.password,
    });

    factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
