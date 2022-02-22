import 'package:freedomchat/enum/user_state.dart';

class Utils {
  static String getUsername(String email) {

    return "live:${email.split('@')[0]}";

  }

 static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String secondNameInitial = nameSplit[1][0];
    return firstNameInitial + secondNameInitial;
 }

 static int stateToNum(UserState userState){
   switch (userState){
     case UserState.Offline:
     return 0;
   
     case UserState.Online:
     return  1;

     default:
     return 2;
    }
  }

  static UserState numToState(int number){
    switch(number){
      case 0:
      return UserState.Offline;

      case 1:
      return UserState.Online;
      
      default:
      return UserState.Waiting;
    }
  } 
}