import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Components/utils.dart';
import 'Login/verifyemail.dart';
import 'Messages/messageBackend.dart';
import 'Startup Screens/1.dart';
import 'firebase_options.dart';



final navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //After initialization, building material app
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  final messageDB msgdb = messageDB();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is paused (minimized or put into the background)
      setStatusState("Online");
    } else if (state == AppLifecycleState.resumed) {
      // App is resumed (brought back to the foreground)
      setStatusState("Online");
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
      setStatusState("Online");
    }
  }

  @override
  void initState() {
    super.initState();
    setStatusState("Online");
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer from the widget's lifecycle
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void setStatusState(state) async{
    await msgdb.updateState('gF4LOJIn1oXAsNRTVpXsivSmf9j1', state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      home: const SecurityTree(),

    );
  }
}

class SecurityTree extends StatefulWidget {
  const SecurityTree({super.key});

  @override
  State<SecurityTree> createState() => _SecurityTreeState();
}

class _SecurityTreeState extends State<SecurityTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (ConnectionState == snapshot.connectionState) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something Went Wrong!!"),
              );
            } else if (snapshot.hasData && FirebaseAuth.instance.currentUser!.isAnonymous == false) {
              return const VerifyEmailPage();
            } else {
              return const InitialSetup();
            }
          }),
    );
  }
}

