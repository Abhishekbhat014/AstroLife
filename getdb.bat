@echo off

:: --- Configuration ---
:: Ensure this package name matches your Android project's manifest
set PKG=com.example.astro_life
:: The database name defined in DatabaseHelper.dart
set DBNAME=astro_life.db

:: --- Execution ---
echo Attempting to pull database %DBNAME% from device...

:: Use 'run-as' to access the app's internal file system and pull the database.
adb exec-out run-as %PKG% cat databases/%DBNAME% > %DBNAME%

:: --- Result ---
if exist %DBNAME% (
echo.
echo ✅ Database pull successful!
echo The database file "%DBNAME%" is now in this folder.
) else (
echo.
echo ❌ Database pull failed. Check:
echo 1. Is an emulator or device connected? (Run 'adb devices')
echo 2. Is the app installed and running?
echo 3. Is the package name "%PKG%" correct?
)

pause