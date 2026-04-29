@echo off
setlocal

set "PROJECT_DIR=%~dp0"
if not exist "%PROJECT_DIR%run.py" set "PROJECT_DIR=C:\Users\isaac\Downloads\video-tool-main\"

cd /d "%PROJECT_DIR%"
set "PATH=%PROJECT_DIR%tools\ffmpeg\ffmpeg-8.1-essentials_build\bin;%PATH%"
set "OMP_NUM_THREADS=6"
set "LOG=%USERPROFILE%\Downloads\video-tool-launch.log"
echo [%date% %time%] Launching app... > "%LOG%"
".\venv\Scripts\python.exe" run.py --execution-provider cuda --execution-threads 1 --frame-processor face_swapper >> "%LOG%" 2>&1
if errorlevel 1 (
  echo.
  echo App failed to start. Check log: %LOG%
  pause
)
