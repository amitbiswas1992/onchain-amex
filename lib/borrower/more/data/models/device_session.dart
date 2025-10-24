class DeviceSession {
  String? id;
  String? userId;
  String? deviceId;
  String? accessToken;
  String? refreshToken;
  bool? isActive;
  String? expiresAt;
  String? ipAddress;
  Null location;
  String? userAgent;
  String? createdAt;
  String? updatedAt;
  Device? device;

  DeviceSession(
      {this.id,
        this.userId,
        this.deviceId,
        this.accessToken,
        this.refreshToken,
        this.isActive,
        this.expiresAt,
        this.ipAddress,
        this.location,
        this.userAgent,
        this.createdAt,
        this.updatedAt,
        this.device,});

  DeviceSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    deviceId = json['deviceId'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    isActive = json['isActive'];
    expiresAt = json['expiresAt'];
    ipAddress = json['ipAddress'];
    location = json['location'];
    userAgent = json['userAgent'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    device =
    json['device'] != null ? Device.fromJson(json['device']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['deviceId'] = deviceId;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['isActive'] = isActive;
    data['expiresAt'] = expiresAt;
    data['ipAddress'] = ipAddress;
    data['location'] = location;
    data['userAgent'] = userAgent;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (device != null) {
      data['device'] = device!.toJson();
    }
    return data;
  }
}

class Device {
  String? deviceName;
  String? deviceType;
  String? platform;
  String? browserName;

  Device({this.deviceName, this.deviceType, this.platform, this.browserName});

  Device.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    deviceType = json['deviceType'];
    platform = json['platform'];
    browserName = json['browserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    data['deviceType'] = deviceType;
    data['platform'] = platform;
    data['browserName'] = browserName;
    return data;
  }
}
