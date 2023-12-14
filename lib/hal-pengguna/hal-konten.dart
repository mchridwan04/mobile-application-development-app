import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final data = [
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten",
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten",
];

//Beranda
class HalBerandaPengguna extends StatelessWidget {
  const HalBerandaPengguna({super.key});
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
                  const Icon(
                    Icons.person_pin,
                    size: 75,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text("Data Mahasiswa",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 90,
                          margin: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 100,
                            child: Text(
                              data[index],
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ), //Text
                          ),
                        );
                      })),
              const SizedBox(height: 15),
              const Text(
                "Data Dosen",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: 200,
                  child: ListView.builder(
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.all(8),
                          child: Center(child: Text(data[index])),
                        );
                      })),
              const SizedBox(height: 15),
              const Text(
                "Riwayat Jadwal Kuliah",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
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
                          margin: const EdgeInsets.all(25),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(color: Colors.teal[500]),
                          child: Text(data[index]),
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

class HalJadwalKuliah extends StatefulWidget {
  const HalJadwalKuliah({super.key});
  @override
  State<HalJadwalKuliah> createState() => _HalJadwalKuliahState();
}

class _HalJadwalKuliahState extends State<HalJadwalKuliah> {
  List<dynamic> data = [
    {"Name": "John", "Age": 28, "Role": "Senior Supervisor", "checked": false},
    {"Name": "Jane", "Age": 32, "Role": "Administrator", "checked": false},
    {"Name": "Mary", "Age": 28, "Role": "Manager", "checked": false},
    {"Name": "Kumar", "Age": 32, "Role": "Administrator", "checked": false},
  ];
  List<dynamic> filteredData = [];
  final searchController = TextEditingController();
  @override
  void initState() {
    filteredData = data;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? data
          : data
              .where((item) =>
                  item['Name'].toLowerCase().contains(text.toLowerCase()) ||
                  item['Role'].toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Pencarian ...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
          onChanged: _onSearchTextChanged,
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: List.generate(filteredData.length, (index) {
            final item = filteredData[index];
            return DataRow(
              cells: [
                DataCell(Text(item['Name'])),
                DataCell(Text(item['Age'].toString())),
                DataCell(Text(item['Role'])),
              ],
            );
          }),
        ),
      ),
    ]);
  }
}

class HalRekapMahasiswa extends StatelessWidget {
  const HalRekapMahasiswa({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Slidable(
// Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),
// The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
// A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),
// A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),
// All actions are defined in the children parameter.
                children: [
// A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.share,
                    label: 'Share',
                  ),
                ],
              ),
// The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
// An action can be bigger than the others.
                    flex: 2,
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                ],
              ),
// The child of the Slidable is what the user sees when the
// component is not dragged.
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onTap: () {},
                leading: Text("${index + 1}. "),
                title: Text(
                  "Data 1",
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  "Data 2",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HalRekapDosen extends StatefulWidget {
  const HalRekapDosen({super.key});
  @override
  State<HalRekapDosen> createState() => _HalRekapDosenState();
}

class _HalRekapDosenState extends State<HalRekapDosen> {
  final _formKey = GlobalKey<FormState>();
//mendefinisikan field/kolom inputan
  var username = TextEditingController();
  var password = TextEditingController();
  var password_konfirmasi = TextEditingController();
  var foto_user = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Slidable(
// Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),
// The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
// A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),
// A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),
// All actions are defined in the children parameter.
                children: [
// A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.share,
                    label: 'Share',
                  ),
                ],
              ),
// The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
// An action can be bigger than the others.
                    flex: 2,
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    onPressed: (BuildContext context) {},
                    backgroundColor: Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                ],
              ),
// The child of the Slidable is what the user sees when the
// component is not dragged.
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onTap: () {},
                leading: Text("${index + 1}. "),
                title: Text(
                  "Data 1",
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  "Data 2",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
