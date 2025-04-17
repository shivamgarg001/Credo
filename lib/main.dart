// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import './app_imports.dart';
// import './pages/ledger/customer_tab.dart';
// import './pages/ledger/supplier_tab.dart';
// import './state/global_variables.dart';
//  import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling background message: ${message.messageId}");
// }
// void main() async{
//     WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.dark,
//   ));
//   runApp(ChangeNotifierProvider(
//       create: (context) => AppState(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     precacheImage(const AssetImage("assets/images/share.png"), context);
//     precacheImage(const AssetImage("assets/images/update_number.png"), context);

//     return ChangeNotifierProvider(
//       create: (context) => DataModel(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: kCustomThemeData,
//         initialRoute: BottomNavbar.id,
//         routes: {
//           BottomNavbar.id: (context) => const BottomNavbar(),
//           AddContactPage.id: (context) {
//           final clientId = Provider.of<AppState>(context).clientId;
//           return AddContactPage(clientid: clientId ?? ''); 
//           },
//           SecurityPage.id: (context) => const SecurityPage(),
//           ProfilePage.id: (context) => const ProfilePage(),
//           BusinessTypePage.id: (context) => const BusinessTypePage(),
//           BusinessCategoryPage.id: (context) => const BusinessCategoryPage(),
//           AccountPage.id: (context) => const AccountPage(),
//           SubscriptionPage.id: (context) => const SubscriptionPage(),
//           LanguagePage.id: (context) => const LanguagePage(),
//           UpdateNumberPage.id: (context) => const UpdateNumberPage(),
//           BackupPage.id: (context) => const BackupPage(),
//           HelpPage.id: (context) => const HelpPage(),
//           SharePage.id: (context) => const SharePage(),
//           FindDefaulterPage.id: (context) => const FindDefaulterPage(),
//           '/customer_credit': (context) => CustomerTab(type: 'customer_credit'),
//           '/customer_notif': (context) => CustomerTab(type: 'customer_notif'),
//           '/supplier_credit': (context) => SupplierTab(type: 'supplier_credit'),
//           '/supplier_notif': (context) => SupplierTab(type: 'supplier_notif'),

//         },
//       ),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:credo/firebase_options.dart';
import 'package:credo/opening_screen.dart';
import './generated/l10n.dart';

import './app_imports.dart';
import './state/global_variables.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(message.notification?.title.toString());
  print(message.notification?.body.toString());
}

void main() async {

  // await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  // Ensure status bar styling
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initialize and load AppState
  AppState appState = AppState();
  await appState.loadFromPrefs();  // Load saved state before running the app
  // Uncomment this line ONLY WHEN YOU WANT TO CLEAR ALL DATA
  // await appState.clearSharedPreferences();

  // Initialize and load DataModel
  final dataModel = DataModel();
  await dataModel.loadLocaleFromSharedPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appState),
        ChangeNotifierProvider(create: (context) => dataModel),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  

  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {

    precacheImage(const AssetImage("assets/images/share.png"), context);
    precacheImage(const AssetImage("assets/images/update_number.png"), context);

    print(Provider.of<DataModel>(context).currentLocale);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: kCustomThemeData,
      theme: kCustomThemeData,
      locale: Provider.of<DataModel>(context).currentLocale,
      supportedLocales: [
        Locale('en', 'US'), // English
        Locale('kn', 'IN'), // Kannada
        Locale('hi', 'IN'), // Hindi
        Locale('mr', 'IN'), // Marathi
        Locale('gu', 'IN'), // Gujarati
        Locale('ta', 'IN'), // Tamil
        Locale('te', 'IN'), // Telugu
        Locale('as', 'IN'), // Assamese
        Locale('pa', 'IN'), // Panjabi
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,  // For material widgets like buttons, text fields, etc.
        GlobalWidgetsLocalizations.delegate,   // For widgets like text, input, etc.
        GlobalCupertinoLocalizations.delegate, // For Cupertino widgets (iOS-style widgets)
        S.delegate,
      ],
      // initialRoute: BottomNavbar.id,
      home: SplashScreen(),
      routes: {
        BottomNavbar.id: (context) => const BottomNavbar(),
        AddContactPage.id: (context) {
          final appState = Provider.of<AppState>(context, listen: false);
          final clientId = appState.clientId ?? '';
          return AddContactPage(clientid: clientId ?? '');
        },
        SecurityPage.id: (context) => const SecurityPage(),
        ProfilePage.id: (context) => const ProfilePage(),
        BusinessTypePage.id: (context) => const BusinessTypePage(),
        BusinessCategoryPage.id: (context) => const BusinessCategoryPage(),
        AccountPage.id: (context) => const AccountPage(),
        SubscriptionPage.id: (context) => const SubscriptionPage(),
        LanguagePage.id: (context) => const LanguagePage(),
        UpdateNumberPage.id: (context) => const UpdateNumberPage(),
        BackupPage.id: (context) => const BackupPage(),
        HelpPage.id: (context) => const HelpPage(),
        SharePage.id: (context) => const SharePage(),
        FindDefaulterPage.id: (context) => const FindDefaulterPage(),
        // // '/customer_credit': (context) => CustomerTab(type: 'customer_credit'),
        // // '/customer_notif': (context) => CustomerTab(type: 'customer_notif'),
        // // '/supplier_credit': (context) => SupplierTab(type: 'supplier_credit'),
        // // '/supplier_notif': (context) => SupplierTab(type: 'supplier_notif'),
      },
    );

    
  }

}
