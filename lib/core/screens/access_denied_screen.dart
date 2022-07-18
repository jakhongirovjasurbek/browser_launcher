import 'package:browser_launcher/core/bloc/module_bloc.dart';
import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/core/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Access to storage is denied',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              WButton(
                margin: const EdgeInsets.all(20),
                onTap: () {
                  context.read<ModuleBloc>().add(GetModuleStatus(
                        onSuccess: () {},
                        onFailure: (message) {
                          showErrorSnackBar(context, message: message);
                        },
                      ));
                },
                color: Colors.blue,
                text: 'Restart App',
              )
            ],
          ),
        ),
      );
}
