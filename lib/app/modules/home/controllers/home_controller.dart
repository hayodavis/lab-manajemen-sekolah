import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

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

    yield* firestore
        .collection("inventories")
        .orderBy("created_at", descending: true)
        .limit(5)
        .snapshots();

    // if (searchC.text.isEmpty) {
    //   yield* firestore
    //       .collection("inventories")
    //       .orderBy("created_at", descending: true)
    //       .snapshots();
    // } else {
    //   yield* firestore
    //       .collection("inventories")
    //       .where("title", isGreaterThanOrEqualTo: searchC.text.trim())
    //       .where("title", isLessThan: "${searchC.text.trim()}z")
    //       .snapshots();
    // }
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

  Future<Map<String, dynamic>> getInvetoryById(String kodeInventaris) async {
    try {
      var hasil = await firestore
          .collection("inventories")
          .where("kode_inventaris", isEqualTo: kodeInventaris)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada inventaris di database",
        };
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail inventaris dari kode ini.",
        "data": data,
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat mendapatkan detail inventaris dari kode ini.",
      };
    }
  }

  void downloadqr() async {
    final pdf = pw.Document();

    var getData = await firestore.collection("inventories").get();

    List items = [];

    for (var element in getData.docs) {
      items.add(element.data());
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData = List.generate(
            items.length,
            (index) {
              var item = items[index];
              return pw.TableRow(
                children: [
                  // No
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Kode Inventaris
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      item["kode_inventaris"],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Spesification
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      item["spesification"],
                      textAlign: pw.TextAlign.left,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Kondisi Inventaris
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      item["kondisi"],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // QR Code
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.BarcodeWidget(
                      color: PdfColor.fromHex("#000000"),
                      barcode: pw.Barcode.qrCode(),
                      data: item["kode_inventaris"],
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              );
            },
          );
          return [
            pw.Center(
              child: pw.Text(
                "Download QR Code Inventaris",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Container(
                      width: 70,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "No",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Kode Inventaris
                    pw.Container(
                      width: 180,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "Kode",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Spesifikasi
                    pw.Container(
                      // width: 150,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "Spesifikasi",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Kondisi Inventaris
                    pw.Container(
                      width: 150,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "Kondisi",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // QR Code
                    pw.Container(
                      width: 150,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          "QR Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/mydocument.pdf');

    // memasukan data bytes -> file kosong
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }

  void scanQr() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#000000",
      "CANCEL",
      true,
      ScanMode.QR,
    );
    Map<String, dynamic> hasil = await getInvetoryById(barcode);
    if (hasil["error"] == false) {
      print(hasil);
      Get.toNamed(Routes.DETAIL_INVENTORY, arguments: {
        "id": "${hasil["data"]["inventory_id"]}",
        "title": "${hasil["data"]["title"]}",
        "spesification": "${hasil["data"]["spesification"]}",
        "kondisi": "${hasil["data"]["kondisi"]}",
        "image": "${hasil["data"]["image"]}",
      });
    } else {
      Get.snackbar(
        "Error",
        hasil["message"],
        duration: const Duration(seconds: 2),
      );
    }
  }
}
