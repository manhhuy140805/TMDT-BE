@echo off
setlocal

cd /d "%~dp0"
set "COMPOSE_PROJECT=tmdt-be"
set "POSTGRES_VOLUME=%COMPOSE_PROJECT%_postgres_data"
set "SEED_FILE=db\exampleData.sql"

echo WARNING: This will delete all local PostgreSQL data in %POSTGRES_VOLUME%.
set /p "CONFIRM=Type YES to continue: "
if /i not "%CONFIRM%"=="YES" (
  echo Reset cancelled.
  exit /b 0
)

echo [1/8] Checking Docker...
docker version >nul 2>&1
if errorlevel 1 (
  echo Docker is not running. Start Docker Desktop and try again.
  exit /b 1
)

echo [2/8] Stopping backend stack...
docker compose -p "%COMPOSE_PROJECT%" down
if errorlevel 1 exit /b 1

echo [3/8] Removing PostgreSQL volume...
docker volume inspect "%POSTGRES_VOLUME%" >nul 2>&1
if not errorlevel 1 (
  docker volume rm "%POSTGRES_VOLUME%"
  if errorlevel 1 exit /b 1
)

echo [4/8] Starting a fresh PostgreSQL container...
docker compose -p "%COMPOSE_PROJECT%" up -d postgres
if errorlevel 1 exit /b 1

echo Waiting for PostgreSQL healthcheck...
set /a ATTEMPTS=0
set "POSTGRES_HEALTH="
:wait_for_postgres
set /a ATTEMPTS+=1
for /f "delims=" %%i in ('docker inspect --format "{{.State.Health.Status}}" fras-postgres 2^>nul') do set "POSTGRES_HEALTH=%%i"
if /i "%POSTGRES_HEALTH%"=="healthy" goto postgres_ready
if %ATTEMPTS% GEQ 30 (
  echo PostgreSQL did not become healthy in time.
  exit /b 1
)
ping 127.0.0.1 -n 3 >nul
goto wait_for_postgres

:postgres_ready
echo [5/8] Building backend image...
docker compose -p "%COMPOSE_PROJECT%" build backend
if errorlevel 1 exit /b 1

echo [6/8] Applying Prisma schema...
docker compose -p "%COMPOSE_PROJECT%" run --rm backend npx prisma db push
if errorlevel 1 exit /b 1

echo [7/8] Loading sample data from %SEED_FILE%...
if not exist "%SEED_FILE%" (
  echo Seed file not found: %SEED_FILE%
  exit /b 1
)
docker exec -i fras-postgres psql -v ON_ERROR_STOP=1 -U admin -d fras_tmdt < "%SEED_FILE%"
if errorlevel 1 exit /b 1

echo [8/8] Starting backend stack...
docker compose -p "%COMPOSE_PROJECT%" up -d backend pgadmin
if errorlevel 1 exit /b 1

echo.
docker compose -p "%COMPOSE_PROJECT%" ps
if errorlevel 1 exit /b 1

echo.
echo Backend reset completed.
echo Backend:  http://localhost:8080
echo pgAdmin:  http://localhost:5050
echo Postgres: localhost:5432

endlocal
