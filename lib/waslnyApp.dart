import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:wassalny/splash.dart';
import 'Components/CustomWidgets/myColors.dart';
import 'Components/Language/getLanguage.dart';
import 'Screens/register/county/list.dart';
import 'model/aboutandcontact.dart';
import 'model/branches.dart';
import 'model/categoriseDetails.dart';
import 'model/home.dart';
import 'model/homeSearch.dart';
import 'model/itemServicesDetail.dart';
import 'model/min_sirv.dart';
import 'model/notifications.dart';
import 'model/offerDetails.dart';
import 'model/offers.dart';
import 'model/searchByCity.dart';
import 'model/tickets.dart';
import 'model/ticketsDetailsModel.dart';
import 'model/ticketsList.dart' as x;
import 'model/searchStates.dart' as y;
import 'model/notifDetails.dart';
import 'model/searchLAndLat.dart';
import 'model/sirv_offers.dart';
import 'network/auth/auth.dart';

class WaslnyApp extends StatefulWidget {
  WaslnyApp({Key key}) : super(key: key);

  @override
  _WaslnyAppState createState() => _WaslnyAppState();
}

class _WaslnyAppState extends State<WaslnyApp> with WidgetsBindingObserver {
  final savedLang = GetStorage();
  final saveToken = GetStorage();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // CustomNotification _notification = CustomNotification();

  @override
  void initState() {
    super.initState();
    // _notification.notificationConfig();
    // _notificationConfig();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging().getToken().then((value) {
    //   saveToken.write('fire', value);
    // });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => CityDropDownProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, AllOffersProvider>(
          create: null,
          update: (context, auth, alOffersProvider) => AllOffersProvider(
            id: auth.id,
            lang: auth.lang,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HomeLists>(
          create: null,
          update: (context, auth, homelist) => HomeLists(
            id: auth.id,
            lang: auth.lang,
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, AboutAndContactUS>(
          create: null,
          update: (context, auth, aboutAndContactUS) => AboutAndContactUS(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ContactUsModel>(
          create: null,
          update: (context, auth, contactUs) => ContactUsModel(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, TicketsTypeProvider>(
          create: null,
          update: (context, auth, contactUs) => TicketsTypeProvider(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OfferDetailsProvider>(
          create: null,
          update: (context, auth, offerDetailsProvider) => OfferDetailsProvider(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, DetailsOfServicesProvider>(
          create: null,
          update: (context, auth, offerDetailsProvider) =>
              DetailsOfServicesProvider(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ItemServicesDetail>(
          create: null,
          update: (context, auth, offerDetailsProvider) => ItemServicesDetail(
            auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, x.TicketsLisstProvider>(
          create: null,
          update: (context, auth, offerDetailsProvider) =>
              x.TicketsLisstProvider(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, NotificationsProvider>(
          create: null,
          update: (context, auth, offerDetailsProvider) =>
              NotificationsProvider(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, BranchesProvider>(
          create: null,
          update: (context, auth, branchesProvider) => BranchesProvider(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, SearchName>(
          create: null,
          update: (context, auth, searchName) => SearchName(
            token: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, TicketsDetailsProvider>(
          create: null,
          update: (context, auth, ticketsDetailsProvider) =>
              TicketsDetailsProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, SearchCity>(
          create: null,
          update: (context, auth, searchCity) => SearchCity(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, y.SearchStatesProvider>(
          create: null,
          update: (context, auth, searchCity) =>
              y.SearchStatesProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, NotificationDetailsProvider>(
          create: null,
          update: (context, auth, searchCity) =>
              NotificationDetailsProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, SearchLatAndLagProvider>(
          create: null,
          update: (context, auth, searchCity) =>
              SearchLatAndLagProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, AllMinProvider>(
          create: null,
          update: (context, auth, searchCity) =>
              AllMinProvider(token: auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, SirvOfferProvider>(
          create: null,
          update: (context, auth, searchCity) =>
              SirvOfferProvider(token: auth.token),
        ),
      ],
      child: GetMaterialApp(
        translations: Messages(), // your translations
        locale: Locale(savedLang.read('lang') == null
            ? 'ar'
            : savedLang
                .read('lang')), // translations will be displayed in that locale
        fallbackLocale: Locale(
            savedLang.read('lang') == null ? 'ar' : savedLang.read('lang')),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('ar'), Locale('en'), Locale('tr')],
        theme: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle:
                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
          brightness: Brightness.light,
          primaryColor: MyColors.primary,
          accentColor: MyColors.primary,
          fontFamily: "GE-Snd-Book",
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          canvasColor: Color.fromRGBO(250, 250, 250, 1),
          textTheme: TextTheme(
            headline1: TextStyle(fontFamily: 'GE-Snd-Book'),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }

  // Future _notificationConfig() async {
  //   _firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {
  //     print('message: ' + message.toString());
  //     _notification.showNotification(
  //         message['notification']['title'], message['notification']['body']);
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('OnLaunch: $message');
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('OnResume: $message');
  //   });
  //   await _firebaseMessaging.requestNotificationPermissions(
  //     IosNotificationSettings(
  //         sound: true, badge: true, alert: true, provisional: false),
  //   );
  // }
}