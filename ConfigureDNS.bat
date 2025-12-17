@echo off
setlocal EnableDelayedExpansion

:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Este script precisa ser executado como administrador.
    echo Solicitando elevação...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Configurador de Servidores DNS Gratuitos
echo.
echo Escolha um servidor DNS:
echo 1. Google DNS (8.8.8.8, 8.8.4.4)
echo 2. Cloudflare DNS (1.1.1.1, 1.0.0.1)
echo 3. Quad9 DNS (9.9.9.9, 149.112.112.112)
echo 4. OpenDNS (208.67.222.222, 208.67.220.220)
echo 5. AdGuard DNS (94.140.14.14, 94.140.15.15)
echo.

set /p choice="Digite o número da opção desejada (1-5): "

:: Define os endereços DNS com base na escolha do usuário
if "%choice%"=="1" (
    set dns1=8.8.8.8
    set dns2=8.8.4.4
    set provider=Google DNS
) else if "%choice%"=="2" (
    set dns1=1.1.1.1
    set dns2=1.0.0.1
    set provider=Cloudflare DNS
) else if "%choice%"=="3" (
    set dns1=9.9.9.9
    set dns2=149.112.112.112
    set provider=Quad9 DNS
) else if "%choice%"=="4" (
    set dns1=208.67.222.222
    set dns2=208.67.220.220
    set provider=OpenDNS
) else if "%choice%"=="5" (
    set dns1=94.140.14.14
    set dns2=94.140.15.15
    set provider=AdGuard DNS
) else (
    echo Opção inválida! Encerrando...
    pause
    exit /b
)

echo.
echo Configurando %provider% (%dns1%, %dns2%)...

:: Obtém a interface de rede ativa (Wi-Fi ou Ethernet)
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /R "Default Gateway.*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"') do (
    set "gateway=%%a"
    set "gateway=!gateway: =!"
)

:: Obtém o nome da interface de rede ativa
for /f "tokens=*" %%a in ('netsh interface ip show config ^| findstr /C:"!gateway!"') do (
    for /f "tokens=3*" %%b in ("%%a") do (
        set "interface=%%b"
    )
)

:: Remove aspas e espaços extras do nome da interface
set "interface=%interface:"=%