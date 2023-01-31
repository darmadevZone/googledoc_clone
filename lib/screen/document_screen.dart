import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_clone_app/constants/colors.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController = TextEditingController(
    text: 'Untitled Document',
  );

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //elevation AppBarの境界線をわからなくする。
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              label: const Text("Share"),
              icon: const Icon(
                Icons.lock,
                size: 16,
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlackColor,
              ),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9.0,
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/docs.png",
                height: 40,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: kBlueColor,
                      )),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    )),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kGreyColor,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
