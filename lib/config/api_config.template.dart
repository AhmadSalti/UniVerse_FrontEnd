class ApiConfig {
  static const String BASE_URL = 'YOUR_API_URL';
  static const String BOT_URL = 'YOUR_BOT_URL';

  static const String LOGIN_ENDPOINT = '$BASE_URL/users/login';
  static const String BOT_ENDPOINT = '$BOT_URL/webhooks/rest/webhook/';

  static const String STUDENT_INFO_ENDPOINT =
      '$BASE_URL/students/getStudentById';
}
