// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mad_uas_app/hal-pengguna/hal-konten.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mad_uas_app/hal-utama.dart';

class HalLayout extends StatefulWidget {
  HalLayout({super.key, required this.halamanindex});
  int halamanindex;
  @override
  State<HalLayout> createState() => _HalLayoutState();
}

class _HalLayoutState extends State<HalLayout> {
//membuat variabel untuk session
  var sessionUsername;
  var sessionPassword;
  // var session_hakakses;
  @override
  void initState() {
    super.initState();
    ambilDataHewan();
    GetStorage.init();
    final box = GetStorage();
    setState(() {
      sessionUsername = box.read('simpanUsernameUser');
      sessionPassword = box.read('simpanPasswordUser');
    });
  }

  final halaman = [
    const HalBerandaPengguna(),
    const HalHewan(),
    const HalPenitipan(),
    const HalMakanan(),
  ];
  List menuAplikasi = [
    'Beranda',
    'Halaman Hewan',
    'Halaman Penitipan',
    'Halaman Makanan',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          menuAplikasi[widget.halamanindex],
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: TextButton.icon(
          onPressed: () {
            formKonfirmasiKeluar(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
          label: const Text(
            'Keluar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leadingWidth: 100,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          type: BottomNavigationBarType.shifting,
          fixedColor: Colors.black, //memberi warna jika menu di pilih
          iconSize: 30,
          currentIndex: widget.halamanindex,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
          onTap: (value) {
            widget.halamanindex = value;
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
                label: 'Data Hewan'),
            BottomNavigationBarItem(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.people_alt_rounded),
                label: 'Data Penitipan'),
            BottomNavigationBarItem(
                backgroundColor: Colors.teal,
                icon: Icon(Icons.people_alt_rounded),
                label: 'Data Makanan'),
          ]),
      body: IndexedStack(
        index: widget.halamanindex,
        children: halaman,
      ),
      floatingActionButton: SpeedDial(
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
              label: 'Entri Hewan',
              labelStyle: const TextStyle(fontSize: 12.0),
              onTap: () => formEntriHewan(context)),
          SpeedDialChild(
              child: const Icon(Icons.people_alt_rounded),
              backgroundColor: Colors.white,
              label: 'Entri Makanan',
              labelStyle: const TextStyle(fontSize: 12.0),
              onTap: () => formEntriMakanan(context)),
          SpeedDialChild(
            child: const Icon(Icons.content_paste_search_rounded),
            backgroundColor: Colors.white,
            label: 'Entri Data Penitipan',
            labelStyle: const TextStyle(fontSize: 12.0),
            onTap: () => formEntriPenitipan(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.refresh_rounded),
            backgroundColor: Colors.white,
            label: 'Refresh Halaman',
            labelStyle: const TextStyle(fontSize: 12.0),
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 0))),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
// !------------------------------ AREA FORM TAMBAH -------------------------------
// !------------------------------ FORM TAMABAH HEWAN ---------------------------------
  Future formEntriHewan(BuildContext context) {
    var nama = TextEditingController();
    var tanggalLahir = TextEditingController();
    var jenisKelamin;
    var foto = TextEditingController();
    List opsi_jenisKelamin = [
      'Laki-Laki',
      'Perempuan',
    ];

    Future simpanHewan() async {
      try {
        return await http.post(
          Uri.parse("http://localhost:8000/api/hewans"),
          body: {
            "nama": nama.text,
            "tanggal_lahir": tanggalLahir.text,
            "jenis_kelamin": jenisKelamin,
            "foto": foto.text,
          },
        ).then((value) {
          var data = jsonDecode(value.body);
          print(data["success"]);
          if (data["success"] == true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 1)));
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

//FORM ENTRI
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
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: const Text(
                            'Form Entri Hewan',
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
                        TextFormField(
                          controller: nama,
                          decoration: const InputDecoration(
                              label: Text('Nama'),
                              hintText: "Tulis Nama ...",
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
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: jenisKelamin,
                          onChanged: (value) {
                            setState(() {
                              jenisKelamin = value;
                            });
                          },
                          items: opsi_jenisKelamin.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            label: Text('Jenis Kelamin',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            hintText: 'Pilih Jenis Kelamin',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jenis Kelamin is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: tanggalLahir,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2050));
                            if (pickedDate != null) {
                              tanggalLahir.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            }
                          },
                          decoration: const InputDecoration(
                              label: Text('Tanggal Lahir',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: foto,
                          decoration: const InputDecoration(
                              label: Text('Link Foto'),
                              hintText: "Tulis Link Foto ...",
                              fillColor: Colors.white,
                              filled: true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Link is Required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                              if (_formKey.currentState!.validate()) {
                                simpanHewan();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

// !---------------------------- FORM TAMBAH MAKANAN ------------------------------
  Future formEntriMakanan(BuildContext context) {
//mendefinisikan field/kolom inputan dosen
    var nama = TextEditingController();
    var jenis = TextEditingController();
    var stock = TextEditingController();
    var foto_makanan = TextEditingController();
//perintah untuk menyimpan data dosen
    Future simpanMakanan() async {
      try {
        return await http.post(
          Uri.parse("http://localhost:8000/api/makanans"),
          body: {
            "nama": nama.text,
            "jenis": jenis.text,
            "stock": stock.text,
            "foto_makanan": foto_makanan.text,
          },
        ).then((value) {
//menampilkan pesan setelah menambahkan data ke database, kamu dapat menambah pesan atau notifikasi lain di sini
          var data = jsonDecode(value.body);
          print(data["success"]);
          if (data["success"] == true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 3)));
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

//FORM ENTRI
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
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        title: const Text(
                          'Tambah Data Makanan',
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
                      TextFormField(
                        controller: nama,
                        decoration: const InputDecoration(
                            label: Text('Nama Makanan'),
                            hintText: "Tulis Nama Makanan ...",
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama Makanan is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: jenis,
                        decoration: const InputDecoration(
                            label: Text('Jenis Makanan'),
                            hintText: 'Tulis Jenis Makanan ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jenis Makanan is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: stock,
                        decoration: const InputDecoration(
                            label: Text('Stock'),
                            hintText: 'Tulis Jumlah Stock ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah Stock is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: foto_makanan,
                        decoration: const InputDecoration(
                            label: Text('Foto'),
                            hintText: 'Link Foto Makanan ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Link Foto is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              simpanMakanan();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

// !------------------------- FORM TAMBAH DATA PENITIPAN ------------------------
  List opsi_hewan = [];

  Future ambilDataHewan() async {
    final tampil_hewan =
        await http.get(Uri.parse("http://localhost:8000/api/hewans"));
    if (tampil_hewan.statusCode == 200) {
      final ambil_data_hewan = jsonDecode(tampil_hewan.body)['data'] as List;

      for (var data_hewan in ambil_data_hewan) {
        opsi_hewan.add('${data_hewan['id']} - ${data_hewan['nama']}');
      }

      return opsi_hewan;
    }
  }

  Future formEntriPenitipan(BuildContext context) {
    var namaPemilik = TextEditingController();
    var tanggal = TextEditingController();
    var hewan_id;
    Future simpanPenitipan() async {
      try {
        return await http.post(
          Uri.parse("http://localhost:8000/api/penitipans"),
          body: {
            "nama_pemilik": namaPemilik.text,
            "tanggal": tanggal.text,
            "hewan_id": hewan_id,
          },
        ).then((value) {
          var data = jsonDecode(value.body);
          print(data["success"]);
          if (data["success"] == true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HalLayout(halamanindex: 2)));
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
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        title: const Text(
                          'Form Entri Jadwal Kuliah',
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
                      TextFormField(
                        controller: namaPemilik,
                        decoration: const InputDecoration(
                            label: Text('Nama Pemilik'),
                            hintText: "Tulis Nama Pemilik ...",
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama Pemilik is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: tanggal,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));
                          if (pickedDate != null) {
                            tanggal.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text('Tanggal Lahir',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: hewan_id,
                        onChanged: (value) {
                          setState(() {
                            hewan_id = value;
                          });
                        },
                        items: opsi_hewan.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          label: Text('Nama Hewan',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          hintText: ' - Pilih Hewan -',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Hewan is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                            if (_formKey.currentState!.validate()) {
                              simpanPenitipan();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

// !-------------- FORM KONFIRMASI LOGOUT / KELUAR APLIKASI --------------------
  Future formKonfirmasiKeluar(BuildContext context) {
//perintah untuk menjalankan fungsi ambil data session dari storage
    Future prosesKeluar() async {
      GetStorage.init();
      final box = GetStorage();
      box.remove('simpanUsernameUser');
      box.remove('simpanPasswordUser');
      // box.remove('simpan_hakakses_pengguna');
      AnimatedSnackBar.material(
        'Keluar berhasil',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HalUtama()));
      });
    }

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
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppBar(
                        title: const Text(
                          'Profil Akun',
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
                      Icon(
                        Icons.person_pin,
                        size: 200,
                        color: Colors.grey[900],
                      ),
                      const SizedBox(height: 20),
                      Text('Username : $sessionUsername'),
                      const SizedBox(height: 20),
                      Text('Password : $sessionPassword'),
                      const SizedBox(height: 20),
                      // Text('Hak Akses : $session_hakakses'),
                      // const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          color: Colors.orange[900],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "K e l u a r",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
//proses keluar atau logout
                            prosesKeluar();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
