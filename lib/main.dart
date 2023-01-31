import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/models/error_model.dart';
import 'package:google_doc_clone_app/repositories/auth_repository.dart';
import 'package:google_doc_clone_app/router.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

//MyAppの状態を持つ
class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();

    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((_) => errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        final userScreenRouter = (user != null && user.token.isNotEmpty)
            ? loggedInRoute
            : loggedOutRoute;
        return userScreenRouter;
      }),
    );
  }
}
