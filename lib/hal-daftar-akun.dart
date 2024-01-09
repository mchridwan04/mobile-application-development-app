import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:mad_uas_app/hal-masuk.dart';
import 'package:mad_uas_app/hal-utama.dart';

class HalDaftarAkun extends StatefulWidget {
  const HalDaftarAkun({super.key});
  @override
  State<HalDaftarAkun> createState() => _HalDaftarAkunState();
}

class _HalDaftarAkunState extends State<HalDaftarAkun> {
  final _formKey = GlobalKey<FormState>();
//mendefinisikan field/kolom inputan
  var username = TextEditingController();
  var password = TextEditingController();
  var password_confirmation = TextEditingController();
  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("http://localhost:8000/api/register"),
        body: {
          "username": username.text,
          "password": password.text,
          "password_confirmation": password_confirmation.text,
        },
      ).then((value) {
//tampilkan pesan setelah menambahkan data ke database
//kamu dapat menambah pesan/notifikasi di sini
        var data = jsonDecode(value.body);
        print(data['success']);
        if (data['success'] == true) {
          AnimatedSnackBar.material(
            'Operasi berhasil.',
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 1),
          ).show(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HalMasuk()));
        } else {
          AnimatedSnackBar.material(
            'Operasi gagal.',
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HalUtama()));
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/image-form/img-homepage.png"))),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Halaman Daftar Akun",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Silahkan masukkan data diri kamu.",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                                label: const Text('Username'),
                                hintText: "Tulis username kamu ...",
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
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                                label: const Text('Password'),
                                hintText: 'Tulis password kamu ...',
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
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: password_confirmation,
                            obscureText: true,
                            decoration: InputDecoration(
                                label: const Text('Password Konfirmasi'),
                                hintText: 'Tulis password kamu ...',
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
                                return 'Password Konfirmasi is Required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          Container(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.create_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Daftar Akun",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
//validasi
                                if (_formKey.currentState!.validate()) {
//menjalankan fungsi untuk kirim data ke database
                                  _onSubmit();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
