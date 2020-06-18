import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sign-Up Page",
      home: Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            width: 300,
            height: 1500,
            //color: Color.alphaBlend(BlendMode.color, BlendMode.colorDodge),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please enter your Password",
                              labelText: "Display Name:*",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please enter your Email",
                              labelText: "Email:*",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please enter Password",
                              labelText: "Password:*",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please re-enter Password",
                              labelText: "Re-enter Password:*",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
