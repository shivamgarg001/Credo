// import 'package:googleapis_auth/auth_io.dart';

// class GetServerKey {
//   Future<String> getServerKeyToken() async {
//     // final stopwatch = Stopwatch()..start();

//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];

//     final client = await clientViaServiceAccount(
//       ServiceAccountCredentials.fromJson(
//           {
//             "type": "service_account",
//             "project_id": "pushnotifications-00001",
//             "private_key_id": "880377b8b01126d078a552d628c04ab94e03b16d",
//             "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDlYTXIzBeiebxP\n8ndp4WQAbWoet4EpT+6o262V9E2G/5BoSoOiUYJA4X9IM3oGai5ascRMQ2lprEvR\nTPzwGey1gCz5hNnh2DAqcC+VWC87edrR+L+Gg2NpUB6EuzeogVoKKjJaYM3eNI11\ncbD3aeWfcKb7z0cOlsBa3p0PSrJBYcoSZFdOIWdib8ZlZMsptdSTSbWRT+ikkQYk\n0o4t5a3q4RtVbkTF40IjhPMqJ860QNOF2W3WnlfPJ02hv/HiiPRKIvy7DwENMIvC\n4Cvhs9aZNlc79DJDQBMLASlQA7fCxzvsGpHT+/Rt4bcACJXGBc4VItnj19g3ZYcQ\nr+fJRaI1AgMBAAECggEAHybbG5igMxguW3s1/YK3RpmVenN4jqhE5Njk08M4jjeC\nIK/R/cbtFiup0h/vmBRulDGlU6gqFkhoiZXXmjIjJCkysnZ48sOeEv1mcPVngL/V\nWIPcWwPYCfLwGh2k+vUKSeweJ4kTHHTtq0AUBR30KfmuK++kGlad7BlkojGGUPuZ\nl6QO07UXXolL4JoMdMAVgHbdnod4ty5fCPFjL9AW3I+fluMablz8/ovTzlVwjoDw\nSI92gG/REm5udX1kOfczulQrp3oFCRCyU8AQMTEao/p9wB4qxToDLHM0TfvzbkDo\nPk4/PVi2+fAUYVGOKUc7pyfg15biB2u/uB1NGEfG9wKBgQD0luFYky1dCbGhfeYU\nokqBJdcmieMvoi09HlCQ86yg8atZUWC8zgeV6jf/Rj97ZETPSvfNAkNkaavEo9J3\nSQqMgr9A9EauLuQTudbuYSxW73kZU5ItzygmmE+gP7xwuDnbS9niaMxjLXF0dieI\noUqi98Aih+vm32x+Nzw7bg7mVwKBgQDwFK6DdhWA2BzGaILPW1NF83Dqtlc+l5BJ\n9Va9uoYsD7PgdedEl9n3KdExNQZe9n2C1515UBUDwU53sY2mkStKcLeIiDDCfi6w\nQMQ2SiyV4TB8fd0UplkAYae/tO+csJo4Ty+gt+kw2Zx5Fuc1A1OcfC+Il6BAQk6D\nMcB937YsUwKBgDq+MgkP8Ak0VtEuZ5/1CmfSKsY6v7GlBbB0I21s2L0ezcR54v31\njaTXx/Mrb/u2rUAMBU/bh0wKhRKJNfcoN7xfeoejI4aaBHUoYRKHjBqlETSf+a++\n3SnH0vft1thLprmgkgfqm4wGUgVii0QpWL+jOSYR9vpQFsKJiZHMcQ+pAoGBAOhm\nHMiE9ivTB4fIg1fWP7XnAdcyyyF79eCh7WWbuWXNjYIqn8R2ejgX8rh/a7thP/34\nWiekrbME3MBgz4392LomgoNX0ltzah6Tk1w6UQ6E/jqEXA4xONZ1sbyRmaFEEwWP\nIbuiS8lN3XoaAZX/smA4lorSu/14MigtcPhoJiChAoGBAN53NLEYxa9mxijUdkyi\nCb1D+5FdOywMOx9AUMZQXZ4PTIwvljhtx3r2WihNkhm5EynzU39asy7wLSzUr8CR\nmA0Dg3pG3Jyq+ls0EscdK0ez1isA92BGM4jnFwraiuwcBiDNYcCntiegmBkEnUH8\nZiOGYM26s5lDLCRz75fdP2Ne\n-----END PRIVATE KEY-----\n",
//             "client_email": "firebase-adminsdk-fbsvc@pushnotifications-00001.iam.gserviceaccount.com",
//             "client_id": "111495803143457885323",
//             "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//             "token_uri": "https://oauth2.googleapis.com/token",
//             "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//             "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40pushnotifications-00001.iam.gserviceaccount.com",
//             "universe_domain": "googleapis.com"
//           }
//       ),
//       scopes,
//     );
//     final accessServerKey = client.credentials.accessToken.data;
//     // stopwatch.stop();
//     // print("getServerKeyToken took: ${stopwatch.elapsedMilliseconds}ms");
//     return accessServerKey;
//   }
// }
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    await dotenv.load();

    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final serviceAccountJson = {
      "type": "service_account",
      "project_id": dotenv.env['FIREBASE_PROJECT_ID'],
      "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID'],
      "private_key": dotenv.env['FIREBASE_PRIVATE_KEY']?.replaceAll(r'\n', '\n'),
      "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL'],
      "client_id": dotenv.env['FIREBASE_CLIENT_ID'],
      "auth_uri": dotenv.env['FIREBASE_AUTH_URI'],
      "token_uri": dotenv.env['FIREBASE_TOKEN_URI'],
      "auth_provider_x509_cert_url": dotenv.env['FIREBASE_AUTH_PROVIDER_X509_CERT_URL'],
      "client_x509_cert_url": dotenv.env['FIREBASE_CLIENT_X509_CERT_URL'],
      "universe_domain": dotenv.env['FIREBASE_UNIVERSE_DOMAIN'],
    };

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    return client.credentials.accessToken.data;
  }
}
