@echo off
set PKG=com.example.astro_life
set DBNAME=astro_app.db

adb exec-out run-as %PKG% cat databases/%DBNAME% > %DBNAME%

echo ✅ Database pulled: %DBNAME%
pause
