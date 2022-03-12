import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freedomchat/provider/image_upload_provider.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/home_screen.dart';
import 'package:freedomchat/screens/login_screen.dart';
import 'package:freedomchat/screens/search_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageUploadProvider>(
      create: (context)=> ImageUploadProvider(),
      child: MaterialApp(
        title: "Freedom App",
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.purple[800],
          primarySwatch: Colors.purple,
          backgroundColor: Colors.purple.shade50,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/search_screen": (context) => SearchScreen(),
        },
        onGenerateRoute: (settings){
          switch (settings.name){
            case '/second':
              return PageTransition(child: HomeScreen(), type: PageTransitionType.fade);
            case '/third':
              return PageTransition(child: SearchScreen(), type: PageTransitionType.fade);
            default:
            return null;
          }
          
        },
        home: FutureBuilder(
          future: _repository.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
