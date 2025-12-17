@echo off
chcp 65001 > nul
:: Batch script para manutenção do Windows (requer admin)
:: Se não for executado como admin, solicita elevação automaticamente

:: =============================================
:: Verifica se está sendo executado como administrador
:: =============================================
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    goto :MAIN
) ELSE (
    goto :ELEVATE
)

:: =============================================
:: Solicita elevação via UAC (se não for admin)
:: =============================================
:ELEVATE
echo.
echo [AVISO] Este script requer privilégios de administrador.
echo Solicitando permissões elevadas...
echo.

:: Reexecuta o script como administrador
powershell -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
exit /b

:: =============================================
:: Parte principal do script (executada como admin)
:: =============================================
:MAIN
echo.
echo [STATUS] Executando como administrador. Iniciando manutenção...
echo =============================================
echo.

:: 1. Verifica e corrige erros no disco
echo [ETAPA 1] Verificando erros no disco (CHKDSK)...
chkdsk C: /f /x
echo.

:: 2. Verifica arquivos de sistema corrompidos
echo [ETAPA 2] Verificando arquivos do sistema (SFC)...
sfc /scannow
echo.

:: 3. Atualiza o Windows (via PowerShell)
echo [ETAPA 3] Verificando atualizações do Windows...
echo (Esta etapa pode demorar...)
wuauclt /detectnow
wuauclt /updatenow
UsoClient StartScan
USOClient.exe StartInteractiveScan
UsoClient Iniciar Download
ScanInstallWait



echo.
PAUSE

:: 4. Agenda desligamento
echo [ETAPA 4] O PC será desligado em 1 minuto!
shutdown /s /f /t 60 /c "Manutenção concluída. Salve seu trabalho!"

echo =============================================
echo [CONCLUÍDO] Todas as etapas foram finalizadas.
echo =============================================
pause
