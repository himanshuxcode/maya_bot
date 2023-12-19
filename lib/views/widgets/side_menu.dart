import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_service.dart';
import '../screens/result_screen.dart';
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
    setUserId();
  }

  String? userId;

  Future<void> setUserId() async {
    await FirebaseService.initializeApp();
    User? user = await FirebaseService.getCurrentUser();
    setState(() {
      userId = user?.uid;
    });
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection("questions")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: ListTile(
                        tileColor: Colors.white54,
                        title: Text(
                          document["question"],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              question:  document["question"],
                              answer:  document["answer"],
                            ),
                          ));
                        },
                      ),

                    );
                  }).toList(),
                );
              },
            ),
            // child: StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseService.getQuestionList(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           color: Colors.white,
            //         ),
            //       );
            //     }
            //     List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            //
            //     return Column(
            //       children: documents.map((doc) {
            //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            //         print(data);
            //         return ListTile(
            //           title: Text(data['ques']),
            //         );
            //       }).toList(),
            //     );
            //   },
            // ),
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
