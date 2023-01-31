import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/repositories/auth_repository.dart';
import 'package:google_doc_clone_app/repositories/document_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../common/widgets/loader.dart';
import '../constants/colors.dart';
import '../models/document_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((_) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push("/document/${errorModel.data.id}");
    } else {
      snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  void navigatorToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push("/document/$documentId");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("HomeScreen"),
        actions: [
          IconButton(
            onPressed: () => createDocument(ref, context),
            icon: const Icon(
              Icons.add,
              color: kBlackColor,
            ),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: kRedColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token),
        builder: (context, snapshot) {
          //loading中の処理
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return snapshot.data!.data != null
              ? Center(
                  child: Container(
                    width: 600,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentModel document = snapshot.data!.data[index];
                        return InkWell(
                          onTap: () =>
                              navigatorToDocument(context, document.id),
                          child: SizedBox(
                            height: 50,
                            child: Card(
                                child: Center(
                              child: Text(
                                document.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const Center(
                  child: Text("snapshot is null"),
                );
        },
      ),
    );
  }
}
/**
 *

 *
 *
 */
