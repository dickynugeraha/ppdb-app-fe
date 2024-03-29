import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/siswa.dart';
import './profil_edit_screen.dart';
import '../../providers/auth.dart';
import '../../providers/kategori.dart';
import '../auth_screen.dart';
import '../../providers/helper.dart';
import '../../widgets/foto_identitas_siswa.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isLoading = true;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<KategoriProvider>(context).fetchKategoriWithSubBobot();

      Provider.of<SiswaProvider>(context)
          .fetchAndSetSingleSiswa()
          .then((_) => _isLoading = false);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final siswa = Provider.of<SiswaProvider>(context).item;

    final height = MediaQuery.of(context).size.height;

    return _isLoading
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
                  height: (height) * 0.37,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/profil_bg.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          "${Helper.domainNoApiUrl}/uploads/foto_profil/${siswa!.fotoProfil}",
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${siswa.nama} (${siswa.nisn})",
                            // "Nama (Nisn)",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(ProfilEditScreen.routeName),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        siswa.asalSekolah!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName);
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: (height) * 0.55,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profilItem(Icons.numbers, "NISN", siswa.nisn!),
                      const Divider(),
                      profilItem(Icons.supervised_user_circle_outlined, "Nama",
                          siswa.nama!),
                      const Divider(),
                      profilItem(
                        Icons.male,
                        "Jenis Kelamin",
                        siswa.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan',
                      ),
                      const Divider(),
                      profilItem(Icons.email, "Email", siswa.email!),
                      const Divider(),
                      profilItem(Icons.store_mall_directory_sharp, "Alamat",
                          siswa.alamat!),
                      const Divider(),
                      profilItem(
                          Icons.phone, "No Hp Orang tua", siswa.noHpOrtu!),
                      const Divider(),
                      detailItem(
                        icon: Icons.image,
                        title: "Foto identitas",
                        onTaps: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FotoIdentitasSiswa(
                                nisn: siswa.nisn!,
                                adminPage: false,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Widget profilItem(IconData icon, String title, String valueText) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(left: 35),
          child: Text(valueText),
        ),
      ),
    );
  }

  Widget detailItem({
    IconData? icon,
    String? title,
    Function()? onTaps,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: onTaps,
                  child: const Text(
                    "Lihat",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
