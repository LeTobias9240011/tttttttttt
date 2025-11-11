@echo off
echo ==========================================
echo FairPoint App - Build Script
echo ==========================================
echo.

:menu
echo Waehle eine Option:
echo.
echo [1] Android APK bauen (Release)
echo [2] Android AAB bauen (Play Store)
echo [3] Beide Android Versionen bauen
echo [4] iOS zu GitHub pushen (automatischer Build)
echo [5] Alles cleanen und neu bauen
echo [6] Flutter Doctor
echo [7] Git Repository einrichten
echo [0] Beenden
echo.
set /p choice="Deine Wahl: "

if "%choice%"=="1" goto build_apk
if "%choice%"=="2" goto build_aab
if "%choice%"=="3" goto build_android_all
if "%choice%"=="4" goto push_ios
if "%choice%"=="5" goto clean_build
if "%choice%"=="6" goto flutter_doctor
if "%choice%"=="7" goto setup_git
if "%choice%"=="0" goto end
goto menu

:build_apk
echo.
echo [*] Baue Android APK...
call flutter build apk --release
if %errorlevel% equ 0 (
    echo.
    echo [OK] APK erfolgreich gebaut!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo.
    echo [FEHLER] APK Build fehlgeschlagen!
)
echo.
pause
goto menu

:build_aab
echo.
echo [*] Baue Android AAB (fuer Play Store)...
call flutter build appbundle --release
if %errorlevel% equ 0 (
    echo.
    echo [OK] AAB erfolgreich gebaut!
    echo Location: build\app\outputs\bundle\release\app-release.aab
) else (
    echo.
    echo [FEHLER] AAB Build fehlgeschlagen!
)
echo.
pause
goto menu

:build_android_all
echo.
echo [*] Baue beide Android Versionen...
call flutter build apk --release
call flutter build appbundle --release
if %errorlevel% equ 0 (
    echo.
    echo [OK] Beide Android Builds erfolgreich!
    echo APK: build\app\outputs\flutter-apk\app-release.apk
    echo AAB: build\app\outputs\bundle\release\app-release.aab
) else (
    echo.
    echo [FEHLER] Ein Build ist fehlgeschlagen!
)
echo.
pause
goto menu

:push_ios
echo.
echo [*] Pushe zu GitHub fuer automatischen iOS Build...
echo.

REM Prüfe ob Git Repository existiert
git status >nul 2>&1
if %errorlevel% neq 0 (
    echo [FEHLER] Dies ist kein Git Repository!
    echo.
    echo Bitte initialisiere zuerst Git:
    echo 1. git init
    echo 2. git add .
    echo 3. git commit -m "Initial commit"
    echo 4. git remote add origin https://github.com/DEIN_USERNAME/DEIN_REPO.git
    echo 5. git push -u origin main
    echo.
    echo Oder nutze Option [7] fuer automatisches Git Setup!
    echo.
    pause
    goto menu
)

git status
echo.
set /p commit_msg="Commit Message: "
git add .
git commit -m "%commit_msg%"
git push
if %errorlevel% equ 0 (
    echo.
    echo [OK] Erfolgreich zu GitHub gepusht!
    echo.
    echo Gehe zu GitHub Actions:
    git remote -v | findstr origin
    echo Der iOS Build startet automatisch in wenigen Sekunden.
    echo Dauer: ca. 10-15 Minuten
    echo.
) else (
    echo.
    echo [FEHLER] Git Push fehlgeschlagen!
    echo.
    echo Moegliche Ursachen:
    echo - Kein Remote Repository konfiguriert
    echo - Keine Berechtigung zum Pushen
    echo - Branch nicht getrackt
    echo.
    echo Siehe: GIT_SETUP_GUIDE.md
)
echo.
pause
goto menu

:clean_build
echo.
echo [*] Cleane Flutter Projekt...
call flutter clean
echo [*] Hole Dependencies...
call flutter pub get
echo [*] Baue Android APK...
call flutter build apk --release
if %errorlevel% equ 0 (
    echo.
    echo [OK] Clean Build erfolgreich!
) else (
    echo.
    echo [FEHLER] Clean Build fehlgeschlagen!
)
echo.
pause
goto menu

