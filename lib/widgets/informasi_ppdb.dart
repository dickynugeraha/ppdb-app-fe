import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sekolah.dart';

class InformasiPPDB extends StatelessWidget {
  const InformasiPPDB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sekolah = Provider.of<SekolahProvider>(context, listen: false).item;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white54,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  "Info seputar ppdb".toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "1. Peserta PPDB diwajibkan memenuhi segala kebutuhan administrasi. Mulai dari data diri dan melakukan upload foto identitas yang tertera pada menu profil.",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                const Text(
                  "2. Setelah data diri sudah lengkap, peserta PPDB diwajibkan meng-upload nilai pretasi melalui kolom input yang disediakan.",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                const Text(
                  "3. Data akan kami olah selama periode proses pendaftaran sudah ditutup.",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                const Text(
                  "4. Tanggal - tanggal penting dalam proses seleksi PPDB dapat dilihat di halaman Home bagian sekolah.",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                const Text(
                  "5. Hasil seleksi tidak dapat diganggu gugat oleh pihak manapun.",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                const Text(
                  "6. Bagi siswa yang lolos diharapkan langsung melakukan daftar ulang dengan mendatangi sekolah.",
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
