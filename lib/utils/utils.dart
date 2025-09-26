import 'package:flutter/material.dart';

// Represents the data for a planet's position at a specific Julian Day.
// This model will be used across different services and screens.
class PlanetData {
  final double jd;
  final double longitude;
  final double latitude;
  final bool retrograde;
  PlanetData(this.jd, this.longitude, this.latitude, this.retrograde);
}

// A correct and reliable function to calculate the Julian Day from a UTC DateTime.
double julianDay(DateTime date) {
  // The Julian Day for the Unix epoch (January 1, 1970, 00:00:00 UTC).
  const double unixEpochJD = 2440587.5;
  // Milliseconds in a full day.
  const double msInDay = 86400000.0;

  // Calculate the Julian Day based on milliseconds since the Unix epoch.
  return date.millisecondsSinceEpoch / msInDay + unixEpochJD;
}

// Converts a sidereal longitude (0-360°) to a Vedic Rashi (zodiac sign).
String getRashi(double longitude) {
  longitude = longitude % 360;
  const rashis = [
    "Mesha",
    "Vrishabha",
    "Mithuna",
    "Karka",
    "Simha",
    "Kanya",
    "Tula",
    "Vrishchika",
    "Dhanu",
    "Makara",
    "Kumbha",
    "Meena",
  ];
  var index = (longitude / 30).floor();
  index = index - 1;
  if (index < 0) index = 11; // Wrap around for Pisces
  return rashis[index];
}

// Map of common timezones to their UTC offset
final Map<String, Duration> timeZones = {
  'UTC': Duration.zero,
  'IST': const Duration(hours: 5, minutes: 30),
  'EST': const Duration(hours: -5),
  'PST': const Duration(hours: -8),
};

// Returns the appropriate icon for a given planet name.
Icon getPlanetIcon(String planetName) {
  switch (planetName) {
    case 'Sun':
      return const Icon(Icons.wb_sunny, color: Colors.orange);
    case 'Moon':
      return const Icon(Icons.nightlight_round, color: Colors.blueGrey);
    case 'Mercury':
      return const Icon(Icons.circle, color: Colors.green, size: 16);
    case 'Venus':
      return const Icon(Icons.flare, color: Colors.pink);
    case 'Mars':
      return const Icon(Icons.directions_run, color: Colors.red);
    case 'Jupiter':
      return const Icon(Icons.stars, color: Colors.amber);
    case 'Saturn':
      return const Icon(Icons.satellite_alt, color: Colors.blue);
    case 'Rahu':
      return const Icon(Icons.hexagon, color: Colors.purple, size: 16);
    case 'Ketu':
      return const Icon(Icons.circle, color: Colors.purple, size: 16);
    default:
      return const Icon(Icons.public);
  }
}
