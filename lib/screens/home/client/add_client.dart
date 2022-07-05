import 'dart:convert';
import 'dart:developer';

import 'package:clientmanager/screens/home/map_screen.dart';
import 'package:clientmanager/services/client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final nameCotroller = TextEditingController();
  final cityCotroller = TextEditingController();
  final phoneController = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  final items = <String>['A', 'B', 'C'];

  final cities = [
    {"city": "Casablanca", "lat": 33.5992, "lng": -7.6200},
    {"city": "El Kelaa des Srarhna", "lat": 32.0500, "lng": -7.4000},
    {"city": "Fès", "lat": 34.0433, "lng": -5.0033},
    {"city": "Tangier", "lat": 35.7767, "lng": -5.8039},
    {"city": "Marrakech", "lat": 31.6295, "lng": -7.9811},
    {"city": "Sale", "lat": 34.0500, "lng": -6.8167},
    {"city": "Rabat", "lat": 34.0253, "lng": -6.8361},
    {"city": "Meknès", "lat": 33.8833, "lng": -5.5500},
    {"city": "Kenitra", "lat": 34.2500, "lng": -6.5833},
    {"city": "Agadir", "lat": 30.4167, "lng": -9.5833},
    {"city": "Oujda-Angad", "lat": 34.6900, "lng": -1.9100},
    {"city": "Tétouan", "lat": 35.5667, "lng": -5.3667},
    {"city": "Taourirt", "lat": 34.4100, "lng": -2.8900},
    {"city": "Temara", "lat": 33.9234, "lng": -6.9076},
    {"city": "Safi", "lat": 32.2833, "lng": -9.2333},
    {"city": "Laâyoune", "lat": 27.1500, "lng": -13.2000},
    {"city": "Mohammedia", "lat": 33.6833, "lng": -7.3833},
    {"city": "Kouribga", "lat": 32.8800, "lng": -6.9000},
    {"city": "Béni Mellal", "lat": 32.3394, "lng": -6.3608},
    {"city": "El Jadid", "lat": 33.2566, "lng": -8.5025},
    {"city": "Ait Melloul", "lat": 30.3342, "lng": -9.4972},
    {"city": "Nador", "lat": 35.1667, "lng": -2.9333},
    {"city": "Taza", "lat": 34.2144, "lng": -4.0088},
    {"city": "Settat", "lat": 33.0023, "lng": -7.6198},
    {"city": "Barrechid", "lat": 33.2700, "lng": -7.5872},
    {"city": "Al Khmissat", "lat": 33.8100, "lng": -6.0600},
    {"city": "Inezgane", "lat": 30.3658, "lng": -9.5381},
    {"city": "Ksar El Kebir", "lat": 35.0000, "lng": -5.9000},
    {"city": "Larache", "lat": 35.1833, "lng": -6.1500},
    {"city": "Guelmim", "lat": 28.9833, "lng": -10.0667},
    {"city": "Khénifra", "lat": 32.9300, "lng": -5.6600},
    {"city": "Berkane", "lat": 34.9167, "lng": -2.3167},
    {"city": "Bouskoura", "lat": 33.4489, "lng": -7.6486},
    {"city": "Al Fqih Ben Çalah", "lat": 32.5000, "lng": -6.7000},
    {"city": "Oued Zem", "lat": 32.8600, "lng": -6.5600},
    {"city": "Sidi Slimane", "lat": 34.2600, "lng": -5.9300},
    {"city": "Errachidia", "lat": 31.9319, "lng": -4.4244},
    {"city": "Guercif", "lat": 34.2300, "lng": -3.3600},
    {"city": "Oulad Teïma", "lat": 30.4000, "lng": -9.2100},
    {"city": "Ad Dakhla", "lat": 23.7141, "lng": -15.9368},
    {"city": "Ben Guerir", "lat": 32.2300, "lng": -7.9500},
    {"city": "Wislane", "lat": 30.2167, "lng": -8.3833},
    {"city": "Tiflet", "lat": 33.9000, "lng": -6.3300},
    {"city": "Lqoliaa", "lat": 30.2942, "lng": -9.4544},
    {"city": "Taroudannt", "lat": 30.4711, "lng": -8.8778},
    {"city": "Sefrou", "lat": 33.8300, "lng": -4.8300},
    {"city": "Essaouira", "lat": 31.5130, "lng": -9.7687},
    {"city": "Fnidq", "lat": 35.8500, "lng": -5.3500},
    {"city": "Ait Ali", "lat": 30.1739, "lng": -9.4881},
    {"city": "Sidi Qacem", "lat": 34.2100, "lng": -5.7000},
    {"city": "Tiznit", "lat": 29.7000, "lng": -9.7269},
    {"city": "Moulay Abdallah", "lat": 33.1978, "lng": -8.5883},
    {"city": "Tan-Tan", "lat": 28.4333, "lng": -11.1000},
    {"city": "Warzat", "lat": 30.9167, "lng": -6.9167},
    {"city": "Youssoufia", "lat": 32.2500, "lng": -8.5300},
    {"city": "Sa’ada", "lat": 31.6258, "lng": -8.1028},
    {"city": "Martil", "lat": 35.6100, "lng": -5.2700},
    {"city": "Aïn Harrouda", "lat": 33.6372, "lng": -7.4483},
    {"city": "Skhirate", "lat": 33.8500, "lng": -7.0300},
    {"city": "Ouezzane", "lat": 34.8000, "lng": -5.6000},
    {"city": "Sidi Yahya Zaer", "lat": 33.8261, "lng": -6.9039},
    {"city": "Benslimane", "lat": 33.6122, "lng": -7.1211},
    {"city": "Al Hoceïma", "lat": 35.2472, "lng": -3.9322},
    {"city": "Beni Enzar", "lat": 35.2569, "lng": -2.9342},
    {"city": "M’diq", "lat": 35.6857, "lng": -5.3251},
    {"city": "Sidi Bennour", "lat": 32.6550, "lng": -8.4292},
    {"city": "Midalt", "lat": 32.6800, "lng": -4.7400},
    {"city": "Azrou", "lat": 33.4300, "lng": -5.2100},
    {"city": "Ain El Aouda", "lat": 33.8111, "lng": -6.7922},
    {"city": "Beni Yakhlef", "lat": 33.6681, "lng": -7.2514},
    {"city": "Semara", "lat": 26.7333, "lng": -11.6833},
    {"city": "Ad Darwa", "lat": 33.4167, "lng": -7.5333},
    {"city": "Al Aaroui", "lat": 35.0104, "lng": -3.0073},
    {"city": "Qasbat Tadla", "lat": 32.6000, "lng": -6.2600},
    {"city": "Boujad", "lat": 32.7600, "lng": -6.4000},
    {"city": "Jerada", "lat": 34.3100, "lng": -2.1600},
    {"city": "Chefchaouene", "lat": 35.1714, "lng": -5.2697},
    {"city": "Mrirt", "lat": 33.1667, "lng": -5.5667},
    {"city": "Sidi Mohamed Lahmar", "lat": 34.7167, "lng": -6.2667},
    {"city": "Tineghir", "lat": 31.5147, "lng": -5.5328},
    {"city": "El Aïoun", "lat": 34.5853, "lng": -2.5056},
    {"city": "Azemmour", "lat": 33.2833, "lng": -8.3333},
    {"city": "Temsia", "lat": 30.3633, "lng": -9.4144},
    {"city": "Zoumi", "lat": 34.8032, "lng": -5.3446},
    {"city": "Laouamra", "lat": 35.0656, "lng": -6.0939},
    {"city": "Zagora", "lat": 30.3316, "lng": -5.8376},
    {"city": "Ait Ourir", "lat": 31.5644, "lng": -7.6628},
    {"city": "Sidi Bibi", "lat": 30.2333, "lng": -9.5333},
    {"city": "Aziylal", "lat": 31.9600, "lng": -6.5600},
    {"city": "Sidi Yahia El Gharb", "lat": 34.3058, "lng": -6.3058},
    {"city": "Biougra", "lat": 30.2144, "lng": -9.3708},
    {"city": "Taounate", "lat": 34.5358, "lng": -4.6400},
    {"city": "Bouznika", "lat": 33.7894, "lng": -7.1597},
    {"city": "Aourir", "lat": 30.4833, "lng": -9.6333},
    {"city": "Zaïo", "lat": 34.9396, "lng": -2.7334},
    {"city": "Aguelmous", "lat": 33.1500, "lng": -5.8333},
    {"city": "El Hajeb", "lat": 33.6928, "lng": -5.3711},
    {"city": "Mnasra", "lat": 34.7667, "lng": -5.5167},
    {"city": "Mediouna", "lat": 33.4500, "lng": -7.5100},
    {"city": "Zeghanghane", "lat": 35.1575, "lng": -3.0017},
    {"city": "Imzouren", "lat": 35.1448, "lng": -3.8505},
    {"city": "Loudaya", "lat": 31.6507, "lng": -8.3021},
    {"city": "Oulad Zemam", "lat": 32.3500, "lng": -6.6333},
    {"city": "Bou Ahmed", "lat": 33.1119, "lng": -7.4058},
    {"city": "Tit Mellil", "lat": 33.5581, "lng": -7.4858},
    {"city": "Arbaoua", "lat": 34.9000, "lng": -5.9167},
    {"city": "Douar Oulad Hssine", "lat": 33.0681, "lng": -8.5108},
    {"city": "Bahharet Oulad Ayyad", "lat": 34.7703, "lng": -6.3047},
    {"city": "Mechraa Bel Ksiri", "lat": 34.5787, "lng": -5.9630},
    {"city": "Mograne", "lat": 34.4167, "lng": -6.4333},
    {"city": "Dar Ould Zidouh", "lat": 32.3167, "lng": -6.9000},
    {"city": "Asilah", "lat": 35.4667, "lng": -6.0333},
    {"city": "Demnat", "lat": 31.7311, "lng": -7.0361},
    {"city": "Lalla Mimouna", "lat": 34.8500, "lng": -6.0669},
    {"city": "Fritissa", "lat": 33.6167, "lng": -3.5500},
    {"city": "Arfoud", "lat": 31.4361, "lng": -4.2328},
    {"city": "Tameslouht", "lat": 31.5000, "lng": -8.1000},
    {"city": "Bou Arfa", "lat": 32.5310, "lng": -1.9631},
    {"city": "Sidi Smai’il", "lat": 32.8167, "lng": -8.5000},
    {"city": "Taza", "lat": 35.0639, "lng": -5.2025},
    {"city": "Souk et Tnine Jorf el Mellah", "lat": 34.4833, "lng": -5.5169},
    {"city": "Mehdya", "lat": 34.2557, "lng": -6.6745},
    {"city": "Oulad Hammou", "lat": 33.2500, "lng": -8.3347},
    {"city": "Douar Oulad Aj-jabri", "lat": 32.2567, "lng": -6.7839},
    {"city": "Aïn Taoujdat", "lat": 33.9333, "lng": -5.2167},
    {"city": "Dar Bel Hamri", "lat": 34.1889, "lng": -5.9697},
    {"city": "Chichaoua", "lat": 31.5333, "lng": -8.7667},
    {"city": "Tahla", "lat": 34.0476, "lng": -4.4289},
    {"city": "Bellaa", "lat": 30.0314, "lng": -9.5542},
    {"city": "Oulad Yaïch", "lat": 32.4167, "lng": -6.3333},
    {"city": "Ksebia", "lat": 34.2933, "lng": -6.1594},
    {"city": "Tamorot", "lat": 34.9333, "lng": -4.7833},
    {"city": "Moulay Bousselham", "lat": 34.8786, "lng": -6.2933},
    {"city": "Sabaa Aiyoun", "lat": 33.8969, "lng": -5.3611},
    {"city": "Bourdoud", "lat": 34.5922, "lng": -4.5492},
    {"city": "Aït Faska", "lat": 31.5058, "lng": -7.7161},
    {"city": "Boureït", "lat": 34.9833, "lng": -4.9167},
    {"city": "Lamzoudia", "lat": 31.5833, "lng": -8.4833},
    {"city": "Oulad Said", "lat": 32.6320, "lng": -8.8456},
    {"city": "Missour", "lat": 33.0500, "lng": -3.9908},
    {"city": "Ain Aicha", "lat": 34.4833, "lng": -4.7000},
    {"city": "Zawyat ech Cheïkh", "lat": 32.6541, "lng": -5.9214},
    {"city": "Bouknadel", "lat": 34.1245, "lng": -6.7480},
    {"city": "El Ghiate", "lat": 32.0331, "lng": -9.1625},
    {"city": "Safsaf", "lat": 34.5581, "lng": -6.0078},
    {"city": "Ouaoula", "lat": 31.8667, "lng": -6.7500},
    {"city": "Douar Olad. Salem", "lat": 32.8739, "lng": -8.8589},
    {"city": "Oulad Tayeb", "lat": 33.9598, "lng": -4.9954},
    {"city": "Echemmaia Est", "lat": 32.0705, "lng": -8.6532},
    {"city": "Oulad Barhil", "lat": 30.6388, "lng": -8.4732},
    {"city": "Douar ’Ayn Dfali", "lat": 33.9500, "lng": -4.4500},
    {"city": "Setti Fatma", "lat": 31.2256, "lng": -7.6758},
    {"city": "Skoura", "lat": 31.0672, "lng": -6.5397},
    {"city": "Douar Ouled Ayad", "lat": 32.4167, "lng": -7.1000},
    {"city": "Zawyat an Nwaçer", "lat": 33.3611, "lng": -7.6114},
    {"city": "Khenichet-sur Ouerrha", "lat": 34.4383, "lng": -5.6844},
    {"city": "Ayt Mohamed", "lat": 32.5667, "lng": -6.9833},
    {"city": "Gueznaia", "lat": 35.7200, "lng": -5.8940},
    {"city": "Oulad Hassoune", "lat": 31.6503, "lng": -7.8361},
    {"city": "Bni Frassen", "lat": 34.3819, "lng": -4.3761},
    {"city": "Tifariti", "lat": 26.0928, "lng": -10.6089},
    {"city": "Zawit Al Bour", "lat": 30.6748, "lng": -8.1742}
  ];

  bool isPass = true;
  String? value;
  String? city;
  Map<String, dynamic> coordinates = {"lat": null, "lng": null};
  late List<DropdownMenuItem<String>> _menuItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // city = cities[0]['city'];

    List dataList = cities;
    _menuItems = List.generate(
      dataList.length,
      (i) => DropdownMenuItem(
        value: cities[i]["city"].toString(),
        child: Text("${cities[i]['city']}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_circle_left_rounded,
            color: Colors.grey[700],
            size: 32,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Container(
              padding: const EdgeInsets.only(top: 20, left: 17, right: 17),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    "Add New Client",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameCotroller,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter a name";
                      }
                      if (val.length <= 3) {
                        return "Name must be atleast 3 caracters";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "name",
                      label: Text("name"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "phone number",
                      label: Text("phone number"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: city,
                    hint: const Text("choose city"),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    elevation: 16,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      var selectedCity = cities
                          .where((element) => element['city'] == newValue);
                      coordinates = {
                        "lat": selectedCity.first['lat'],
                        "lng": selectedCity.first['lng']
                      };
                      setState(() {
                        city = newValue!;
                      });
                    },
                    items: _menuItems,
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: value,
                    hint: const Text("choose type"),
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    elevation: 16,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        value = newValue!;
                      });
                    },
                    items: <String>['CLASS A', 'CLASS B', 'CLASS C']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          Map res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MapScreen(coordinates: coordinates)),
                          );
                          print(res.runtimeType);
                        },
                        icon: const Icon(Icons.pin_drop),
                        color: Colors.blue[700],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // await FirebaseAuth.instance.currentUser!
                      //     .updateDisplayName("Abdelwahd");
                      if (value != null &&
                          city != null &&
                          coordinates['lat'] != null &&
                          _keyForm.currentState!.validate()) {
                        final res = await ClientService().createNewClient(
                            nameCotroller.text,
                            phoneController.text,
                            city!,
                            coordinates,
                            value!,
                            FirebaseAuth.instance.currentUser!.displayName!,
                            FirebaseAuth.instance.currentUser!.uid);

                        if (res != null) {
                          Navigator.of(context)
                              .pop("Client was successfully added");
                        }
                      }
                    },
                    child: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[800],
                        minimumSize: const Size.fromHeight(50)),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
