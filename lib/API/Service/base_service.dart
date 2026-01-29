class ApiRouts {
  static String databaseName = 'sp_db';
  static String base = 'http://64.227.154.179:8075/';
  static String baseUrl = '${base}session/auth';

  /// APIS
  static String loginAPI = '$baseUrl/login';
  static String registerAPI = '$baseUrl/signup';
  static String logOutAPI = '$baseUrl/logout';
  static String oneSignal = '$baseUrl/one/signal';
  static String spList = '$baseUrl/get/sp/list';
  static String getPoliceStations = '$baseUrl/get/police_stations';
  static String notification = '$baseUrl/notifications';
  static String getTimeSlot ='$baseUrl/get/time_slots';
  //static String sendOtpAPI = '$baseUrl/send_otp'; 
  static String createVisitorAPI = '$baseUrl/create/visitor';
  static String getVisitorRecords = '$baseUrl/get/visitor_records';
  static String getVisitorForm = '$baseUrl/visitor/form';
  static String getOfficersByStation = '$baseUrl/api/officers';
  static String spForm = '$baseUrl/sp/form';
  static String piForm = '$baseUrl/pi/form';
  static String closeForm = '$baseUrl/close/form';
  static String statusCount = '$baseUrl/get/status_counts';
  static String closeFormList = '$baseUrl/get/close/records';
  static String reopenForm = '$baseUrl/reopen/form';
  static String getAllOfficers = '$baseUrl/api/officers';
  /// NEW PI OFFICER API
  static String piStatusCount = '$baseUrl/api/pi/status_counts';

  static String getVisitorByWhatsapp = '$baseUrl/get/visitor/by_whatsapp';
  static String visitorForm = '$baseUrl/visitor/form';

  static String downloadVisitorReport = '$baseUrl/visitor/report/download';

  static const String visitFormList = '/visitFormList';
  
}


