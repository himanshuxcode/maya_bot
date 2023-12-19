import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya_bot/services/firebase_service.dart';
import 'package:maya_bot/views/screens/result_screen.dart';
import 'package:maya_bot/views/widgets/feature_widget.dart';
import 'package:maya_bot/views/widgets/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text_google_dialog/speech_to_text_google_dialog.dart';

import '../../providers/openai_service_provider.dart';

///Home or main Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///Defining controller for text field
  final TextEditingController _searchController = TextEditingController();
  String ques = "Hey chat How are you?";
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    // ModalRoute.of(context)?.addScopedWillPopCallback(() {
    //   // Reset your variables here
    //   _searchController.clear();
    //   setState(() {
    //     ques = "Hey chat How are you?";
    //     _isLoading = false;
    //   });
    //   return Future.value(true);
    // });
    ///Getting Device Size
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SideMenu(),
      backgroundColor: const Color.fromARGB(255, 153, 187, 197),
      appBar: _isLoading? null : AppBar(
        backgroundColor: const Color.fromARGB(255, 153, 187, 197),
      ),
      body: _isLoading? const Center(child: CircularProgressIndicator(
        color: Color.fromARGB(255, 2, 50, 62),
      ),): SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.06,
            ),

            ///Top Text
            const Text(
              "Maya",
              style: TextStyle(
                fontSize: 48,
                color: Color.fromARGB(255, 2, 50, 62),
                fontFamily: "Cera Pro",
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            ///Search Bar
            _buildSearchBar(size),

            /// Features
            _buildFeatures(),

            ///
          ],
        ),
      ),
    );
  }

  Future<void> listenQues() async {
    bool isServiceAvailable =
    await SpeechToTextGoogleDialog.getInstance().showGoogleDialog(
        onTextReceived: (data) {
          setState(() {
            ques = data;
          });
        });
    if (!isServiceAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Service is not available'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 16,
          right: 16,
        ),
      ));
      return; // Exit early if the service is not available.
    }
  }

  ///Search Bar
  Widget _buildSearchBar(Size size) {
    final openAiService =
        Provider.of<OpenAiServiceProvider>(context).openAiService;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///Text Field
        Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
          width: size.width * 0.80,
          height: size.height * 0.065,
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            controller: _searchController,
            style: const TextStyle(
              color: Colors.black,
            ),
            onChanged: (value) {
              setState(() {
                setState(() {
                  ques = value;
                });
              });
            },
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              hintText: "Ask anything.",
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: "Cera Pro",
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
            ),
          ),
        ),

        ///Button
        GestureDetector(
          onTap: () async {



            try {
              // if (ques == "Hey chat How are you?" || ques.isEmpty) {
              //   await listenQues();
              //   setState(() {
              //     _isLoading = true;
              //   });
              //
              //   final ans = await openAiService.isArtPromptApi(ques.toString());
              //
              //   // Navigate to the ResultScreen with the question and answer
              //   Navigator.of(context).pushReplacement(MaterialPageRoute(
              //     builder: (context) => ResultScreen(
              //       question: ques.toString(),
              //       answer: ans.toString(),
              //     ),
              //   ));
              // } else {
              //
              // }

              setState(() {
                _isLoading = true;
              });

              final ans = await openAiService.isArtPromptApi(ques.toString());

              User? user = await  FirebaseService.getCurrentUser();
              String userId = user?.uid ?? "" ;
              await FirebaseService.addQuestionAndAnswer(userId, ques, ans);
              // Navigate to the ResultScreen with the question and answer
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ResultScreen(
                  question: ques.toString(),
                  answer: ans.toString(),
                ),
              ));

            } catch (e) {
              // Handle errors if any
              print('Error: $e');
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 10, 82, 94),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            width: size.width * 0.12,
            height: size.height * 0.065,
            alignment: Alignment.center,
            child:
            // _searchController.text.isNotEmpty
            //     ?
            const Icon(
                    Icons.send,
                    color: Colors.white70,
                  )
                // : const Icon(
                //     Icons.mic,
                //     color: Colors.white70,
                //   ),
          ),
        ),

        ///
      ],
    );
  }

  /// Features
  Widget _buildFeatures() {
    return const Column(
      children: [
        //ChatGpt
        FeatureWidget(
          title: "ChatGpt",
          description:
              "A smarter way to stay organized and informed with chatGpt.",
          colour: Colors.white70,
        ),
        //Dall-E
        FeatureWidget(
          title: "Dall-E",
          description:
              "Get inspired and stay creative with your personal assistant Dall-E.",
          colour: Colors.white70,
        ),
        //Smart voice assistant
        // FeatureWidget(
        //   title: "Smart voice assistant",
        //   description:
        //       "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGpt.",
        //   colour: Colors.white70,
        // ),
        //
      ],
    );
  }
}
