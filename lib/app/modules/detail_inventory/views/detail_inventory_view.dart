import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lab_manajemen_sekolah/app/routes/app_pages.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/detail_inventory_controller.dart';

class DetailInventoryView extends GetView<DetailInventoryController> {
  const DetailInventoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Inventaris',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.EDIT_INVENTORY,
                  arguments: controller.argsData);
            },
            child: Text('Edit'),
            style: TextButton.styleFrom(
              primary: AppColor.primary,
            ),
          ),
        ],
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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          Image.network(controller.image),
          const SizedBox(
            height: 16,
          ),
          CustomInput(
            controller: controller.kodeInventarisC,
            label: 'Nama:',
            hint: 'Contoh: LaptopHP#123',
            disabled: true,
          ),
          CustomInput(
            controller: controller.titleC,
            label: 'Nama:',
            hint: 'Contoh: Laptop HP',
            disabled: true,
          ),
          CustomInput(
            controller: controller.specC,
            label: 'Spesifikasi:',
            hint: 'Contoh: Corei7 RAM 8GB',
            disabled: true,
          ),
          // CustomInput(
          //   controller: controller.lokasiC,
          //   label: 'Lokasi:',
          //   hint: 'Contoh: Aula',
          //   disabled: true,
          // ),
          CustomInput(
            controller: controller.kondisiC,
            label: 'Kondisi:',
            hint: 'Kondisi: Normal | Dalam Perbaikan | Rusak',
            disabled: true,
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteInventory();
            },
            child: Text(
              'Delete Inventaris',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'poppins',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: AppColor.warning,
              padding: EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
