@echo off
chcp 65001 >nul
title Ferramentas do Sistema - Windows 11
color 0A

:: Verificar se está em modo Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ============================================
    echo   ATENCAO: EXECUTE COMO ADMINISTRADOR
    echo ============================================
    echo Algumas ferramentas podem nao funcionar corretamente.
    echo.
    pause
    cls
)

:menu
cls
echo ============================================
echo       FERRAMENTAS DO SISTEMA - MENU
echo ============================================
echo.
echo    1. Abrir Editor de Registro (Regedit)
echo    2. Abrir Gerenciador de Contas (Netplwiz)
echo    3. Abrir Politica de Grupo (gpedit.msc)
echo    4. Abrir Configuracoes do Sistema (msconfig)
echo    5. Abrir Servicos (services.msc)
echo    6. Sair
echo.
echo ============================================
set /p escolha="Escolha uma opcao (1-6): "

if "%escolha%"=="" goto menu
if "%escolha%"=="1" (
    start regedit
    goto menu
)
if "%escolha%"=="2" (
    start netplwiz
    goto menu
)
if "%escolha%"=="3" (
    start gpedit.msc
    goto menu
)
if "%escolha%"=="4" (
    start msconfig
    goto menu
)
if "%escolha%"=="5" (
    start services.msc
    goto menu
)
if "%escolha%"=="6" (
    exit
)

:: Se digitar opcao invalida
echo.
echo Opcao invalida! Tente novamente.
pause >nul
goto menu
