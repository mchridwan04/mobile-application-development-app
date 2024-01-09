import 'package:flutter/material.dart';
import 'package:mad_uas_app/hal-daftar-akun.dart';
import 'package:mad_uas_app/hal-masuk.dart';

class HalUtama extends StatelessWidget {
  const HalUtama({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "Selamat Datang",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 20),
                Text(
                  "Pada halaman ini kamu dapat melakukan login atau signup jika belum memiliki akun.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image-data/welcome.jpg"))),
            ),
            Column(
              children: [
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalMasuk()));
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalDaftarAkun()));
                  },
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Daftar Akun",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