:flutter_doctor
echo.
echo [*] Flutter Doctor Ausgabe:
echo.
call flutter doctor -v
echo.
pause
goto menu

:setup_git
echo.
echo ==========================================
echo Git Repository Setup
echo ==========================================
echo.

REM Prüfe ob bereits ein Git Repo existiert
if exist .git (
    echo [!] Git Repository existiert bereits!
    echo.
    git status
    echo.
    set /p reconfigure="Moechtest du das Remote Repository neu konfigurieren? (j/n): "
    if /i "%reconfigure%"=="j" goto configure_remote
    goto menu
)

echo [1/5] Initialisiere Git Repository...
git init
if %errorlevel% neq 0 (
    echo [FEHLER] Git Init fehlgeschlagen!
    pause
    goto menu
)
git branch -M main
echo [OK] Git Repository initialisiert

echo.
echo [2/5] Erstelle .gitignore (falls nicht vorhanden)...
if not exist .gitignore (
    echo # Flutter > .gitignore
    echo .dart_tool/ >> .gitignore
    echo build/ >> .gitignore
    echo .flutter-plugins >> .gitignore
    echo .flutter-plugins-dependencies >> .gitignore
    echo.
    echo # IDE >> .gitignore
    echo .idea/ >> .gitignore
    echo *.iml >> .gitignore
    echo.
    echo # Secrets >> .gitignore
    echo android/key.properties >> .gitignore
    echo *.jks >> .gitignore
    echo [OK] .gitignore erstellt
) else (
    echo [OK] .gitignore existiert bereits
)

echo.
echo [3/5] Fuege alle Dateien hinzu...
git add .
echo [OK] Dateien hinzugefuegt

echo.
echo [4/5] Erstelle Initial Commit...
git commit -m "Initial commit - FairPoint App"
if %errorlevel% neq 0 (
    echo [WARNUNG] Commit fehlgeschlagen oder keine Aenderungen
)
echo [OK] Initial Commit erstellt

:configure_remote
echo.
echo [5/5] Konfiguriere GitHub Remote...
echo.
echo Bitte gib deine GitHub Repository URL ein.
echo Beispiel: https://github.com/username/fairpoint-app.git
echo.
set /p repo_url="GitHub Repository URL: "

if "%repo_url%"=="" (
    echo [FEHLER] Keine URL angegeben!
    echo.
    echo Du kannst das Remote spater manuell hinzufuegen:
    echo git remote add origin https://github.com/username/repo.git
    echo git push -u origin main
    pause
    goto menu
)

REM Entferne altes Remote falls vorhanden
git remote remove origin >nul 2>&1

git remote add origin %repo_url%
if %errorlevel% neq 0 (
    echo [FEHLER] Remote konnte nicht hinzugefuegt werden!
    pause
    goto menu
)

echo [OK] Remote hinzugefuegt
echo.
echo Moechtest du jetzt zu GitHub pushen?
set /p do_push="Push durchfuehren? (j/n): "

if /i "%do_push%"=="j" (
    echo.
    echo [*] Pushe zu GitHub...
    git push -u origin main
    if %errorlevel% equ 0 (
        echo.
        echo ==========================================
        echo [SUCCESS] Git Setup abgeschlossen!
        echo ==========================================
        echo.
        echo Dein Repository ist jetzt mit GitHub verbunden.
        echo Du kannst nun Option [4] nutzen fuer iOS Builds!
        echo.
        echo Repository URL: %repo_url%
        echo.
    ) else (
        echo.
        echo [FEHLER] Push fehlgeschlagen!
        echo.
        echo Moegliche Ursachen:
        echo - Repository existiert nicht auf GitHub
        echo - Keine Berechtigung (Git Credentials pruefen)
        echo - Branch-Name stimmt nicht ueberein
        echo.
        echo Siehe: GIT_SETUP_GUIDE.md
    )
) else (
    echo.
    echo [INFO] Remote konfiguriert, aber nicht gepusht.
    echo Du kannst spater pushen mit:
    echo   git push -u origin main
)

echo.
pause
goto menu

:end
echo.
echo Auf Wiedersehen!
exit
