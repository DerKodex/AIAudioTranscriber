@echo off

REM Verificar si Python está instalado
python --version >nul 2>&1
if %errorlevel% NEQ 0 (
    REM Python no está instalado, descargue e instale
    echo Python no está instalado. Descargando e instalando Python...
    REM Descarga el instalador de Python
    bitsadmin.exe /transfer "DescargaPython" https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe "%cd%\python-3.10.6-amd64.exe"
    REM Instala Python silenciosamente
    python-3.10.6-amd64.exe /quiet InstallAllUsers=1 PrependPath=1
    echo Python instalado correctamente.
)

REM Verificar si Git está instalado
git --version >nul 2>&1
if %errorlevel% NEQ 0 (
    REM Git no está instalado, descargue e instale
    echo Git no está instalado. Descargando e instalando Git...
    REM Descarga el instalador de Git
    bitsadmin.exe /transfer "DescargaGit" https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe "%cd%\git-install-2.43.0-64-bit.exe"
    REM Instala Git silenciosamente
    git-install-2.43.0-64-bit.exe /VERYSILENT /NORESTART
    echo Git instalado correctamente.
)

REM Verificar si la carpeta del repositorio existe
if exist "AIAudioTranscriber" (
    REM La carpeta del repositorio existe, realizar un git pull
    echo Actualizando el repositorio...
    cd AIAudioTranscriber
    git pull
) else (
    REM La carpeta del repositorio no existe, clonar el repositorio desde GitHub
    echo Clonando el proyecto desde GitHub...
    git clone https://github.com/DerKodex/AIAudioTranscriber.git
    cd AIAudioTranscriber
)

REM Crear un entorno virtual con venv
echo Creando entorno virtual...
python -m venv venv
echo Entorno virtual creado correctamente.

REM Activar el entorno virtual usando PowerShell
echo Activando entorno virtual...
powershell -Command ".\venv\Scripts\Activate.ps1"

REM Instalar los requisitos del proyecto
echo Instalando los requisitos del proyecto...
pip install -r requirements.txt --no-cache-dir

REM Verificar la existencia y tamaño de los archivos
echo Validando la existencia y tamaño de los archivos...
set "files_exist=true"
for %%F in ("base.pt" "files.txt" "large-v2.pt" "medium.pt" "small.pt" "tiny.pt") do (
    if not exist "assets\models\%%F" (
        set "files_exist=false"
        echo Archivo %%F no encontrado.
    ) else (
        for /f %%A in ('"dir /-c "assets\models\%%F" | findstr /r /c:"^ *1 file" "') do set "file_size=%%A"
        echo Tamaño de %%F: %file_size%
    )
)

REM Si los archivos existen, no ejecutar el paso para obtener los pesos del modelo
if "%files_exist%"=="true" (
    echo Los archivos ya existen. No es necesario obtener los pesos del modelo.
) else (
    REM Ejecutar el script para obtener los pesos del modelo
    echo Obteniendo los pesos del modelo...
    python get_model_weights.py
)

REM Ejecutar la aplicación con Streamlit
echo Ejecutando la aplicación con Streamlit...
streamlit run Home.py --server.maxUploadSize 10000

REM Desactivar el entorno virtual
echo Desactivando entorno virtual...
deactivate
