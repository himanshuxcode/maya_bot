import 'package:flutter/material.dart';
import 'package:maya_bot/services/firebase_service.dart';
import 'package:maya_bot/views/screens/home_screen.dart';
import 'package:maya_bot/views/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

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
                    Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: _size.height * 0.002,
                    ),

                    ///Welcome description text
                    Text(
                      "Let's answer your thoughts..!",
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
                            decoration: InputDecoration(
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
                            height: _size.height * 0.015,
                          ),

                          ///Confirm Password
                          TextFormField(
                            maxLength: 15,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.length <= 5 ||
                                  _password.text != value) {
                                return "Invalid Confirm Password";
                              }
                              return null;
                            },
                            controller: _confirmpassword,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Confirm Password",
                              labelText: "Confirm Password",
                            ),
                          ),

                          SizedBox(
                            height: _size.height * 0.01,
                          ),

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
                                color: Colors.teal,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Create Acoount",
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
                              Text(
                                "Don't have an account ? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.teal,
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
              child: Center(
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
      var response = await FirebaseService.registerUser(email, password);
      if (response != null) {
        // Handle successful signup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account Created"),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // Handle failed signup
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.toString())));
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
