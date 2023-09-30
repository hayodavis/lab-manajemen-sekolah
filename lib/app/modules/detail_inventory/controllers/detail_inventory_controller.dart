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
  //TextEditingController lokasiC = TextEditingController();
  TextEditingController kondisiC = TextEditingController();
  TextEditingController kodeInventarisC = TextEditingController();
  String image = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    titleC.text = argsData["title"];
    specC.text = argsData["spesification"];
    //lokasiC.text = argsData["lokasi"];
    kondisiC.text = argsData["kondisi"];
    kodeInventarisC.text = argsData["kode_inventaris"];
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

  Future<void> deleteInventory() async {
    CustomAlertDialog.showPresenceAlert(
      title: "Hapus data inventaris",
      message: "Apakah anda ingin menghapus data inventaris ini ?",
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // close modal
        Get.back(); // back page
        try {
          await firebaseStorage.refFromURL(image).delete();

          String uid = auth.currentUser!.uid;
          await firestore
              .collection('inventories')
              .doc(argsData['id'])
              .delete();
          CustomToast.successToast(
              'Success', 'Data inventaris berhasil dihapus');
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Error dikarenakan : ${e.toString()}");
        }
      },
    );
  }
}
