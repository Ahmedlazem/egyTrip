import 'package:egytrip/localization/language_constants.dart';
import 'package:egytrip/pages/splash_screen.dart';
import 'package:egytrip/widgets/appTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const String routName = '/login';
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _userNameController = TextEditingController();
  String codeCountry = '+20';
  String userName;
  String userPhone;
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  String phoneNumber = "+2";
  void _onCountryChange(CountryCode countryCode) {
    this.phoneNumber = countryCode.toString();
    codeCountry = countryCode.toString();
    print("New Country selected: " + countryCode.toString());
  }

  Future<void> setUserSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'userName': _userNameController.text,
        'userPhone': this.phoneNumber + _phoneController.text.trim(),
      },
    );

    prefs.setString('userData', userData);
  }

  static Future<Map<String, Object>> getUserSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return null;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    return extractedUserData;
  }

  // ignore: missing_return
  void loginUser(String phone, BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      isLoading = false;
      return;
    }

    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);
          await setUserSharedPref();
          User user = result.user;

          if (user != null) {
            Navigator.of(context)
                .pushReplacementNamed(StartScreen.routName, arguments: {
              'userName': _userNameController.text,
              'userPhone': this.phoneNumber + _phoneController.text.trim()
            });
            await FirebaseFirestore.instance
                .collection('users')
                .doc(result.user.uid)
                .set({
              'username': _userNameController.text,
              'phone': this.phoneNumber + _phoneController.text.trim(),
            });
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        // iam warry about firebase expation
        verificationFailed: (FirebaseException exception) {
          print(exception.message);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    title: Text("error?"),
                    content: Text(exception.message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
              });
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: Container(
                    child: Text(
                      getTranslated(context, "Give the code?"),
                      style: TextStyle(
                          fontSize: 14, color: AppTheme.primaryColors),
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        getTranslated(context, "Confirm"),
                      ),
                      textColor: Colors.white,
                      color: AppTheme.primaryColors,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        User user = result.user;
                        setUserSharedPref();
                        if (user != null) {
                          Navigator.of(context).pushReplacementNamed(
                              StartScreen.routName,
                              arguments: {
                                'userName': _userNameController.text,
                                'userPhone': this.phoneNumber +
                                    _phoneController.text.trim()
                              });
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(result.user.uid)
                              .set({
                            'username': _userNameController.text,
                            'phone':
                                this.phoneNumber + _phoneController.text.trim(),
                          });
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  getTranslated(context, "Welcome in SaWaH"),
                  style: TextStyle(
                      color: AppTheme.getTheme().primaryColor,
                      fontSize: 25,
                      fontFamily: 'Lalezar',
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  key: ValueKey('name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return (getTranslated(
                          context, " please enter your name"));
                    }
                    if (value == null) {
                      return (getTranslated(
                          context, " please enter your name"));
                    }
                    if (value.length < 2) {
                      return (getTranslated(
                          context, "enter more than 3 letters"));
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey[300])),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: (getTranslated(context, "Name")),
                  ),
                  controller: _userNameController,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CountryCodePicker(
                        onChanged: _onCountryChange,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'EG',
                        favorite: ['+966', 'SA'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        key: ValueKey('phone'),
                        //  initialValue: "01XXXXXXX0X",
                        validator: codeCountry == '+20'
                            ? (value) {
                                if (value.isEmpty) {
                                  return (getTranslated(
                                      context, " please enter your phone no"));
                                }
                                if (value == null) {
                                  return (getTranslated(
                                      context, " please enter your phone no"));
                                }
                                if (value.length < 11) {
                                  return (getTranslated(
                                      context, "enter more than 10 Digits"));
                                }
                                if (value.length > 11) {
                                  return (getTranslated(
                                      context, "enter 11 Digits"));
                                }
                                return null;
                              }
                            : (value) {
                                if (value.isEmpty) {
                                  return (getTranslated(
                                      context, " please enter your phone no"));
                                }
                                if (value == null) {
                                  return (getTranslated(
                                      context, " please enter your phone no"));
                                }
                                if (value.length < 10) {
                                  return (getTranslated(
                                      context, "enter more than 9 Digits"));
                                }
                                if (value.length > 10) {
                                  return (getTranslated(
                                      context, "enter 10 Digits"));
                                }
                                return null;
                              },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: (getTranslated(context, "Mobile Number")),
                          helperText: codeCountry == '+20'
                              ? "01X0X0X0X0X"
                              : "05X0X0X0X0",
                        ),
                        controller: _phoneController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: !isLoading
                        ? Text(getTranslated(context, "LOGIN"))
                        : CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      isLoading = true;
                      final phone = this.phoneNumber +
                          _phoneController.text.trim().substring(0);

                      loginUser(phone, context);
                    },
                    color: AppTheme.getTheme().primaryColor,
                  ),
                ),
                // SizedBox(height: 16.0),
                // checkBtn,
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 10, 14, 0),
                  child: Center(
                    child: Text(
                      (getTranslated(
                        context,
                        "* please sure your connected with internet",
                      )),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Theme.of(context).buttonColor),
                    ),
                  ),
                ),

                Image(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    'assets/image/introduction3.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
