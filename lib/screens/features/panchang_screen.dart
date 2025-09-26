// import 'package:flutter/material.dart';
// import 'package:sweph/sweph.dart';
// import 'dart:async';

// class PanchangScreen extends StatefulWidget {
//   const PanchangScreen({super.key});

//   @override
//   State<PanchangScreen> createState() => _PanchangScreenState();
// }

// class _PanchangScreenState extends State<PanchangScreen> {
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   bool _isLoading = false;
//   Map<String, dynamic> _panchangData = {};

//   // Corrected: Using standard double types for location, as LatLong is not exposed.
//   final double _latitude = 23.1795;
//   final double _longitude = 75.7885; // Hardcoded Ujjain, India

//   @override
//   void initState() {
//     super.initState();
//     _calculatePanchang();
//   }

//   void _calculatePanchang() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final localDateTime = DateTime(
//       _selectedDate.year,
//       _selectedDate.month,
//       _selectedDate.day,
//       _selectedTime.hour,
//       _selectedTime.minute,
//     );

//     try {
//       final jd = Sweph.swe_julday(
//         localDateTime.year,
//         localDateTime.month,
//         localDateTime.day,
//         localDateTime.hour + localDateTime.minute / 60,
//         CalendarType.SE_GREG_CAL,
//       );

//       // Tithi
//       final tithi = Sweph.swe_getTithi(jd);
//       final tithiName = Sweph.swe_getTithiName(tithi.tithi);

//       // Nakshatra
//       final nakshatra = Sweph.swe_getNakshatra(jd);
//       final nakshatraName = Sweph.swe_getNakshatraName(nakshatra.nakshatra);

//       // Karana
//       final karana = Sweph.swe_getKarana(jd);
//       final karanaName = Sweph.swe_getKaranaName(karana.karana);

//       // Yoga
//       final yoga = Sweph.swe_getYoga(jd);
//       final yogaName = Sweph.swe_getYogaName(yoga.yoga);

//       if (mounted) {
//         setState(() {
//           _panchangData = {
//             'Tithi': tithiName,
//             'Nakshatra': nakshatraName,
//             'Karana': karanaName,
//             'Yoga': yogaName,
//             'Vara': localDateTime.weekdayName,
//           };
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to calculate Panchang: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(1900, 1, 1),
//       lastDate: DateTime(2100, 12, 31),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _calculatePanchang();
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//         _calculatePanchang();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Panchang'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton.icon(
//                           icon: const Icon(Icons.calendar_today),
//                           label: Text(_selectedDate.toIso8601String().split('T')[0]),
//                           onPressed: () => _selectDate(context),
//                         ),
//                         ElevatedButton.icon(
//                           icon: const Icon(Icons.access_time),
//                           label: Text(_selectedTime.format(context)),
//                           onPressed: () => _selectTime(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: _panchangData.entries
//                             .map((entry) => ListTile(
//                                   leading: Icon(_getPanchangIcon(entry.key)),
//                                   title: Text(entry.key),
//                                   trailing: Text(entry.value),
//                                 ))
//                             .toList(),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getPanchangIcon(String key) {
//     switch (key) {
//       case 'Tithi':
//         return Icons.wb_sunny;
//       case 'Nakshatra':
//         return Icons.star;
//       case 'Karana':
//         return Icons.circle;
//       case 'Yoga':
//         return Icons.self_improvement;
//       case 'Vara':
//         return Icons.calendar_view_week;
//       default:
//         return Icons.help_outline;
//     }
//   }
// }

// // A simple extension to get the weekday name, since it's not
// // a built-in property.
// extension DateTimeExtension on DateTime {
//   String get weekdayName {
//     const weekdays = [
//       'Monday', 'Tuesday', 'Wednesday', 'Thursday',
//       'Friday', 'Saturday', 'Sunday',
//     ];
//     return weekdays[weekday - 1];
//   }
// }

import 'package:flutter/material.dart';

class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
