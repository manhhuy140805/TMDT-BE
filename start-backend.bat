@echo off
setlocal

cd /d "%~dp0"
set "COMPOSE_PROJECT=tmdt-be"

echo [1/3] Checking Docker...
docker version >nul 2>&1
if errorlevel 1 (
  echo Docker is not running. Start Docker Desktop and try again.
  exit /b 1
)

echo [2/3] Building and starting backend stack...
docker compose -p "%COMPOSE_PROJECT%" up -d --build
if errorlevel 1 exit /b 1

echo [3/3] Current services:
docker compose -p "%COMPOSE_PROJECT%" ps
if errorlevel 1 exit /b 1

echo.
echo Backend:  http://localhost:8080
echo pgAdmin:  http://localhost:5050
echo Postgres: localhost:5432

endlocal
