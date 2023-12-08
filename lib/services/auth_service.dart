import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    print(credential);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithApple(BuildContext context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential != null) {
      // appleLogin为apple登录逻辑
      print(credential);
      print("-->${credential.userIdentifier}");
      print("-->${credential.givenName}");
      print("-->${credential.state}");
      // appleLogin(credential.identityToken);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
