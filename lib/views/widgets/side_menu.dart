import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_service.dart';
import '../screens/splash_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 2, 50, 62),
      child: Column(
        children: [
          ///Email
          ///History
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.getQuestionList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                print(snapshot.data);
                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                return Column(
                  children: documents.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['question']),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          ///Logout
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
            leading: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
