import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/kategori.dart';
import '../../models/sub_bobot.dart';
import '../../providers/siswa.dart';
import '../../widgets/custom_design.dart';

class PrestasiBobotScreen extends StatefulWidget {
  const PrestasiBobotScreen({Key? key}) : super(key: key);

  @override
  State<PrestasiBobotScreen> createState() => _PrestasiBobotScreenState();
}

class _PrestasiBobotScreenState extends State<PrestasiBobotScreen> {
  bool isInit = true;
  bool isLoading = true;

  List<SubBobotWithKategori> kategoriWithSubBobot = [];
  final List<Map<String, dynamic>> dynamicSlectedId = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<SiswaProvider>(context)
          .fetchAndSetSingleSiswa()
          .then((_) => isLoading = false);

      kategoriWithSubBobot =
          Provider.of<KategoriProvider>(context, listen: false).itemsSubBobot;
      int count = 0;
      for (var kategoriItem in kategoriWithSubBobot) {
        dynamicSlectedId.add({
          "kategoriId$count": kategoriItem.kategori!.id,
          "kategoriNama$count": kategoriItem.kategori!.nama,
          "subBobotId$count": kategoriItem.subBobot![0].id,
          "subBobotKeterangan$count": kategoriItem.subBobot![0].keterangan,
          "nilai$count": kategoriItem.subBobot![0].bobot,
        });
        count++;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final siswa = Provider.of<SiswaProvider>(context, listen: false).item;

    Future<void> submitBobot() async {
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<SiswaProvider>(context, listen: false)
            .storeBobotSiswa(dynamicSlectedId);
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Success",
          isPop: false,
          desc: "Berhasil menambah nilai",
          dialogSuccess: true,
        );
      } catch (e) {
        CustomDesign.customAwesomeDialog(
          context: context,
          title: "Error",
          isPop: false,
          desc: e.toString(),
          dialogSuccess: false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return isLoading
        ? Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          )
        : Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Container(
                  height: deviceHeight * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/profil_bg.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pembobotan".toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "1. Silahkan kalkulasi nilai rata-rata per kategori (0-100). Jika terindikasi melakukan kecurangan dengan menambahkan point nilai, akan langsung kami DISKUALIFIKASI dan dinyatakan TIDAK DITERIMA dalam pelaksanaan PPDB tahun ini.",
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "2. Siswa hanya diberi kesempatan sekali submit, jadi pastikan data yang diisi sudah benar.",
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                siswa!.nilai == null
                    ? "Isi bobot diri".toUpperCase()
                    : "Data bobot sudah diisi, silahkan tunggu pengumuman hasil seleksi!"
                        .toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Spacer(),
              const SizedBox(height: 10),
            ],
          );
  }

  List<DropdownMenuItem<String>> _dropdownItems(List<SubBobot> subBobots) {
    List<DropdownMenuItem<String>> items = [];
    for (var subBobot in subBobots) {
      items.add(
        DropdownMenuItem(
          value: subBobot.id,
          child: Text(subBobot.keterangan!),
        ),
      );
    }
    return items;
  }
}
