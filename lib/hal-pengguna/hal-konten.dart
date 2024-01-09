// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mad_uas_app/hal-pengguna/hal-layout.dart';

//--------------------------- AREA KONTEN BERANDA ------------------------------
class HalBerandaPengguna extends StatefulWidget {
  const HalBerandaPengguna({super.key});
  @override
  State<HalBerandaPengguna> createState() => _HalBerandaPenggunaState();
}

class _HalBerandaPenggunaState extends State<HalBerandaPengguna> {
//membuat variabel session
  var session_username;
  var session_password;
  var session_hakakses;

  List dataHewan = [];
  List dataMakanan = [];
  List dataPenitipan = [];
  @override
  void initState() {
    super.initState();
    GetStorage.init();
    final box = GetStorage();
    setState(() {
      session_username = box.read('simpanUsernameUser');
      session_password = box.read('simpanPasswordUser');
    });
    ambilData();
  }

  Future ambilData() async {
    try {
      // ! Get Data Hewan
      final getDataHewan =
          await http.get(Uri.parse("http://localhost:8000/api/hewans"));
      if (getDataHewan.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(getDataHewan.body);
        if (response["success"]) {
          List<dynamic> hewanData = response["data"];
          setState(() {
            dataHewan = List<Map<String, dynamic>>.from(hewanData);
          });
        } else {
          print("API response indicates failure: ${response["message"]}");
        }
      } else {
        print("Failed to load data. Status code: ${getDataHewan.statusCode}");
      }

      // ! Get Data Makanan
      final getDataMakanan =
          await http.get(Uri.parse("http://localhost:8000/api/makanans"));

      if (getDataMakanan.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(getDataMakanan.body);
        if (response["success"]) {
          List<dynamic> makananData = response["data"];
          setState(() {
            dataMakanan = List<Map<String, dynamic>>.from(makananData);
          });
        } else {
          print("API response indicates failure: ${response["message"]}");
        }
      } else {
        print("Failed to load data. Status code: ${getDataMakanan.statusCode}");
      }

      // ! Get Data Penitipans
      final getDataPenitipan =
          await http.get(Uri.parse("http://localhost:8000/api/penitipans"));

      if (getDataPenitipan.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(getDataPenitipan.body);
        if (response["success"]) {
          List<dynamic> penitipanData = response["data"];
          setState(() {
            dataPenitipan = List<Map<String, dynamic>>.from(penitipanData);
          });
        } else {
          print("API response indicates failure: ${response["message"]}");
        }
      } else {
        print("Failed to load data. Status code: ${getDataHewan.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang .. ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Halaman pengguna kamu.",
                        style: TextStyle(fontSize: 15, color: Colors.grey[900]),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.person_pin,
                        size: 75,
                        color: Colors.grey[900],
                      ),
                      Text('($session_username)')
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
              const Text("Data Hewan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: dataHewan.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    try {
                      return Container(
                        width: 90,
                        margin: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 100,
                          backgroundImage: NetworkImage(
                            '${dataHewan[index]['foto']}',
                          ),
                        ),
                      );
                    } catch (e) {
                      // Handle the exception (e.g., log the error, display a placeholder image)
                      print('Error loading image: $e');
                      return Container(
                        width: 90,
                        margin: const EdgeInsets.all(5),
                        color: Colors.red, // Placeholder color
                        child: const Center(
                          child: Text(
                            'Error loading image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Data Makanan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: dataMakanan.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          // Background Image
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                '${dataMakanan[index]['foto_makanan']}', // Replace with your image URL
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Text Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                color: Colors.black.withOpacity(
                                    0.7), // Adjust the opacity as needed
                              ),
                              child: Text(
                                '${dataMakanan[index]['nama']}',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Data Penitipan Hewan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dataPenitipan.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 100,
                      child: TimelineTile(
                        beforeLineStyle: const LineStyle(color: Colors.grey),
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.teal,
                            iconStyle: IconStyle(
                                iconData: Icons.done, color: Colors.white)),
                        endChild: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.teal[500]),
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${dataPenitipan[index]['tanggal']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18)),
                              Text('${dataPenitipan[index]['nama_pemilik']}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('${dataPenitipan[index]['hewan']['nama']}',
                                  style: const TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

// ? FORM EDITING
// !------------------------ AREA PENITIPAN ---------------------------
class HalPenitipan extends StatefulWidget {
  const HalPenitipan({super.key});
  @override
  State<HalPenitipan> createState() => _HalPenitipanState();
}

class _HalPenitipanState extends State<HalPenitipan> {
  List dataPenitipan = [];
  List searchPenitipan = [];
  final pencarian_data = TextEditingController();

  Future ambilDataJadwalKuliah() async {
    // ! Get Data Penitipans
    try {
      final getPenitipan =
          await http.get(Uri.parse("http://localhost:8000/api/penitipans"));
      if (getPenitipan.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(getPenitipan.body);
        List<dynamic> penitipanData = response["data"];
        setState(() {
          dataPenitipan = List<Map<String, dynamic>>.from(penitipanData);
          searchPenitipan = List<Map<String, dynamic>>.from(penitipanData);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    ambilDataJadwalKuliah();
  }

  @override
  void dispose() {
    pencarian_data.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      searchPenitipan = text.isEmpty
          ? dataPenitipan
          : dataPenitipan
              .where((dataPenitipan) =>
                  dataPenitipan['tanggal']
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  dataPenitipan['nama_pemilik']
                      .toLowerCase()
                      .contains(text.toLowerCase()) ||
                  dataPenitipan['hewan']['nama']
                      .toLowerCase()
                      .contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: pencarian_data,
          decoration: InputDecoration(
            hintText: 'Pencarian data ...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
          onChanged: _onSearchTextChanged,
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'No.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    'Nama Pemilik',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Tanggal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Hewan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Opsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(searchPenitipan.length, (index) {
                final dataPenitipan = searchPenitipan[index];
                return DataRow(
                  cells: [
                    DataCell(Text("${index + 1}. ")),
                    DataCell(Text('${dataPenitipan['nama_pemilik']}')),
                    DataCell(Text(dataPenitipan['tanggal'])),
                    DataCell(Text(dataPenitipan['hewan']['nama'])),
                    DataCell(ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title: "Hapus Data",
                          desc: "Kamu yakin ingin menghapus data ? ",
                          btnCancelText: "Kembali",
                          btnOkText: "Oke, Lanjutkan",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            hapusDataPenitipan(dataPenitipan['id']);
                          },
                        ).show();
                      },
                    )),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    ]);
  }

  Future hapusDataPenitipan(String id) async {
    final hapus_penitipan = await http
        .delete(Uri.parse("http://localhost:8000/api/penitipans/$id"));
    final status_hapus_penitipan = jsonDecode(hapus_penitipan.body);
    print(status_hapus_penitipan["success"]);
    if (status_hapus_penitipan["success"] == true) {
      AnimatedSnackBar.material(
        'Hapus berhasil.',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HalLayout(halamanindex: 1)));
    } else {
      AnimatedSnackBar.material(
        'Hapus gagal.',
        type: AnimatedSnackBarType.warning,
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }
}

// !------------------------- AREA HEWAN ------------------------
class HalHewan extends StatefulWidget {
  const HalHewan({super.key});
  @override
  State<HalHewan> createState() => _HalHewanState();
}

class _HalHewanState extends State<HalHewan> {
//membuat variabel array untuk menampung data dari tabel mahasiswa
  List dataHewan = [];
//membuat perintah untuk mengambil data mahasiswa dari database menggunakan RestFul API
  Future ambilDataHewan() async {
    final getHewan =
        await http.get(Uri.parse("http://localhost:8000/api/hewans"));
    if (getHewan.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(getHewan.body);
      List<dynamic> hewanData = response["data"];
      setState(() {
        dataHewan = List<Map<String, dynamic>>.from(hewanData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ambilDataHewan();
  }

  Future<void> hapusDataHewan(id) async {
    final response =
        await http.delete(Uri.parse("http://localhost:8000/api/hewans/$id"));
    final statusHapusHewan = jsonDecode(response.body);

    if (statusHapusHewan["success"] == true) {
      AnimatedSnackBar.material(
        'Hapus berhasil.',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HalLayout(halamanindex: 1),
        ),
      );
    } else {
      AnimatedSnackBar.material(
        'Hapus gagal.',
        type: AnimatedSnackBarType.warning,
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: dataHewan.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      var id = dataHewan[index]['id'];
                      hapusDataHewan(id);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: (BuildContext context) {
                      formEntriHewan(
                          dataHewan[index]['id'],
                          dataHewan[index]['nama'],
                          dataHewan[index]['jenis_kelamin'],
                          dataHewan[index]['tanggal_lahir'],
                          dataHewan[index]['foto']);
                    },
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Ubah',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onTap: () {},
                leading: Text("${index + 1}. "),
                title: Text(
                  '${dataHewan[index]['nama']}',
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  '${dataHewan[index]['tanggal_lahir']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// !FORM EDIT HEWAN
  final _formKey = GlobalKey<FormState>();
  Future formEntriHewan(
      inputId, inputNama, inputJenisKelamin, inputTanggalLahir, inputFoto) {
    var nama = TextEditingController();
    var tanggalLahir = TextEditingController();
    var foto = TextEditingController();
    var jenis_kelamin;

    List<String> opsi_jenisKelamin = [
      'Laki-Laki',
      'Perempuan',
    ];

    setState(() {
      nama = TextEditingController(text: inputNama);
      tanggalLahir = TextEditingController(text: inputTanggalLahir);
      foto = TextEditingController(text: inputFoto);
      jenis_kelamin = inputJenisKelamin.toString();
    });
    Future simpanHewan() async {
      try {
        return await http.put(
          Uri.parse("http://localhost:8000/api/hewans/$inputId"),
          body: {
            "id": inputId.toString(),
            "nama": nama.text,
            "tanggal_lahir": tanggalLahir.text,
            "foto": foto.text,
            "jenis_kelamin": jenis_kelamin.toString(),
          },
        ).then((value) {
          print(value);
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
                            'Form Edit Hewan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          centerTitle: true,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          iconTheme: const IconThemeData(color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nama,
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
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: jenis_kelamin,
                          onChanged: (value) {
                            setState(() {
                              jenis_kelamin = value;
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
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: foto,
                          decoration: const InputDecoration(
                              label: Text('Foto'),
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
}

// !------------------------- AREA MAKANAN ----------------------------
class HalMakanan extends StatefulWidget {
  const HalMakanan({super.key});
  @override
  State<HalMakanan> createState() => _HalMakananState();
}

class _HalMakananState extends State<HalMakanan> {
  List<Map<String, dynamic>> data_makanan = [];
  Future<void> ambilDataMakanan() async {
    final response =
        await http.get(Uri.parse("http://localhost:8000/api/makanans"));
    if (response.statusCode == 200) {
      setState(() {
        data_makanan = List.from(jsonDecode(response.body)['data']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ambilDataMakanan();
  }

  Future hapusDataMakanan(String id) async {
    final hapus_makanan =
        await http.delete(Uri.parse("http://localhost:8000/api/makanans/$id"));
    final status_hapus_dosen = jsonDecode(hapus_makanan.body);
    print(status_hapus_dosen["success"]);
    if (status_hapus_dosen["success"] == true) {
      AnimatedSnackBar.material(
        'Hapus berhasil.',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 1),
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HalLayout(halamanindex: 3)));
    } else {
      AnimatedSnackBar.material(
        'Hapus gagal.',
        type: AnimatedSnackBarType.warning,
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: data_makanan.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      var id = data_makanan[index]['id'].toString();
                      hapusDataMakanan(id);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: (BuildContext context) {
                      var id = data_makanan[index]['id'].toString();
                      formEntriMakanan(
                        id,
                        data_makanan[index]['nama'],
                        data_makanan[index]['jenis'],
                        data_makanan[index]['stock'].toString(),
                        data_makanan[index]['foto_makanan'],
                      );
                    },
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Ubah',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onTap: () {},
                leading: Text("${index + 1}. "),
                title: Text(
                  '${data_makanan[index]['nama']}',
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  '${data_makanan[index]['jenis']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  Future formEntriMakanan(
      inputId, inputNama, inputJenis, inputStock, inputFotoMakanan) {
    var nama = TextEditingController();
    var jenis = TextEditingController();
    var stock = TextEditingController();
    var fotoMakanan = TextEditingController();
    setState(() {
      nama = TextEditingController(text: inputNama);
      jenis = TextEditingController(text: inputJenis);
      stock = TextEditingController(text: inputStock);
      fotoMakanan = TextEditingController(text: inputFotoMakanan);
    });
    Future simpanMakanan() async {
      try {
        return await http.put(
          Uri.parse("http://localhost:8000/api/makanans/$inputId"),
          body: {
            "id": inputId,
            "nama": nama.text,
            "jenis": jenis.text,
            "stock": stock.text,
            "foto_makanan": fotoMakanan.text,
          },
        ).then((value) {
          var data = jsonDecode(value.body);
          print(value.body);
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
                          'Form Ubah Makanan',
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
                            label: Text('Jenis'),
                            hintText: 'Jenis ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jenis is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: stock,
                        decoration: const InputDecoration(
                            label: Text('Stock'),
                            hintText: 'Stock ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jenis is Required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: fotoMakanan,
                        decoration: const InputDecoration(
                            label: Text('Foto Makanan'),
                            hintText: 'Foto Makanan ...',
                            fillColor: Colors.white,
                            filled: true),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Foto Makanan is Required!';
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
}
