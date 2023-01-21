import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:seletor/celula_dia.dart';
import 'package:seletor/celula_hora.dart';
import 'package:seletor/input_field.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import 'zoombuttons_plugin_option.dart';

FilteringTextInputFormatter allValues =
    FilteringTextInputFormatter.allow(RegExp('.*'));

final _scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(const MyApp());
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const MyHomePage(),
    );
  }
}

final List<int> diasPossiveis = [1, 2, 3, 4, 5, 6, 7];
final List<String> horariosPossiveis = [
  "11:00",
  "12:00",
  "13:00",
  "14:00",
  "15:00",
  "16:00",
  "17:00",
  "18:00",
  "19:00",
  "20:00"
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DateTime> listaDatas = [];
  int currentSelecteddia = -1;
  int currentSelectedhora = -1;
  final maxHoras = 3;
  int currentHoras = 1;
  final maxPessoas = 6;
  int currentPessoas = 1;
  final precomultiplicador = 120.00;
  final TextEditingController _emailHolder = TextEditingController();
  double rotation = 0.0;
  bool isChecked = false;

  List<DateTime> retornarDatas() {
    final hoje = DateTime.now();
    final DateTime endDate = hoje.add(const Duration(days: 40));
    List<DateTime> result = [];
    var date = hoje.add(const Duration(days: 1));
    while (daysBetween(date, endDate) != 0) {
      if (diasPossiveis.contains(date.weekday)) {
        result.add(date);
      }
      date = date.add(const Duration(days: 1));
    }
    return result;
  }

  void _counterButtonPress(int valor, int tipo) {
    if (tipo == 1) {
      if ((currentHoras + valor) > 0 && (currentHoras + valor) <= maxHoras) {
        setState(() {
          currentHoras += valor;
        });
        _showBottomSheet();
      }
    } else {
      if ((currentPessoas + valor) > 0 &&
          (currentPessoas + valor) <= maxPessoas) {
        setState(() {
          currentPessoas += valor;
        });
        _showBottomSheet();
      }
    }
  }

  void _showBottomSheet() {
    if (currentSelectedhora > -1 && currentSelecteddia > -1) {
      _scaffoldKey.currentState?.showBottomSheet((context) {
        return Container(
          height: 70.0,
          color: Colors.teal[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking Total: R\$ ${(precomultiplicador * currentPessoas * currentHoras).toStringAsFixed(2)}"
                      .replaceAll('.', ','),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: TextButton(
                        onPressed: () => print("oi"),
                        child: const Text(
                          "Agendar",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        )),
                  ),
                )
              ],
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listaDatas = retornarDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Booking"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                shape: const CircleBorder(),
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 4,
                    child: Image.asset(
                      'assets/images/dog.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text("Pedro Silva",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.verified)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: const [
                            Icon(Icons.star),
                            Text("5.0 (123)")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Icon(Icons.location_on),
                            Text("Hong Kong")
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text("Bandeiras"),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Conheça Pedro",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Host desde out/19",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Um texto grande aqui de descrição do host e make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Onde nos encontraremos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 250,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(48.8566, 2.3522),
                    zoom: 12,
                    plugins: [
                      MapButtonsPlugin(),
                    ],
                  ),
                  layers: [
                    MapButtonsPluginOption(
                      zoomInColor: Colors.blue,
                      zoomInIcon: Icons.gps_not_fixed,
                      zoomInColorIcon: Colors.white,
                      zoomOutColor: Colors.blue,
                      zoomOutIcon: Icons.location_on,
                      zoomOutColorIcon: Colors.white,
                      initLocation: LatLng(48.8566, 2.3522),
                      mini: true,
                      padding: 10,
                      alignment: Alignment.bottomRight,
                    ),
                    MarkerLayerOptions(markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(48.8566, 2.3522),
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          size: 50,
                          color: Colors.red,
                        ),
                        anchorPos: AnchorPos.align(AnchorAlign.center),
                      ),
                    ])
                  ],
                  children: <Widget>[
                    TileLayerWidget(
                      options: TileLayerOptions(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "O que faremos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Um texto grande aqui de descrição do host e make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "A partir de R\$ ${(precomultiplicador).toStringAsFixed(2)}"
                        .replaceAll('.', ','),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(" /pessoa e hora ")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("Horas",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _counterButtonPress(-1, 1),
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            currentHoras.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'OpenSans'),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () => _counterButtonPress(1, 1),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Pessoas",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _counterButtonPress(-1, 2),
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            currentPessoas.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'OpenSans'),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () => _counterButtonPress(1, 2),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Descontos para grupos",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Text(
                          "3-10 pessoas",
                          style: TextStyle(fontSize: 14),
                        ),
                        Spacer(),
                        Text(
                          "10% de desconto",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Escolher entre datas disponíveis",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: listaDatas.length,
                  itemBuilder: (context, i) {
                    return CelulaDia(
                        dia: listaDatas[i],
                        isSelected: currentSelecteddia == i,
                        onSelect: () {
                          setState(() {
                            currentSelecteddia = i;
                            _showBottomSheet();
                          });
                        });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 2.3),
                  itemCount: horariosPossiveis.length,
                  itemBuilder: (context, i) {
                    return CelulaHora(
                        hora: horariosPossiveis[i],
                        isSelected: currentSelectedhora == i,
                        onSelect: () {
                          setState(() {
                            currentSelectedhora = i;
                            _showBottomSheet();
                          });
                        });
                  }),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Observações",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              BuildInputField(
                mascara: allValues,
                tipoTeclado: TextInputType.emailAddress,
                width: 350,
                controle: _emailHolder,
                clear: true,
                textLines : null,
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
