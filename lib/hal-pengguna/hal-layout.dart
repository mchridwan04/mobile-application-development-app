import 'package:flutter/material.dart';
import 'package:mad_uas_app/hal-pengguna/hal-konten.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HalLayout extends StatefulWidget {
  const HalLayout({super.key});
  @override
  State<HalLayout> createState() => _HalLayoutState();
}

class _HalLayoutState extends State<HalLayout> {
  int currentindex = 0;
  final screens = [
    const HalBerandaPengguna(),
    const HalJadwalKuliah(),
    const HalRekapMahasiswa(),
    const HalRekapDosen(),
  ];
  List<String> screentitle = [
    'Beranda',
    'Jadwal Kuliah',
    'Rekap Mahasiswa',
    'Rekap Dosen',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          screentitle[currentindex],
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
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
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          type: BottomNavigationBarType.shifting,
          fixedColor: Colors.black, //if it is shifting
          iconSize: 30,
          currentIndex: currentindex,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          onTap: (value) {
            currentindex = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.home),
                label: 'Beranda'),
            BottomNavigationBarItem(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.table_rows_rounded),
                label: 'Jadwal Kuliah'),
            BottomNavigationBarItem(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.people_alt_rounded),
                label: 'Rekap Mahasiswa'),
            BottomNavigationBarItem(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.people_alt_rounded),
                label: 'Rekap Mahasiswa'),
          ]),
      body: IndexedStack(
        index: currentindex,
        children: screens,
      ),
      floatingActionButton: SpeedDial(
// both default to 16
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.people_alt_rounded),
              backgroundColor: Colors.white,
              label: 'Entri Mahasiswa',
              labelStyle: const TextStyle(fontSize: 12.0),
              onTap: () => formEntriMahasiswa(context)),
          SpeedDialChild(
              child: const Icon(Icons.people_alt_rounded),
              backgroundColor: Colors.white,
              label: 'Entri Dosen',
              labelStyle: const TextStyle(fontSize: 12.0),
              onTap: () => formEntriDosen(context)),
          SpeedDialChild(
            child: const Icon(Icons.content_paste_search_rounded),
            backgroundColor: Colors.white,
            label: 'Entri Jadwal Kuliah',
            labelStyle: const TextStyle(fontSize: 12.0),
            onTap: () => formEntriJadwalKuliah(context),
          ),
        ],
      ),
    );
  }

//------------------------------ AREA FORM ENTRI -----------------------------
//untuk validasi form entri saat input data
  final _formKey = GlobalKey<FormState>();
//mendefinisikan field/kolom inputan dosen
  var nidn_dosen = TextEditingController();
  var nama_dosen = TextEditingController();
//mendefinisikan field/kolom inputan mahasiswa
  var nim_mahasiswa = TextEditingController();
  var nama_mahasiswa = TextEditingController();
  var jk_mahasiswa = TextEditingController();
  var tgl_lahir_mahasiswa = TextEditingController();
  var alamat_mahasiswa = TextEditingController();
  Future submitDosen() async {
    try {
      return await http.post(
        Uri.parse("http://localhost/mad_uas_app_api/tambah.php?tb=dosen"),
        body: {
          "nidn_dosen": nidn_dosen.text,
          "nama_dosen": nama_dosen.text,
        },
      ).then((value) {
//tampilkan pesan setelah menambahkan data ke database
//kamu dapat menambah pesan/notifikasi di sini
        var data = jsonDecode(value.body);
        print(data["message"]);
        if (data["status_operasi"] == 'Berhasil') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HalLayout()));
          AnimatedSnackBar.material(
            'Operasi berhasil.',
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 1),
          ).show(context);
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

  Future submitMahasiswa() async {
    try {
      return await http.post(
        Uri.parse("http://localhost/mad_uas_app_api/tambah.php?tb=mahasiswa"),
        body: {
          "nim_mahasiswa": nim_mahasiswa.text,
          "nama_mahasiswa": nama_mahasiswa.text,
          "jk_mahasiswa": jk_mahasiswa.text,
          "tgl_lahir_mahasiswa": tgl_lahir_mahasiswa.text,
          "alamat_mahasiswa": alamat_mahasiswa.text,
        },
      ).then((value) {
//tampilkan pesan setelah menambahkan data ke database
//kamu dapat menambah pesan/notifikasi di sini
        var data = jsonDecode(value.body);
        print(data["message"]);
        if (data["status_operasi"] == 'Berhasil') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HalLayout()));
          AnimatedSnackBar.material(
            'Operasi berhasil.',
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 1),
          ).show(context);
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

  Future formEntriMahasiswa(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: const Text(
                            'Form Entri Mahasiswa',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          centerTitle: true,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          iconTheme: const IconThemeData(color: Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: nim_mahasiswa,
                            decoration: const InputDecoration(
                                label: Text('NIM'),
                                hintText: "Tulis NIM ...",
                                fillColor: Colors.white,
                                filled: true),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'NIM is Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: nama_mahasiswa,
                            decoration: const InputDecoration(
                                label: Text('Nama'),
                                hintText: 'Tulis nama ...',
                                fillColor: Colors.white,
                                filled: true),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nama is Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: jk_mahasiswa,
                            decoration: const InputDecoration(
                                label: Text('Jenis Kelamin'),
                                hintText: 'Tulis jenis kelamin ...',
                                fillColor: Colors.white,
                                filled: true),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Jenis kelamin is Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: tgl_lahir_mahasiswa,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050));
                              if (pickedDate != null) {
                                tgl_lahir_mahasiswa.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              }
                            },
                            decoration: const InputDecoration(
                                label: Text('Tanggal Lahir'),
                                hintText: "Tulis tanggal lahir ...",
                                fillColor: Colors.white,
                                filled: true),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Tanggal lahir is Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: alamat_mahasiswa,
                            minLines: 5,
                            maxLines: null,
                            decoration: const InputDecoration(
                                label: Text('Alamat'),
                                hintText: 'Tulis alamat ...',
                                fillColor: Colors.white,
                                filled: true),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Alamat is Required!';
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
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              color: Colors.green,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Simpan",
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
                                  submitMahasiswa();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Future formEntriDosen(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        title: const Text(
                          'Form Entri Dosen',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        iconTheme: const IconThemeData(color: Colors.black87),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: nidn_dosen,
                          decoration: const InputDecoration(
                              label: Text('NIDN Dosen'),
                              hintText: "Tulis NIDN dosen ...",
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'NIDN dosen is Required!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: nama_dosen,
                          decoration: const InputDecoration(
                              label: Text('Nama Dosen'),
                              hintText: 'Tulis nama dosen ...',
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama dosen is Required!';
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
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Simpan",
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
                                submitDosen();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Future formEntriJadwalKuliah(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.black87.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => Container(
              height: 200,
            ));
  }
}
