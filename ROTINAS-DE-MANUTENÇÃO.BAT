@echo off
:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Elevando privilegios de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title SUPER UTILITARIO DE MANUTENCAO WINDOWS
color 0A
setlocal enabledelayedexpansion

:: Criação automática de ponto de restauração
echo ========================================
echo    CRIANDO PONTO DE RESTAURACAO
echo ========================================
echo.
powershell -Command "Enable-ComputerRestore -Drive 'C:\'" 2>nul
powershell -Command "Checkpoint-Computer -Description 'Ponto_Pre-Manutencao_%date%_%time%' -RestorePointType MODIFY_SETTINGS" 2>nul
echo Ponto de restauracao criado com sucesso!
echo.
timeout /t 2 /nobreak >nul

:: Menu principal
:menu
cls
echo ========================================
echo    SUPER UTILITARIO DE MANUTENCAO
echo ========================================
echo.
echo 1. DIAGNOSTICO COMPLETO DO SISTEMA
echo 2. LIMPEZA E OTIMIZACAO
echo 3. SEGURANCA E ANTI-MALWARE
echo 4. REDE E INTERNET
echo 5. INFORMACOES DO SISTEMA
echo 6. FERRAMENTAS AVANCADAS
echo 7. RECUPERACAO DE PARTICOES
echo 8. CRIAR PONTO DE RESTAURACAO
echo 9. SAIR
echo.
set /p escolha="Escolha uma opcao (1-9): "

if "%escolha%"=="1" goto diagnostico
if "%escolha%"=="2" goto limpeza
if "%escolha%"=="3" goto seguranca
if "%escolha%"=="4" goto rede
if "%escolha%"=="5" goto informacoes
if "%escolha%"=="6" goto avancadas
if "%escolha%"=="7" goto recuperar_particao
if "%escolha%"=="8" goto criar_ponto
if "%escolha%"=="9" exit
goto menu

:: ========== DIAGNOSTICO COMPLETO ==========
:diagnostico
cls
echo ========================================
echo    DIAGNOSTICO COMPLETO DO SISTEMA
echo ========================================
echo.

echo 1. Verificando integridade dos arquivos do sistema...
sfc /scannow
echo.

echo 2. Verificando imagem do Windows...
Dism /Online /Cleanup-Image /ScanHealth
echo.

echo 3. Verificando disco (CHKDSK)...
echo Aguarde, isso pode demorar...
chkdsk C: /scan
echo.

echo 4. Verificando drivers...
pnputil /enum-drivers | findstr /i "problema|falha|erro"
echo.

echo 5. Verificando eventos criticos do sistema...
wevtutil qe System /q:"*[System[(Level=1 or Level=2)]]" /rd:true /f:text /c:5
echo.

pause
goto menu

:: ========== LIMPEZA E OTIMIZACAO ==========
:limpeza
cls
echo ========================================
echo    LIMPEZA E OTIMIZACAO
echo ========================================
echo.

echo 1. Limpando arquivos temporarios...
del /q /f /s "%temp%\*.*" 2>nul
rd /s /q "%temp%" 2>nul
md "%temp%" 2>nul
echo Concluido!
echo.

echo 2. Limpando Prefetch...
del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul
echo Concluido!
echo.

echo 3. Limpando cache do DNS...
ipconfig /flushdns
echo Concluido!
echo.

echo 4. Limpando cache do Windows Update...
net stop wuauserv 2>nul
rd /s /q "C:\Windows\SoftwareDistribution\Download" 2>nul
net start wuauserv 2>nul
echo Concluido!
echo.

echo 5. Limpando arquivos do lixo de reciclagem...
rd /s /q "C:\$Recycle.Bin" 2>nul
echo Concluido!
echo.

echo 6. Otimizando unidades (TRIM para SSDs)...
defrag C: /O /U 2>nul
echo Concluido!
echo.

echo 7. Compactando registro do Windows...
regedit /e "C:\temp_reg_backup.reg" HKEY_LOCAL_MACHINE 2>nul
regedit /e "C:\temp_reg_backup.reg" HKEY_CURRENT_USER 2>nul
echo Backup do registro criado.
echo.

pause
goto menu

