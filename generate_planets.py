import swisseph as swe
import os
import struct
from datetime import datetime, timedelta

# --- Settings ---
start_year = 1900
end_year = 2100
output_dir = "planet_binaries"

# Make output directory
os.makedirs(output_dir, exist_ok=True)

# Planets we want (use SWEP constants)
planets = {
  "Sun": swe.SUN,
  "Moon": swe.MOON,
  "Mercury": swe.MERCURY,
  "Venus": swe.VENUS,
  "Mars": swe.MARS,
  "Jupiter": swe.JUPITER,
  "Saturn": swe.SATURN,
  "Rahu": swe.MEAN_NODE, 
  "Ketu": swe.MEAN_NODE, 
}

# Use sidereal mode for Vedic astrology
swe.set_sid_mode(swe.SIDM_LAHIRI)

# Generate Julian Day for a datetime in UT
def julian_day(dt):
  year = dt.year
  month = dt.month
  day = dt.day
  hour = dt.hour + dt.minute/60 + dt.second/3600
  return swe.julday(year, month, day, hour)

# Generate data for each planet
for planet_name, planet_id in planets.items():
  # Determine the step size based on the planet
  step_hours = 2 if planet_name == "Moon" else 6
  step = timedelta(hours=step_hours)
  
  filename = os.path.join(output_dir, f"{planet_name}.bin")
  print(f"Generating {planet_name} data with {step_hours}-hour steps -> {filename}")

  with open(filename, "wb") as f:
    date = datetime(start_year, 1, 1, 0, 0)
    end_date = datetime(end_year, 12, 31, 23, 59)
    
    while date <= end_date:
      jd = julian_day(date)
      
      if planet_name == "Ketu":
        pos, _ = swe.calc_ut(jd, swe.MEAN_NODE)
        lon = (pos[0] + 180) % 360
        lat = pos[1]
        lon_speed = pos[3]
      else:
        pos, _ = swe.calc_ut(jd, planet_id)
        lon, lat, dist, lon_speed, lat_speed, dist_speed = pos
      
      # Apply a custom offset if needed.
      # Note: The offset has been removed to return to standard Lahiri values.
      # lon = (lon + AYANAMSA_OFFSET) % 360
      
      # Retrograde flag is 1 if longitudinal speed is negative, 0 otherwise.
      retrograde = 1 if lon_speed < 0 else 0
      
      # Pack data: double jd, float lon, float lat, uint8 retrograde
      f.write(struct.pack("<dffB", jd, lon, lat, retrograde))
      
      date += step

print("\n All planet data regenerated successfully.")
