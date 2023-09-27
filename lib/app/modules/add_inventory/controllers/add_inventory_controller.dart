import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lab_manajemen_sekolah/app/modules/add_inventory/views/camera_view.dart';
import 'package:lab_manajemen_sekolah/app/widgets/custom_toast.dart';
import 'package:uuid/uuid.dart';

class AddInventoryController extends GetxController {
  //TODO: Implement AddInventoryController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;
  RxString radio = "Normal".obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController specC = TextEditingController();
  TextEditingController lokasiC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? file;

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

    titleC.dispose();
    specC.dispose();
    lokasiC.dispose();
  }

  void increment() => count.value++;

  void setRadio(value) {
    radio.value = value;
  }

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

  Future<void> addTodo() async {
    if (titleC.text.isNotEmpty &&
        specC.text.isNotEmpty &&
        lokasiC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateTodo.isFalse) {
        await createTodoData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  createTodoData() async {
    isLoadingCreateTodo.value = true;
    String adminEmail = auth.currentUser!.email!;
    if (file != null) {
      try {
        var uuidInventory = Uuid().v1();

        String fileName = file!.path.split('/').last;
        String ext = fileName.split(".").last;
        String upDir = "inventory/${uuidInventory}.$ext";

        var snapshot = await firebaseStorage
            .ref()
            .child('inventories/$upDir')
            .putFile(file!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        CollectionReference inventories = firestore.collection("inventories");
        await inventories.doc(uuidInventory).set({
          "inventory_id": uuidInventory,
          "title": titleC.text,
          "spesification": specC.text,
          "kondisi": radio.value,
          "lokasi": lokasiC.text,
          "image": downloadUrl,
          "created_at": DateTime.now().toIso8601String(),
        });

        Get.back(); //close dialog
        Get.back(); //close form screen
        CustomToast.successToast('Success', 'Berhasil menambahkan inventaris');

        isLoadingCreateTodo.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingCreateTodo.value = false;
        CustomToast.errorToast('Error', 'error : ${e.code}');
      } catch (e) {
        isLoadingCreateTodo.value = false;
        CustomToast.errorToast('Error', 'error : ${e.toString()}');
      }
    } else {
      CustomToast.errorToast('Error', 'gambar tidak boleh kosong !!');
    }
  }
}