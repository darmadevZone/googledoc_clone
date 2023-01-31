// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/models/error_model.dart';
import 'package:google_doc_clone_app/repositories/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../constants/constants.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  );
});

//読み取り専用
final userProvider = StateProvider<UserModel?>(((ref) => null));

/**
 * AuthRepository(GoogleSignIn())でpropertyに入る
 */
class AuthRepository {
  final GoogleSignIn googleSignIn;
  final Client client;
  final LocalStorageRepository localStorageRepository;

  const AuthRepository({
    required this.googleSignIn,
    required this.client,
    required this.localStorageRepository,
  });

  /**
   * AuthRepository({
   *  required this.googleSignIn,
   * })_googleSignIn = googleSignIn;
   */

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );

    try {
      final user = await googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        );

        var res = await client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await localStorageRepository.getToken();

      if (token != null) {
        var res = await client.get(Uri.parse('$host/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void signOut() async {
    await googleSignIn.signOut();
    localStorageRepository.setToken("");
  }
}