:: ========== SEGURANCA E ANTI-MALWARE ==========
:seguranca
cls
echo ========================================
echo    SEGURANCA E ANTI-MALWARE
echo ========================================
echo.

echo 1. Executando Windows Defender (Antivirus)...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1 2>nul
echo Concluido!
echo.

echo 2. Executando Malicious Software Removal Tool...
start /wait mrt.exe
echo Concluido!
echo.

echo 3. Verificando firewall...
netsh advfirewall show allprofiles
echo.

echo 4. Verificando atualizacoes de seguranca...
wuauclt /detectnow /updatenow 2>nul
echo Concluido!
echo.

echo 5. Verificando politicas de seguranca...
secedit /export /cfg C:\security_policy.txt 2>nul
echo Politicas exportadas para C:\security_policy.txt
echo.

pause
goto menu

:: ========== REDE E INTERNET ==========
:rede
cls
echo ========================================
echo    REDE E INTERNET
echo ========================================
echo.

echo 1. Resetando pilha TCP/IP...
netsh winsock reset
netsh int ip reset
echo Concluido!
echo.

echo 2. Liberando e renovando IP...
ipconfig /release
timeout /t 3 /nobreak >nul
ipconfig /renew
echo Concluido!
echo.

echo 3. Testando conexao com internet...
ping 8.8.8.8 -n 4
echo.

echo 4. Verificando rota para um site...
tracert www.google.com
echo.

echo 5. Verificando portas abertas...
netstat -an | findstr "LISTENING" | more
echo.

echo 6. Verificando conexoes ativas...
netstat -b | more
echo.

pause
goto menu

:: ========== INFORMACOES DO SISTEMA ==========
:informacoes
cls
echo ========================================
echo    INFORMACOES DO SISTEMA
echo ========================================
echo.

echo 1. Informacoes do hardware:
systeminfo | findstr /B /C:"Nome" /C:"Sistema" /C:"Memoria" /C:"Processador"
echo.

echo 2. Espaco em disco:
wmic logicaldisk get size,freespace,caption
echo.

echo 3. Processos em execucao:
tasklist | more
echo.

echo 4. Servicos ativos:
sc query | findstr "RUNNING" | more
echo.

echo 5. Hotfixes instalados:
wmic qfe get Caption,Description,HotFixID,InstalledOn | more
echo.

echo 6. Usuarios locais:
net user
echo.

echo 7. Informacoes de rede:
ipconfig /all
echo.

pause
goto menu

:: ========== FERRAMENTAS AVANCADAS ==========
:avancadas
cls
echo ========================================
echo    FERRAMENTAS AVANCADAS
echo ========================================
echo.

echo 1. Verificando integridade do sistema com DISM...
Dism /Online /Cleanup-Image /RestoreHealth
echo.

echo 2. Verificando memoria RAM...
mdsched.exe
echo Reinicie para testar a memoria.
echo.

echo 3. Verificando arquivos de inicializacao...
msconfig
echo.

echo 4. Monitor de recursos...
start perfmon /res
echo.

echo 5. Editor de politicas de grupo...
start gpedit.msc
echo.

echo 6. Visualizador de eventos...
start eventvwr.msc
echo.

echo 7. Gerenciador de dispositivos...
start devmgmt.msc
echo.

echo 8. Backup do registro...
reg export HKLM C:\backup_registro_HKLM.reg 2>nul
reg export HKCU C:\backup_registro_HKCU.reg 2>nul
echo Backup do registro criado em C:\
echo.

pause
goto menu

:: ========== RECUPERAÇÃO DE PARTIÇÕES ==========
:recuperar_particao
cls
echo ========================================
echo    RECUPERACAO DE PARTICOES AVANCADA
echo ========================================
echo.
echo ATENCAO: Esta operacao pode causar perda de dados!
echo Faca backup antes de prosseguir.
echo.
echo Opcoes disponiveis:
echo 1. Verificar e reparar particao com CHKDSK
echo 2. Recuperar dados com ferramenta nativa
echo 3. Tentar restaurar MBR/GPT
echo 4. Ver particoes ocultas/excluidas
echo 5. Voltar ao menu principal
echo.
set /p opcao_rec="Escolha uma opcao (1-5): "

