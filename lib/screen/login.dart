import 'package:flutter/material.dart';
import 'package:geo_locator_app/screen/home.dart';
import 'package:geo_locator_app/utility/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passInput = TextEditingController();
  bool _passwordVisible = false;
  String emailText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 32,
              ),
              const Center(
                child: Text('Login/Register',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: emailInput,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return Validations.isValidEmail(value!.trim());
                  },
                  onChanged: (value) {
                    setState(() {
                      emailText = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: passInput,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? passCurrentValue) {
                    return Validations.isValidPass(passCurrentValue);
                  },
                  obscureText: !_passwordVisible,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                    hintText: "Password",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    errorMaxLines: 3,
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setBool(SharedKeyConstant.LOGIN_KEY, true);
                        await prefs.setString(
                            SharedKeyConstant.EMAIL_KEY, emailText);
                        if (context.mounted) {}
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Validations {
  static final RegExp _mailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  static String? isValidEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Enter your E-mail';
    } else if (_mailRegExp.hasMatch(email)) {
      return null;
    } else {
      return 'Enter your valid E-mail';
    }
  }

  static String? isValidPass(String? passCurrentValue) {
    var passNonNullValue = passCurrentValue ?? "";
    if (passNonNullValue.isEmpty) {
      return ("Password is required");
    } else if (passNonNullValue.length < 6) {
      return ("Password Must be more than 5 characters");
    } else if (!regex.hasMatch(passNonNullValue)) {
      return ("Password should contain upper,lower,digit and Special character ");
    }
    return null;
  }
}
