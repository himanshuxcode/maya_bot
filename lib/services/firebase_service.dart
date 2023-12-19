import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static late FirebaseAuth _auth;
  static late FirebaseFirestore _firestore;

  static Future<void> initializeApp() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  static Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  static Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

  static Future<bool> checkUser() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  // Add Question and Answer
  static Future<void> addQuestionAndAnswer(
      String userId, String question, String answer) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection("questions")
          .add({"question": question, "answer": answer});
    } catch (e) {
      print('Error adding question and answer: $e');
      // Handle the error as needed
    }
  }

// Retrieve Question List
  static Stream<QuerySnapshot<Object?>> getQuestionList() {
    try {
      User? user =  getCurrentUser();
      String userId = user?.uid ?? "" ;
      CollectionReference questionsCollection =
          _firestore.collection('users').doc(userId).collection('questions');

      print(questionsCollection.snapshots().length);
      return questionsCollection.snapshots();
    } catch (e) {
      print('Error getting question list: $e');
      // Handle the error as needed
      return const Stream.empty();
    }
  }

// Retrieve Question and Answer
  static Future<Map<String, dynamic>> getQuestionAndAnswer(
      String userId, String questionId) async {
    try {
      DocumentSnapshot questionDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('questions')
          .doc(questionId)
          .get();

      if (questionDoc.exists) {
        return questionDoc.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map or handle the case where the document doesn't exist.
      }
    } catch (e) {
      print('Error getting question and answer: $e');
      // Handle the error as needed
      return {};
    }
  }

  static User? getCurrentUser()  {
    return _auth.currentUser;
  }

//
}
