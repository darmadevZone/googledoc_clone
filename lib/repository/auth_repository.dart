// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/constants.dart';
import 'package:google_doc_clone_app/models/error_model.dart';
import 'package:google_doc_clone_app/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(googleSignIn: GoogleSignIn(), client: Client());
});

//読み取り専用
final userProvider = StateProvider<UserModel?>(((ref) => null));

/**
 * AuthRepository(GoogleSignIn())でpropertyに入る
 */
class AuthRepository {
  final GoogleSignIn googleSignIn;
  final Client client;
  const AuthRepository({
    required this.googleSignIn,
    required this.client,
  });

  /**
   * AuthRepository({
   *  required this.googleSignIn,
   * })_googleSignIn = googleSignIn;
   */

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(error: "something error", data: null);
    try {
      //google signIn からemail displayName photoUrlをとってくる
      final user = await googleSignIn.signIn();
      if (user != null) {
        print(user.email);
        print(user.displayName);
        print(user.photoUrl);
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: "",
          token: "",
        );
        //response http://localhost:3001/api/signup
        var res = await client.post(
          Uri.parse('$host/api/signup'),
          // class to json encode
          body: userAcc.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        switch (res.statusCode) {
          case 200:
            {
              final newUser = userAcc.copyWith(
                uid: jsonDecode(res.body)['user']['_id'],
              );
              error = ErrorModel(error: null, data: newUser);
              break;
            }
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
