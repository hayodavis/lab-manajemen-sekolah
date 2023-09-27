import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab_manajemen_sekolah/app/modules/add_inventory/views/camera_view.dart';

import '../../../widgets/custom_toast.dart';

class EditInventoryController extends GetxController {
  //TODO: Implement EditInventoryController

  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateInventory = false.obs;
  //RxString radio = "".obs;
  String image = "";
  File? file;

  TextEditingController titleC = TextEditingController();
  TextEditingController specC = TextEditingController();
  TextEditingController lokasiC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();

    titleC.text = argsData["title"];
    specC.text = argsData["spesification"];
    lokasiC.text = argsData["lokasi"];
    //radio = argsData["kondisi"];
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
    lokasiC.dispose();
  }

  // void setRadio(value) {
  //   radio.value = value;
  // }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path ?? '');
    } else {
      // User canceled the picker
    }
    update();
  }

  void toCamera() {
    Get.to(CameraView())!.then((result) {
      file = result;
      update();
    });
  }

  Future<void> editInventory() async {
    if (titleC.text.isNotEmpty &&
        specC.text.isNotEmpty &&
        lokasiC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateInventory.isFalse) {
        await editInventoryData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  editInventoryData() async {
    isLoadingCreateInventory.value = true;
    String adminEmail = auth.currentUser!.email!;
    if (file != null) {
      try {
        String uid = auth.currentUser!.uid;
        CollectionReference<Map<String, dynamic>> childrenCollection =
            await firestore.collection("inventories");

        DocumentReference inventory =
            await firestore.collection("inventories").doc(argsData["id"]);

        String fileName = file!.path.split('/').last;
        String ext = fileName.split(".").last;
        String upDir = "image/${argsData["id"]}.$ext";

        var snapshot =
            await firebaseStorage.ref().child('images/$upDir').putFile(file!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        await childrenCollection.doc(argsData["id"]).update({
          "title": titleC.text,
          "spesification": specC.text,
          //"kondisi": radio.value,
          "lokasi": lokasiC.text,
          "image": downloadUrl,
        });

        Get.back(); //close dialog
        Get.back(); //close form screen
        CustomToast.successToast('Success', 'Berhasil memperbarui inventory');

        isLoadingCreateInventory.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingCreateInventory.value = false;
        CustomToast.errorToast('Error', 'error : ${e.code}');
      } catch (e) {
        isLoadingCreateInventory.value = false;
        CustomToast.errorToast('Error', 'error : ${e.toString()}');
      }
    } else {
      CustomToast.errorToast('Error', 'gambar tidak boleh kosong !!');
    }
  }
}
