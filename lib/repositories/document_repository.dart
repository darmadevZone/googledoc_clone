// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/models/document_model.dart';
import 'package:google_doc_clone_app/models/error_model.dart';
import 'package:http/http.dart';

import '../constants/constants.dart';

final documentRepositoryProvider = Provider((ref) {
  return DocumentRepository(client: Client());
});

class DocumentRepository {
  //packge: http
  final Client client;

  DocumentRepository({
    required this.client,
  });

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );

    try {
      var res = await client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      switch (res.statusCode) {
        case 200:
          {
            error =
                ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
            break;
          }
        default:
          {
            error = ErrorModel(error: res.body, data: null);
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

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await client.get(
        Uri.parse('$host/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
                DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
          error = ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          {
            error = ErrorModel(
              error: res.body,
              data: null,
            );
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
}
