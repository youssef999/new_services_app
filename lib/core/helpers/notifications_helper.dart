import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "servicesapp2024",
      "private_key_id": "fd912db948de127df96d229d67933fe5649b0c74",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPHHBRrdK0OXrP\nptTyl2upRB4l6wXmxLmnqn9scoHG2uXuGmyDxeWk45pQDC9yKKlTOkYfIG6u8alI\n0DI+KmHD7VwfVZde2eASABvwQv6X7d8GsFtdxNa7xoPOJgi4op8fvdWRJtMfZaGA\nv0iG1O5S85pP9Ez6gPQt7idGG0NeRj0RcURfqhe0bZLlKqKvTdbrOnI6tCenLVYm\nDyRr3IQd4yisbj0cRZc+4uC8/c13udTjrFAo+iqpO3ytZCav1l8T61/vh3QX/NHv\nwizoQDDzh1jZRtsvLr9lsJ30e6o+Jg5jU/tQSHuT9UowJ2kQVTYqyKBrSHaDn9EP\nVkzM1fR3AgMBAAECggEAT5Asw+wDVFH6kHgWOWWbKejtrgJl/3uWmMcicW5h1Zs1\nFm3XPx4QtPHsz5CGz5O4TK1Hz+BdNN7IehzlGEWezi5KpAz0/C616iRZl0idVo8+\njOrGBrU+Ct/dtZ2d3xQ2DfMW7s6b72VTEEsrmQSG054aq1l+EwPkChsBwmhpznZ6\n5zmuk1vh1gLWHxWVZ+hm1FEyeJm7dgU1AU20j5cZMvBjA05WhQoH9XKQeox9t7cj\nMnpI5uBAHokfr62iKfbX/1b1MiPOS5Ai9I+JVrSl2xZu3MfJ3ch+AKM+pkv1yN4c\nUW1B8yiqoFeQ2APlYqRd7ViWy++vRXJjtYtW8aZyoQKBgQD1zJQfd3K1RxP3JLqn\ncY9hg9RcI0Nl+fcc9/ma5z6ohX0xke1lU00MQjnhInedF7/2gBQYB+mdMDN5VKEd\nhesvcprFwMK9NojnP8GJ9Pu/io+8PS09PIOQoX3A3dP61RPxnb7T3eDnQk1aDO8J\nNCwoICU2DaRBugi3iRxRvzOdVwKBgQDXtNSLPAc8a2F3kvKl63hHwGFqiRlCKibq\nNBIxdqDuRNMsHl5lED1GZHT/vBHFOF4ELZN/UfzKbvJxrIEGflxMMiQi5f1KfSYv\nh4Xd1kXYeP6WcMl61M5bUS2uFJb6Xf5ZPJiALPHB5I8uf5dFMtTm6s0vX+i84zzn\n9HhBihbN4QKBgDJpN8PQWq1FG5onZUSsLKziPa576PnEL2M4lG+pl5c2cXu2IwsR\n745hEr/Sstd8JHmowPZAwS/kz9nFepm0eoyro4SFSStHQQK0d7wUi4E4KMyBe4LA\no3cJN+JTXINoKgP2x0lqixLC7VxXpLqtgZTlKtyQJaz5O4pwy2cUoMBXAoGAPR02\nutwfELc7vi0cInY8ddfDwfNl/KEEtYZbQThjEB7f1bgk9m1Lbw43N92JC1+VA4oG\nKCSKgrA8cIh3ZeeXLt9l7Z1Lzjb3ArBa9ScoUtS1DNqXuv1gGe8+Cfw7amQHFDFe\n47HYLR8ckggES87DE0mjKLD7t8iKEQ3qpGcDXwECgYEAhx54+hR6mi7dN1Cy6Xc6\nmVYcDY/CmQJS4Vl13Ndn8YPFWnI02iL26gU37+NZIQDUTw6gMjIVYrwBCnbzdTpR\n+lK6F/q9kUFAjezPDhQu+oM3YsjGzh7XncldYnYrVgw5tv3h307gla4OAkHF680x\nON0uy/u01LELytzDECCdLXM=\n-----END PRIVATE KEY-----\n",
      "client_email": "serviceappfcm@servicesapp2024.iam.gserviceaccount.com",
      "client_id": "115763657468661021643",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/serviceappfcm%40servicesapp2024.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/servicesapp2024/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }
}
