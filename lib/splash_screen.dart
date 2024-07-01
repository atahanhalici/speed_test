import 'package:flutter/material.dart';
import 'package:speed_test/test_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sayfayaGec();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Image.asset("assets/logo.png"),
          const Expanded(child: SizedBox()),
          const LinearProgressIndicator(
            color: Colors.red,
            backgroundColor: Color.fromARGB(255, 22, 22, 22),
          ),
        ],
      ),
    );
  }

  void sayfayaGec() async {
    await Future.delayed(const Duration(seconds: 4));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const TestPage()));
  }
}
