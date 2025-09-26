import 'package:flutter/material.dart';

class BirthChartScreen extends StatelessWidget {
  final String name;
  // final DateTime birthDate;
  // final String birthTime;
  // final String birthPlace;

  const BirthChartScreen({
    super.key,
    required this.name,
    // required this.birthDate,
    // required this.birthTime,
    // required this.birthPlace,
  });

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         "Birth Chart",
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: const Color(0xFF556B2F), // Deep Olive Green
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // User details
  //           Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             elevation: 3,
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Name: $name",
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                   Text(
  //                     "Birth Date: ${birthDate.toLocal()}".split(" ")[0],
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                   Text(
  //                     "Birth Time: $birthTime",
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                   Text(
  //                     "Birth Place: $birthPlace",
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           Text(
  //             "Planetary Positions",
  //             style: Theme.of(context).textTheme.headlineSmall,
  //           ),
  //           const SizedBox(height: 10),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: 9, // Sun, Moon, Mars, etc.
  //               itemBuilder: (context, index) {
  //                 final planets = [
  //                   "Sun",
  //                   "Moon",
  //                   "Mars",
  //                   "Mercury",
  //                   "Jupiter",
  //                   "Venus",
  //                   "Saturn",
  //                   "Rahu",
  //                   "Ketu",
  //                 ];
  //                 // Placeholder positions (you can replace with Sweph values later)
  //                 final positions = [
  //                   "Aries - 10°",
  //                   "Taurus - 15°",
  //                   "Gemini - 22°",
  //                   "Cancer - 3°",
  //                   "Leo - 18°",
  //                   "Virgo - 27°",
  //                   "Libra - 11°",
  //                   "Scorpio - 5°",
  //                   "Sagittarius - 20°",
  //                 ];
  //                 return Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: ListTile(
  //                     leading: CircleAvatar(
  //                       backgroundColor: const Color(0xFFA52A2A), // Terracotta
  //                       child: Text(planets[index][0]),
  //                     ),
  //                     title: Text(planets[index]),
  //                     subtitle: Text("Position: ${positions[index]}"),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Birth Chart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF556B2F), // Deep Olive Green
      ),
      body: Center(
        child: Text(
          "Welcome, $name!\nYour Birth Chart details will be displayed here.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
