// To parse this JSON data, do
//
//     final con = conFromMap(jsonString);

import 'dart:convert';

class Con {
    Con({
        this.name,
        this.host,
        this.port,
    });

    String? name;
    String? host;
    int? port;

    Con copyWith({
        String? name,
        String? host,
        int? port,
    }) => 
        Con(
            name: name ?? this.name,
            host: host ?? this.host,
            port: port ?? this.port,
        );

    factory Con.fromJson(String str) => Con.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Con.fromMap(Map<String, dynamic> json) => Con(
        name: json["name"],
        host: json["host"],
        port: json["port"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "host": host,
        "port": port,
    };
}
