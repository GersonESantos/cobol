# run.ps1 - compila e executa o olamundo.cob (PowerShell)
# Usa variáveis temporárias de ambiente para garantir include/lib/bin corretos.

# Ajuste estes caminhos se necessário
$gnucobol = 'C:\MinGW\share\gnucobol'
$mingwbin  = 'C:\MinGW\bin'

# Temporário nesta sessão
$env:COBOL_HOME   = $gnucobol
$env:CPATH        = "$gnucobol\include"
$env:LIBRARY_PATH = "$gnucobol\lib"
$env:PATH         = "$mingwbin;$gnucobol\bin;" + $env:PATH

Write-Host "Compilando olamundo.cob..."
$c = cobc -x -o olamundo.exe olamundo.cob 2>&1
Write-Host $c

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro na compilação (exit code $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Executando olamundo.exe..." -ForegroundColor Green
.\olamundo.exe

Write-Host "\nPrograma finalizado. Pressione Enter para sair..."
Read-Host | Out-Null
