import 'package:flutter/material.dart';
import 'package:maya_bot/views/screens/home_screen.dart';
import 'package:maya_bot/views/screens/signup_screen.dart';

import '../../services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ///variables to storing device physique
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _size.height * 0.1,
                    ),

                    ///Welcome text
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 50, 62),
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: _size.height * 0.002,
                    ),

                    ///Welcome description text
                    const Text(
                      "We are glad to see you again..!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: _size.height * 0.05,
                    ),

                    ///Form for getting login information
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Email
                          TextFormField(
                            maxLength: 25,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                return "Invalid Email";
                              }
                              return null;
                            },
                            controller: _email,
                            decoration: const InputDecoration(
                              counterText: "",
                              hintText: "Enter Email",
                              labelText: "Email",
                            ),
                          ),
                          SizedBox(
                            height: _size.height * 0.015,
                          ),

                          /// Password
                          TextFormField(
                            maxLength: 15,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value!.isEmpty || value.length <= 5) {
                                return "Invalid Password";
                              }
                              return null;
                            },
                            controller: _password,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _obscureText
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(
                                    () {
                                      _obscureText = !_obscureText;
                                    },
                                  );
                                },
                              ),
                              counterText: "",
                              hintText: "Enter Password",
                              labelText: "Password",
                            ),
                          ),

                          SizedBox(
                            height: _size.height * 0.01,
                          ),

                          ///Forget password button
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     TextButton(
                          //       onPressed: () {
                          //         Navigator.pushNamed(
                          //             context, '/forgetPasswordPage');
                          //       },
                          //       child: Text(
                          //         'Forget Password ?',
                          //         style: TextStyle(
                          //           color: Colors.blue,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          ///Login Button
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                // form is valid, proceed with submit button to login
                                _formKey.currentState!.save();
                                FocusScope.of(context).unfocus();
                                _submit(
                                  _email.text.toString(),
                                  _password.text.toString(),
                                );
                              }
                            },
                            child: Container(
                              height: _size.height * 0.07,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 2, 50, 62),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///Already account login button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account ? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupScreen()));
                                },
                                child: const Text(
                                  'SignUp',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 2, 50, 62),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///Progress
          Visibility(
            visible: _isLoading,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Function for requesting api
  Future<void> _submit(String email, password) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseService.initializeApp();
      var response = await FirebaseService.loginUser(email, password);
      if (response != null) {
        // Handle successful signup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully signin"),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // Handle failed signup
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invaild Credintial")));
      }
    } catch (e) {
      // Handle error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "something went wrong",
          ),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
