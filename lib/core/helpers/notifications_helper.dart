import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "servicesapp2024",
      "private_key_id": "2ed626190f0dd2465c6be664c84a3653d55801f2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC08phu5u7neEa7\nWI8Vs4Kl3JoqtCJwO2Ub8jykkJOG9W4CFNSiNcEm1oXI+8akETgr2eL2gPXEq80I\nF+AN0SUMwD0edNtOH1ZSxFh+vXhHwPkRXDJ+jhUPACR8BofbH14uTntQdWdFPiFE\nOULtrvEKCzCn5UhJFPnHrDvMad1UvEa80AIM7kt/3H/Gq3MCjCErkh4n9van7PJ8\nzb7w9WbvYf99TpgKaHBgV/3sXuB7uiCsvAwuTFRs33bvM4hreHHgRWNvmd47Rs7E\niCUskXxIjhHSCLaC5khj67b5UGkzoRqj1cMaOJIGfq+CqEHXBPiw6sCTCpRBHwN1\n54IKG2NXAgMBAAECggEADJkzec1EZwNd0V96HuWvvAKfDUgbebr48DgudrrGOshN\nz4FJyL17ZEvdZr/49aVpRsxV3Bnggr//d4fKBsxACyI7Xyp9tnPCG+Ml0jU48a4C\n6W2E6oDUAIZfA++kd+I4OXsnZNO3y/9ma4ydF1Vt3OgojBgPr17xgTCBvVrFmUeg\nSNOvhf4+vkuyqm5n56/wyR/cSCzkwUtmSZdXYK3A0CKxcrzk4kvjEbvVTFOcH+NG\nzQ0Po53KZWozxFiLDokHvS02HuID8fLq5BDIAxNMy/COtwSFIowXyfHYQdaeWgQ/\nCzkw8GQy11A0vn8DsQENq/My5EAdQnU9nNexveb64QKBgQD6XLNUuvhT2gJNRO2N\nB7JXefn089dsEIfLU2ixMequEh52mvJZbCi7f2kqnFoiHvi8PGiXri24BmlMcBlN\nwo6SrlDr9o3nT6X7qnJBQd6hiyWz/aLvbT8gucEr4+xlhOBwjzSbpa1M3vVHLfia\nrrEukmrNz7yJlbyTFrq1lYju8QKBgQC5BbsmTBU7VZmDHsV0Fa1FdEsNUXSZHJN2\nNkNktJlr8+a09RRltilpuKf3Cp+tDfa1Q/S2uHq7afZohCJlzIjMKhpummuvyIPi\nXOxQNFhPiKaMa1vWu9GM34qGY35fUeyIrDUztY9oo6KJ5boiP1gSUva6aOwAFwTa\nvT5FKBAGxwKBgQCFrdOvLToFA8Xw3hn9EJwAK0f0q/JdaCIpxbqDyoRlN5V+fNNk\nPeUt4CUWNG/IAkOLtrGeM8mDliDJSJ2qMHUSCvN4WqiAVr3ot6TUBUjLdtHF3msO\nboWjgquLNOL3fdCdKUnMxdTX08ChpgE1DovasyFGDWK9D++lliBRbquz8QKBgBiy\ndyTJixv8dR1XgivYqORYfZwtf07gzZ496AkNQl1ylR0aibp58lU2XNVRCbdj4caY\nZ5XsUhWqM0YIPT8xaiE2jYit/CnerhwNI04hbphPOUwNGJk1QOd4/1io9zlqChTE\nR+W7GoVxMkUN8SaZJfxsLpr7XmU0rWU1VZaNnnYJAoGBAL8HC+uUP9QZWRVhZpeL\nCjtv2N9tyPd1CgsTJAhmRVjeVmRARbB8MJ301k21Mn0QHbENeSVODMNYMS1g1p+H\nP8pO20AnmRspXK830GSuvX5eYSqG5TO/hNALnBUUFf4QFYiWtEw1Bzwbr0mFF5zE\nsZFwjk1lqj4LpBIbhfxXwPD0\n-----END PRIVATE KEY-----\n",
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
        'Authorization': 'Bearer $accessToken',
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
