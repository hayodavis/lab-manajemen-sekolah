import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:lab_manajemen_sekolah/app/modules/home/controllers/home_controller.dart';
import 'package:lab_manajemen_sekolah/app/routes/app_pages.dart';
import 'package:lab_manajemen_sekolah/app/utils/app_color.dart';
import 'package:lab_manajemen_sekolah/app/widgets/custom_input.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        extendBody: true,
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.done:
                  Map<String, dynamic> user = snapshot.data!.data()!;
                  return ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                    children: [
                      SizedBox(height: 16),
                      // Section 1 - Welcome Back
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    child: Image.network(
                                      (user["avatar"] == null ||
                                              user['avatar'] == "")
                                          ? "https://ui-avatars.com/api/?name=${user['name']}/"
                                          : user['avatar'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selamat datang kembali",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.secondarySoft,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      user["name"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => {controller.logout()},
                              child: Text("Logout"),
                            ),
                          ],
                        ),
                      ),
                      // section 2 -  card
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream:
                            controller.streamInventory().asBroadcastStream(),
                        builder: (context, snapshot) {
                          // #TODO: make skeleton
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            case ConnectionState.active:
                            case ConnectionState.done:
                              var inventoryLengthData =
                                  snapshot.data?.docs.length;
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: 24, top: 24, right: 24, bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/pattern-1.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // job
                                    // Text(
                                    //   user["email"],
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontFamily: 'poppins',
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.primarySoft,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 6),
                                                  child: Text(
                                                    "Jumlah Inventaris",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${inventoryLengthData.toString()}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            default:
                              return SizedBox();
                          }
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "List Inventaris Terbaru",
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () => controller.downloadqr(),
                              child: Text("Download QR Code"),
                              style: TextButton.styleFrom(
                                primary: AppColor.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: CustomInput(
                              controller: controller.searchC,
                              hint: "Cari Inventaris",
                              label: "Pencarian",
                            )),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () => controller.search(),
                                child: Icon(Icons.search)),
                            SizedBox(width: 8),
                            ElevatedButton(
                                onPressed: () => {controller.scanQr()},
                                child: Icon(Icons.qr_code_scanner))
                          ],
                        ),
                      ),
                      // SizedBox(height: 20),
                      // Container(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Expanded(
                      //           child: CustomInput(
                      //         controller: controller.searchC,
                      //         hint: "Cari...",
                      //         label: "Pencarian",
                      //       )),
                      //       const SizedBox(
                      //         width: 16,
                      //       ),
                      //       ElevatedButton(
                      //           onPressed: () => controller.search(),
                      //           child: Text("Search"))
                      //     ],
                      //   ),
                      // ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller
                              .streamLastInventory()
                              .asBroadcastStream(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              case ConnectionState.active:
                              case ConnectionState.done:
                                List<
                                        QueryDocumentSnapshot<
                                            Map<String, dynamic>>> listResults =
                                    snapshot.data!.docs;
                                var items = [];
                                listResults.forEach((element) {
                                  items.add(element.data());
                                });

                                if (controller.searchC.text.isNotEmpty) {
                                  items = items
                                      .where((e) => e["title"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(controller.searchC.text
                                              .toLowerCase()))
                                      .toList();
                                }
                                return ListView.separated(
                                  //itemCount: listResults.length,
                                  itemCount: items.length,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    //var inventoryData = listResults[index].data();
                                    var inventoryData = items[index];
                                    return InkWell(
                                      onTap: () => {
                                        Get.toNamed(Routes.DETAIL_INVENTORY,
                                            arguments: {
                                              "id":
                                                  "${inventoryData["inventory_id"]}",
                                              "title":
                                                  "${inventoryData["title"]}",
                                              "spesification":
                                                  "${inventoryData["spesification"]}",
                                              "kondisi":
                                                  "${inventoryData["kondisi"]}",
                                              "image":
                                                  "${inventoryData["image"]}",
                                            }),
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: AppColor.primaryExtraSoft,
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 24,
                                            top: 20,
                                            right: 29,
                                            bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  inventoryData["image"],
                                                  width: 50,
                                                ),
                                                SizedBox(width: 24),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (inventoryData["title"] ==
                                                              null)
                                                          ? "-"
                                                          : "${inventoryData["title"]}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColor.secondary,
                                                      ),
                                                    ),
                                                    SizedBox(width: 50),
                                                    Text(
                                                      "Kondisi: ${inventoryData["kondisi"]}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor
                                                            .secondarySoft,
                                                      ),
                                                    ),
                                                    // // Text(
                                                    // //   "Lokasi: ${inventoryData["lokasi"]}",
                                                    // //   style: TextStyle(
                                                    // //     fontSize: 12,
                                                    // //     color: AppColor
                                                    // //         .secondarySoft,
                                                    // //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: QrImageView(
                                                data: inventoryData[
                                                    "kode_inventaris"],
                                                size: 200.0,
                                                version: QrVersions.auto,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              default:
                                return SizedBox();
                            }
                          }),
                      SizedBox(height: 64),
                    ],
                  );
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return Center(child: Text("Error"));
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.ADD_INVENTORY);
          },
          child: Icon(
            Icons.add,
          ),
        ),
      );
    });
  }
}
