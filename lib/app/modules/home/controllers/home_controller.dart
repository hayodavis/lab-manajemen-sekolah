import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_toast.dart';
import 'package:flutter/widgets.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void search() {
    update();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("users").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamInventory() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("inventories").snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastInventory() async* {
    String uid = auth.currentUser!.uid;
    // yield* firestore
    //     .collection("inventories")
    //     .orderBy("created_at", descending: true)
    //     .limitToLast(5)
    //     .snapshots();

    if (searchC.text.isEmpty) {
      yield* firestore
          .collection("inventories")
          .orderBy("created_at", descending: true)
          .snapshots();
    } else {
      String searchText = searchC.text.trim();
      // List<String> keywords =
      //     searchText.split(" "); // Memisahkan kata kunci pencarian

      yield* firestore
          .collection("inventories")
          // .where("title", isEqualTo: searchText)
          .orderBy("created_at", descending: true)
          .snapshots();
    }
  }

  void logout() async {
    CustomAlertDialog.showPresenceAlert(
      title: "Logout System",
      message: "Apakah anda yakin akan logout dari sistem ?",
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // close modal
        Get.back(); // back page
        try {
          await auth.signOut();
          Get.offAllNamed(Routes.LOGIN);
          CustomToast.successToast('Success', 'Berhasil Logout');
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Error dikarenakan : ${e.toString()}");
        }
      },
    );
  }
}
