import 'package:fingerprint/secondpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FingerprintApp(),
  ));
}

class FingerprintApp extends StatefulWidget {
  const FingerprintApp({Key? key}) : super(key: key);

  @override
  State<FingerprintApp> createState() => _FingerprintAppState();
}

class _FingerprintAppState extends State<FingerprintApp> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = true;
  List<BiometricType> _availableBiometrics = [];
  String autherized = "Not autherized";

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = true;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    try {
      _availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    //
    // = await auth.authenticate(localizedReason: "Scan your finger to authenticate",
    //   // stickyAuth=false;
    // );

    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false));

      if (!mounted) return;
      setState(() {
        autherized =
        authenticated ? "Autherized success" : "Failed to authenticated";
        if (authenticated) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecondPage()));
        }
        print(autherized);
      });
    } on PlatformException catch (e) {
      print(e);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3C3E52),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/fingerprints-FB-1.jpg',
                      width: 200,
                    ),
                    Text(
                      "Fingerprint Auth",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                          "Authenticate using your fingerprint instead of your pasword",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, height: 1.5)),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: RaisedButton(
                        onPressed: _authenticate,
                        color: Color(0xFF04A5ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          child: Text("Authenticate",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
