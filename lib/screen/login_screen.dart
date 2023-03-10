import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/colors.dart';
import 'package:google_doc_clone_app/repository/auth_repository.dart';
import 'package:google_doc_clone_app/screen/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    final navigator = Navigator.of(context);

    //signInWithGoogle サインイン成功
    if (errorModel.error == null) {
      //login 成功
      ref.read(userProvider.notifier).update((_) => errorModel.data);
      navigator.push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } else {
      //login 失敗
      sMessenger
          .showSnackBar(SnackBar(content: Text(errorModel.error.toString())));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            onPressed: () => signInWithGoogle(ref, context),
            icon: Image.asset(
              'assets/images/googleLogo.png',
              height: 20,
            ),
            label: const Text(
              "Sign in with Google",
              style: TextStyle(color: kBlackColor),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                backgroundColor: kWhiteColor)),
      ),
    );
  }
}