if "%opcao_rec%"=="1" goto reparar_particao
if "%opcao_rec%"=="2" goto recuperar_dados
if "%opcao_rec%"=="3" goto restaurar_mbr
if "%opcao_rec%"=="4" goto ver_ocultas
if "%opcao_rec%"=="5" goto menu
goto recuperar_particao

:reparar_particao
cls
echo ========================================
echo    REPARAR PARTICAO COM CHKDSK
echo ========================================
echo.
echo Digite a letra da unidade a ser reparada
echo Exemplo: D, E, F (sem dois pontos)
echo.
set /p letra_disco="Letra do disco: "
echo.
echo Escolha o tipo de reparo:
echo 1. Verificacao basica (rapida)
echo 2. Reparar erros (/F)
echo 3. Reparar erros e recuperar setores (/R)
echo.
set /p tipo_reparo="Opcao: "

if "%tipo_reparo%"=="1" (
    echo Executando verificacao basica em %letra_disco%:...
    chkdsk %letra_disco%:
)

if "%tipo_reparo%"=="2" (
    echo Executando reparo de erros em %letra_disco%:...
    chkdsk %letra_disco%: /f
    echo.
    echo Se a unidade estiver em uso, sera solicitada reinicializacao.
)

if "%tipo_reparo%"=="3" (
    echo Executando reparo completo em %letra_disco%:...
    chkdsk %letra_disco%: /r
    echo.
    echo Esta operacao pode demorar horas em discos grandes!
    echo Se a unidade estiver em uso, sera solicitada reinicializacao.
)

echo.
echo Operacao concluida!
pause
goto recuperar_particao

:recuperar_dados
cls
echo ========================================
echo    RECUPERAR DADOS DE PARTICAO
echo ========================================
echo.
echo Esta opcao usa o Windows File Recovery (deve estar instalado)
echo Se nao tiver, instale da Microsoft Store.
echo.
echo 1. Recuperacao padrao (para arquivos recentemente excluidos)
echo 2. Recuperacao extensiva (para formatacao/particao corrompida)
echo 3. Voltar
echo.
set /p opcao_rec_dados="Opcao: "

if "%opcao_rec_dados%"=="1" (
    set /p origem_rec="Letra da unidade origem: "
    set /p destino_rec="Letra da unidade destino: "
    echo.
    echo Digite os tipos de arquivo (separados por espaco)
    echo Exemplo: pdf docx jpg png
    set /p tipos_arquivos="Tipos: "
    echo.
    echo Executando recuperacao...
    echo winfr %origem_rec%: %destino_rec%: /n *.%tipos_arquivos% /regular
    winfr %origem_rec%: %destino_rec%: /regular 2>nul || echo Ferramenta WinFR nao encontrada. Instale da Microsoft Store.
)

if "%opcao_rec_dados%"=="2" (
    set /p origem_rec="Letra da unidade origem: "
    set /p destino_rec="Letra da unidade destino: "
    echo.
    echo Digite os tipos de arquivo (separados por espaco)
    echo Exemplo: pdf docx jpg png
    set /p tipos_arquivos="Tipos: "
    echo.
    echo Executando recuperacao extensiva (pode demorar MUITO tempo)...
    echo winfr %origem_rec%: %destino_rec%: /n *.%tipos_arquivos% /extensive
    winfr %origem_rec%: %destino_rec%: /extensive 2>nul || echo Ferramenta WinFR nao encontrada. Instale da Microsoft Store.
)

if "%opcao_rec_dados%"=="3" goto recuperar_particao

pause
goto recuperar_particao

:restaurar_mbr
cls
echo ========================================
echo    RESTAURAR MBR/GPT E BOOT
echo ========================================
echo.
echo 1. Reparar registro de inicializacao (MBR)
echo 2. Reparar setor de inicializacao
echo 3. Reconstruir BCD
echo 4. Verificar integridade do disco
echo.
set /p opcao_boot="Opcao: "

echo.
echo Listando discos disponiveis...
echo list disk > list_discos.txt
diskpart /s list_discos.txt
del list_discos.txt

echo.
set /p num_disco="Numero do disco a reparar: "

