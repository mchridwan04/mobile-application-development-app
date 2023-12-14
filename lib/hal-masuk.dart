import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mad_uas_app/hal-pengguna/hal-layout.dart';
import 'package:mad_uas_app/hal-daftar-akun.dart';

class HalMasuk extends StatefulWidget {
  const HalMasuk({super.key});
  @override
  State<HalMasuk> createState() => _HalMasukState();
}

class _HalMasukState extends State<HalMasuk> {
  final _formKey = GlobalKey<FormState>();
//mendefinisikan field/kolom inputan
  var username = TextEditingController();
  var password = TextEditingController();
  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("http://localhost:8000/api/login"),
        body: {
          "username": username.text,
          "password": password.text,
        },
      ).then((value) {
//tampilkan pesan setelah menambahkan data ke database
//kamu dapat menambah pesan/notifikasi di sini
        var data = jsonDecode(value.body);
        print(data["message"]);
        if (data["message"] == 'Login succesfully') {
          AnimatedSnackBar.material(
            'Masuk berhasil.',
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 1),
          ).show(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HalLayout()));
        } else {
          AnimatedSnackBar.material(
            'Masuk gagal.',
            type: AnimatedSnackBarType.warning,
            duration: const Duration(seconds: 1),
          ).show(context);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image-data/welcome.jpg"))),
            ),
            Column(
              children: [
                const Text(
                  "Halaman Masuk",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Silahkan masukkan data akun kamu.",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                )
              ],
            ),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                                label: const Text('Username'),
                                hintText: "Tulis username ...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                fillColor: Colors.white,
                                filled: true),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username is Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: password,
                            decoration: InputDecoration(
                                label: const Text('Password'),
                                hintText: 'Tulis password ...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                fillColor: Colors.white,
                                filled: true),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              color: Colors.teal,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "M a s u k",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.login_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _onSubmit();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum memiliki akun ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HalDaftarAkun()));
                  },
                  child: const Text(
                    "Daftar Akun.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
