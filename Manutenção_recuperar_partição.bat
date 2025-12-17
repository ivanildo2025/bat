@echo off
title Recuperacao de Disco NTFS
color 0A

echo =====================================
echo   RECUPERACAO DE DISCO NTFS (ADM)
echo =====================================
echo.

set /p DRIVE=Digite a letra do disco (ex: D): 

if "%DRIVE%"=="" goto erro

set DISCO=%DRIVE%:

echo.
echo Verificando o disco %DISCO%
echo.

chkdsk %DISCO% /f /r /x

echo.
echo Processo finalizado.
pause
exit

:erro
echo Letra de disco invalida.
pause
exit
