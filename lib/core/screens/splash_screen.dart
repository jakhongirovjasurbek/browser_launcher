import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      );
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 24),
              Text(
                'Browser & Launcher',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const CupertinoActivityIndicator(),
            ],
          ),
        ),
      );
}
