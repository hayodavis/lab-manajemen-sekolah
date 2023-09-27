import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_toast.dart';

class DetailInventoryController extends GetxController {
  //TODO: Implement DetailTodoController

  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateInventory = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController specC = TextEditingController();
  TextEditingController lokasiC = TextEditingController();
  TextEditingController kondisiC = TextEditingController();
  String image = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    titleC.text = argsData["title"];
    specC.text = argsData["spesification"];
    lokasiC.text = argsData["lokasi"];
    kondisiC.text = argsData["kondisi"];
    image = argsData["image"];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    titleC.dispose();
    specC.dispose();
  }

  void increment() => count.value++;

  // Future<void> deleteTodo() async {
  //   CustomAlertDialog.showPresenceAlert(
  //     title: "Hapus data todo",
  //     message: "Apakah anda ingin menghapus data todo ini ?",
  //     onCancel: () => Get.back(),
  //     onConfirm: () async {
  //       Get.back(); // close modal
  //       Get.back(); // back page
  //       try {
  //         await firebaseStorage.refFromURL(image).delete();

  //         String uid = auth.currentUser!.uid;
  //         await firestore
  //             .collection('users')
  //             .doc(uid)
  //             .collection('todos')
  //             .doc(argsData['id'])
  //             .delete();
  //         CustomToast.successToast('Success', 'Data todo berhasil dihapus');
  //       } catch (e) {
  //         CustomToast.errorToast(
  //             "Error", "Error dikarenakan : ${e.toString()}");
  //       }
  //     },
  //   );
  // }
}
