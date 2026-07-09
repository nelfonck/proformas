import 'dart:convert';

class AppsUpdate {
    AppsUpdate({
        this.appName,
        this.versionCode,
        this.versionName,
        this.dodwnloadUrl,
        this.packageName,
        this.features
    });

    String? appName;
    int? versionCode;
    String? versionName;
    String? dodwnloadUrl;
    String? packageName ;
    String? features ; 

    factory AppsUpdate.fromJson(String str) => AppsUpdate.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AppsUpdate.fromMap(Map<String, dynamic> json) => AppsUpdate(
        appName: json["app_name"],
        versionCode: json["version_code"],
        versionName: json["version_name"],
        dodwnloadUrl: json["dodwnload_url"],
        packageName: json["package_name"],
        features: json["features"],
    );

    Map<String, dynamic> toMap() => {
        "app_name": appName,
        "version_code": versionCode,
        "version_name": versionName,
        "dodwnload_url": dodwnloadUrl,
        "features": features,
    };
}