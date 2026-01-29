import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  int? uid;
  bool? isSystem;
  bool? isAdmin;
  UserContext? userContext;
  String? db;
  String? serverVersion;
  List<dynamic>? serverVersionInfo;
  String? supportUrl;
  String? name;
  String? username;
  String? partnerDisplayName;
  int? companyId;
  int? partnerId;
  String? webBaseUrl;
  int? activeIdsLimit;
  dynamic profileSession;
  dynamic profileCollectors;
  dynamic profileParams;
  int? maxFileUploadSize;
  bool? homeActionId;
  CacheHashes? cacheHashes;
  Map<String, Currency>? currencies;
  BundleParams? bundleParams;
  UserCompanies? userCompanies;
  bool? showEffect;
  bool? displaySwitchCompanyMenu;
  List<int>? userId;
  String? notificationType;
  bool? odoobotInitialized;
  Session? session;
  String? profileImage;
  String? userType;
  bool? del_activity_users;

  LoginResponseModel({
    this.uid,
    this.isSystem,
    this.isAdmin,
    this.userContext,
    this.db,
    this.serverVersion,
    this.serverVersionInfo,
    this.supportUrl,
    this.name,
    this.username,
    this.partnerDisplayName,
    this.companyId,
    this.partnerId,
    this.webBaseUrl,
    this.activeIdsLimit,
    this.profileSession,
    this.profileCollectors,
    this.profileParams,
    this.maxFileUploadSize,
    this.homeActionId,
    this.cacheHashes,
    this.currencies,
    this.bundleParams,
    this.userCompanies,
    this.showEffect,
    this.displaySwitchCompanyMenu,
    this.userId,
    this.notificationType,
    this.odoobotInitialized,
    this.session,
    this.profileImage,
    this.userType,
    this.del_activity_users,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        uid: json["uid"],
        isSystem: json["is_system"],
        isAdmin: json["is_admin"],
        userContext: json["user_context"] == null ? null : UserContext.fromJson(json["user_context"]),
        db: json["db"],
        serverVersion: json["server_version"],
        serverVersionInfo: json["server_version_info"] == null
            ? []
            : List<dynamic>.from(json["server_version_info"].map((x) => x)),
        supportUrl: json["support_url"],
        name: json["name"],
        username: json["username"],
        partnerDisplayName: json["partner_display_name"],
        companyId: json["company_id"],
        partnerId: json["partner_id"],
        webBaseUrl: json["web.base.url"],
        activeIdsLimit: json["active_ids_limit"],
        profileSession: json["profile_session"],
        profileCollectors: json["profile_collectors"],
        profileParams: json["profile_params"],
        maxFileUploadSize: json["max_file_upload_size"],
        homeActionId: json["home_action_id"],
        cacheHashes: json["cache_hashes"] == null ? null : CacheHashes.fromJson(json["cache_hashes"]),
        currencies: Map.from(json["currencies"]).map((k, v) => MapEntry<String, Currency>(k, Currency.fromJson(v))),
        bundleParams: json["bundle_params"] == null ? null : BundleParams.fromJson(json["bundle_params"]),
        userCompanies: json["user_companies"] == null ? null : UserCompanies.fromJson(json["user_companies"]),
        showEffect: json["show_effect"],
        displaySwitchCompanyMenu: json["display_switch_company_menu"],
        userId: json["user_id"] == null ? [] : List<int>.from(json["user_id"].map((x) => x)),
        notificationType: json["notification_type"],
        odoobotInitialized: json["odoobot_initialized"],
        session: json["session"] == null ? null : Session.fromJson(json["session"]),
        profileImage: json["profile_image"],
        userType: json["user_type"],
        del_activity_users: json["del_activity_users"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "is_system": isSystem,
        "is_admin": isAdmin,
        "user_context": userContext?.toJson(),
        "db": db,
        "server_version": serverVersion,
        "server_version_info": serverVersionInfo == null ? [] : List<dynamic>.from(serverVersionInfo!.map((x) => x)),
        "support_url": supportUrl,
        "name": name,
        "username": username,
        "partner_display_name": partnerDisplayName,
        "company_id": companyId,
        "partner_id": partnerId,
        "web.base.url": webBaseUrl,
        "active_ids_limit": activeIdsLimit,
        "profile_session": profileSession,
        "profile_collectors": profileCollectors,
        "profile_params": profileParams,
        "max_file_upload_size": maxFileUploadSize,
        "home_action_id": homeActionId,
        "cache_hashes": cacheHashes?.toJson(),
        "currencies": Map.from(currencies!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "bundle_params": bundleParams?.toJson(),
        "user_companies": userCompanies?.toJson(),
        "show_effect": showEffect,
        "display_switch_company_menu": displaySwitchCompanyMenu,
        "user_id": userId == null ? [] : List<dynamic>.from(userId!.map((x) => x)),
        "notification_type": notificationType,
        "odoobot_initialized": odoobotInitialized,
        "session": session?.toJson(),
        "profile_image": profileImage,
        "user_type": userType,
        "del_activity_users": del_activity_users,
      };
}

class BundleParams {
  String? lang;

  BundleParams({
    this.lang,
  });

  factory BundleParams.fromJson(Map<String, dynamic> json) => BundleParams(
        lang: json["lang"],
      );

  Map<String, dynamic> toJson() => {
        "lang": lang,
      };
}

class CacheHashes {
  String? translations;
  String? loadMenus;

  CacheHashes({
    this.translations,
    this.loadMenus,
  });

  factory CacheHashes.fromJson(Map<String, dynamic> json) => CacheHashes(
        translations: json["translations"],
        loadMenus: json["load_menus"],
      );

  Map<String, dynamic> toJson() => {
        "translations": translations,
        "load_menus": loadMenus,
      };
}

class Currency {
  String? symbol;
  String? position;
  List<int>? digits;

  Currency({
    this.symbol,
    this.position,
    this.digits,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        symbol: json["symbol"],
        position: json["position"],
        digits: json["digits"] == null ? [] : List<int>.from(json["digits"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "position": position,
        "digits": digits == null ? [] : List<dynamic>.from(digits!.map((x) => x)),
      };
}

class Session {
  String? sid;
  DateTime? expiresAt;

  Session({
    this.sid,
    this.expiresAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        sid: json["sid"],
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
      );

  Map<String, dynamic> toJson() => {
        "sid": sid,
        "expires_at": expiresAt?.toIso8601String(),
      };
}

class UserCompanies {
  int? currentCompany;
  AllowedCompanies? allowedCompanies;

  UserCompanies({
    this.currentCompany,
    this.allowedCompanies,
  });

  factory UserCompanies.fromJson(Map<String, dynamic> json) => UserCompanies(
        currentCompany: json["current_company"],
        allowedCompanies:
            json["allowed_companies"] == null ? null : AllowedCompanies.fromJson(json["allowed_companies"]),
      );

  Map<String, dynamic> toJson() => {
        "current_company": currentCompany,
        "allowed_companies": allowedCompanies?.toJson(),
      };
}

class AllowedCompanies {
  The1? the1;

  AllowedCompanies({
    this.the1,
  });

  factory AllowedCompanies.fromJson(Map<String, dynamic> json) => AllowedCompanies(
        the1: json["1"] == null ? null : The1.fromJson(json["1"]),
      );

  Map<String, dynamic> toJson() => {
        "1": the1?.toJson(),
      };
}

class The1 {
  int? id;
  String? name;
  int? sequence;

  The1({
    this.id,
    this.name,
    this.sequence,
  });

  factory The1.fromJson(Map<String, dynamic> json) => The1(
        id: json["id"],
        name: json["name"],
        sequence: json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sequence": sequence,
      };
}

class UserContext {
  String? lang;
  var tz;
  int? uid;

  UserContext({
    this.lang,
    this.tz,
    this.uid,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) => UserContext(
        lang: json["lang"],
        tz: json["tz"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "lang": lang,
        "tz": tz,
        "uid": uid,
      };
}
