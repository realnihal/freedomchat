import 'package:flutter/material.dart';
import 'package:freedomchat/resources/firebase_repository.dart';
import 'package:freedomchat/screens/pageviews/widgets/quiet_box.dart';
import 'package:freedomchat/utils/utilities.dart';
import 'package:freedomchat/widgets/appbar.dart';
import 'package:freedomchat/widgets/user_circle.dart';

class Contact_List_Screen extends StatefulWidget {
  const Contact_List_Screen({ Key? key }) : super(key: key);

  @override
  _Call_List_ScreenState createState() => _Call_List_ScreenState();
}

class _Call_List_ScreenState extends State<Contact_List_Screen> {


  final FirebaseRepository _repository = FirebaseRepository();

  late String currentUserId;
  late String initials;
  bool loadState = true;

  void loadData(){
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName!);
        loadState = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: Colors.purple[50],
      body: Center(child: QuietBox(heading: "Coming Soon",subtitle: "Development work in progress!, meanwhile chat with freedom!",),),
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications_outlined,
          color: Colors.purple[50],
        ),
        onPressed: () {},
      ),
      centerTitle: true,
      title: loadState ? Center(child:CircularProgressIndicator(color: Colors.purple,)) 
      : UserCircle(initials),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.purple[50],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/third');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.purple[50],
          ),
          onPressed: () {},
        )
      ],
    );
  }
}