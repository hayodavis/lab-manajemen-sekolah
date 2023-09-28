import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/edit_inventory_controller.dart';

class EditInventoryView extends GetView<EditInventoryController> {
  const EditInventoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Inventory',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColor.secondaryExtraSoft,
          ),
        ),
      ),
      body: GetBuilder<EditInventoryController>(builder: (controller) {
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          children: [
            CustomInput(
              controller: controller.titleC,
              label: 'Nama:',
              hint: 'contoh: Laptop HP',
            ),
            CustomInput(
              controller: controller.specC,
              label: 'Spesifikasi:',
              hint: 'Contoh: RAM 8GB, Prosessor Corei7',
            ),
            Text(
              "Kondisi Inventaris:",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w500,
                color: AppColor.secondarySoft,
              ),
            ),
            Obx(() => Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: "Normal",
                          groupValue: controller.radio.value,
                          onChanged: (value) => controller.setRadio(value),
                        ),
                        Text(
                          "Normal",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColor.secondarySoft,
                          ),
                        ),
                        Radio(
                          value: "Dalam Perbaikan",
                          groupValue: controller.radio.value,
                          onChanged: (value) => controller.setRadio(value),
                        ),
                        Text(
                          "Dalam Perbaikan",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColor.secondarySoft,
                          ),
                        ),
                        Radio(
                          value: "Rusak",
                          groupValue: controller.radio.value,
                          onChanged: (value) => controller.setRadio(value),
                        ),
                        Text(
                          "Rusak",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColor.secondarySoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            CustomInput(
              controller: controller.lokasiC,
              label: 'Lokasi:',
              hint: 'Contoh: Lab RPL',
            ),
            (controller.file == null)
                ? Image.network(
                    (controller.image != null)
                        ? controller.image
                        : 'https://placehold.co/600x400/png',
                  )
                : Image.file(controller.file!),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.toCamera(),
                    child: Text(
                      'Kamera',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.pickFile(),
                    child: Text(
                      'Galeri',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.editInventory();
                    }
                  },
                  child: Text(
                    (controller.isLoading.isFalse)
                        ? 'Simpan Perubahan'
                        : 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