if "%opcao_boot%"=="1" (
    echo Reparando MBR do disco %num_disco%...
    echo select disk %num_disco% > repair_mbr.txt
    echo clean >> repair_mbr.txt
    echo convert mbr >> repair_mbr.txt
    echo create partition primary >> repair_mbr.txt
    echo format fs=ntfs quick >> repair_mbr.txt
    echo active >> repair_mbr.txt
    echo assign letter=Z >> repair_mbr.txt
    echo exit >> repair_mbr.txt
    diskpart /s repair_mbr.txt
    del repair_mbr.txt
)

if "%opcao_boot%"=="2" (
    echo Reparando setor de boot...
    bootsect /nt60 ALL /force /mbr
)

if "%opcao_boot%"=="3" (
    echo Reconstruindo BCD...
    bcdedit /export C:\BCD_Backup
    attrib -s -h -r c:\boot\bcd
    ren c:\boot\bcd bcd.old
    bootrec /rebuildbcd
)

if "%opcao_boot%"=="4" (
    echo Verificando disco %num_disco%...
    echo select disk %num_disco% > check_disk.txt
    echo detail disk >> check_disk.txt
    echo list volume >> check_disk.txt
    diskpart /s check_disk.txt
    del check_disk.txt
)

pause
goto recuperar_particao

:ver_ocultas
cls
echo ========================================
echo    PARTICOES OCULTAS/EXCLUIDAS
echo ========================================
echo.
echo Analisando discos em busca de particoes...
echo.
echo list disk > show_parts.txt
echo select disk 0 >> show_parts.txt
echo list partition >> show_parts.txt
echo select disk 1 >> show_parts.txt
echo list partition >> show_parts.txt
diskpart /s show_parts.txt
del show_parts.txt

echo.
echo Procurando particoes excluidas...
echo.
for /f "tokens=2 delims= " %%i in ('wmic logicaldisk get deviceid 2^>nul') do (
    echo Verificando unidade %%i...
    fsutil fsinfo drivetype %%i | find "Fixo" >nul
    if errorlevel 1 (
        echo UNIDADE %%i: NAO MONTADA OU CORROMPIDA
        echo Tentando montar...
        mountvol %%i /p 2>nul
    )
)

echo.
echo Use o TestDisk ou EaseUS para recuperacao avançada.
echo Essas ferramentas sao mais eficientes para recuperacao.
echo Recomendacoes:
echo - TestDisk (gratuito): https://www.cgsecurity.org/wiki/TestDisk
echo - PhotoRec: https://www.cgsecurity.org/wiki/PhotoRec
echo - Recuva: https://www.ccleaner.com/recuva
echo - EaseUS Data Recovery: https://www.easeus.com
echo.
pause
goto recuperar_particao

:: ========== CRIAR PONTO DE RESTAURAÇÃO ==========
:criar_ponto
cls
echo ========================================
echo    CRIAR PONTO DE RESTAURACAO
echo ========================================
echo.
echo Escolha o tipo de ponto de restauracao:
echo.
echo 1. Ponto antes de instalacoes de software
echo 2. Ponto antes de atualizacoes do Windows
echo 3. Ponto manual (customizado)
echo 4. Voltar
echo.
set /p tipo_ponto="Opcao: "

if "%tipo_ponto%"=="1" (
    powershell -Command "Checkpoint-Computer -Description 'Ponto_Pre-Software_%date%_%time%' -RestorePointType APPLICATION_INSTALL"
    echo Ponto criado para instalacao de software!
)

if "%tipo_ponto%"=="2" (
    powershell -Command "Checkpoint-Computer -Description 'Ponto_Pre-Atualizacao_%date%_%time%' -RestorePointType MODIFY_SETTINGS"
    echo Ponto criado para atualizacoes do sistema!
)

if "%tipo_ponto%"=="3" (
    set /p descricao="Digite uma descricao para o ponto: "
    powershell -Command "Checkpoint-Computer -Description '%descricao%_%date%_%time%' -RestorePointType MODIFY_SETTINGS"
    echo Ponto de restauracao criado com sucesso!
)

if "%tipo_ponto%"=="4" goto menu

echo.
echo Pontos de restauracao disponiveis:
powershell -Command "Get-ComputerRestorePoint | Select-Object -Property SequenceNumber, Description, @{Name='CreateTime';Expression={[datetime]::FromFileTime($_.CreationTime)}} | Format-Table -AutoSize"
echo.
pause
goto menu

:: ========== FIM DO SCRIPT ==========