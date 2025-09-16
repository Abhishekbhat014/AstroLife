import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sweph/sweph.dart';

Future<String> prepareEphemerisFiles() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final epheDir = Directory("${appDocDir.path}/ephe");

  if (!await epheDir.exists()) {
    await epheDir.create(recursive: true);
  }

  final files = ["de200.eph"];

  for (var file in files) {
    final byteData = await rootBundle.load("assets/ephe/$file");
    final outFile = File("${epheDir.path}/$file");
    if (!await outFile.exists()) {
      await outFile.writeAsBytes(byteData.buffer.asUint8List());
    }
  }

  return epheDir.path;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ephePath = await prepareEphemerisFiles();

  await Sweph.init(modulePath: "sweph", epheFilesPath: ephePath);

  Sweph.swe_set_sid_mode(SiderealMode.SE_SIDM_LAHIRI);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astro Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const AstroCalculator(),
    );
  }
}

class AstroCalculator extends StatefulWidget {
  const AstroCalculator({super.key});

  @override
  State<AstroCalculator> createState() => _AstroCalculatorState();
}

class _AstroCalculatorState extends State<AstroCalculator> {
  final _dobController = TextEditingController(text: "2005-01-03");
  final _tobController = TextEditingController(text: "16:30");
  String result = "";

  Future<void> calculate() async {
    try {
      final dobParts = _dobController.text.split("-");
      int year = int.parse(dobParts[0]);
      int month = int.parse(dobParts[1]);
      int day = int.parse(dobParts[2]);

      final tobParts = _tobController.text.split(":");
      int hh = int.parse(tobParts[0]);
      int mm = int.parse(tobParts[1]);

      double hourIST = hh + mm / 60.0;
      double hourUTC = hourIST - 5.5;

      if (hourUTC < 0) {
        hourUTC += 24;
        day -= 1;
      } else if (hourUTC >= 24) {
        hourUTC -= 24;
        day += 1;
      }

      double jd = Sweph.swe_julday(
        year,
        month,
        day,
        hourUTC,
        CalendarType.SE_GREG_CAL,
      );

      var moon = Sweph.swe_calc_ut(
        jd,
        HeavenlyBody.SE_MOON,
        SwephFlag.SEFLG_SIDEREAL,
      );

      double lon = moon.longitude;

      List<String> rashis = [
        "Mesha",
        "Vrishabha",
        "Mithuna",
        "Karka",
        "Simha",
        "Kanya",
        "Tula",
        "Vrischika",
        "Dhanu",
        "Makara",
        "Kumbha",
        "Meena",
      ];
      int rashiIndex = (lon ~/ 30) % 12;
      String rashi = rashis[rashiIndex];

      List<String> nakshatras = [
        "Ashwini",
        "Bharani",
        "Krittika",
        "Rohini",
        "Mrigashira",
        "Ardra",
        "Punarvasu",
        "Pushya",
        "Ashlesha",
        "Magha",
        "Purva Phalguni",
        "Uttara Phalguni",
        "Hasta",
        "Chitra",
        "Swati",
        "Vishakha",
        "Anuradha",
        "Jyeshtha",
        "Mula",
        "Purva Ashadha",
        "Uttara Ashadha",
        "Shravana",
        "Dhanishta",
        "Shatabhisha",
        "Purva Bhadrapada",
        "Uttara Bhadrapada",
        "Revati",
      ];
      int nakIndex = (lon ~/ (360 / 27)) % 27;
      String nakshatra = nakshatras[nakIndex];

      double nakDegree = lon % (360 / 27);
      int pada = (nakDegree ~/ (360 / 108)) + 1;

      setState(() {
        result = """
DOB: ${_dobController.text} ${_tobController.text} (IST)
Moon Longitude: ${lon.toStringAsFixed(2)}°
Rashi: $rashi
Nakshatra: $nakshatra
Pada: $pada
""";
      });
    } catch (e) {
      setState(() => result = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rashi & Nakshatra Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _dobController,
                      decoration: const InputDecoration(
                        labelText: "Date of Birth (yyyy-mm-dd)",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _tobController,
                      decoration: const InputDecoration(
                        labelText: "Time of Birth (HH:mm, 24h)",
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text("Calculate"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  result.isEmpty
                      ? const Center(
                        child: Text(
                          "Enter DOB & TOB, then press Calculate",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : Card(
                        elevation: 3,
                        color: Colors.deepPurple.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            result,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
