# run.ps1 - compila e executa o olamundo.cob (PowerShell)
# Usa variáveis temporárias de ambiente para garantir include/lib/bin corretos.
# Ajuste os caminhos $gnucobol e $mingwbin se a sua instalação estiver em outro local.

# Caminhos padrão (mude se necessário)
$gnucobol = 'C:\MinGW\share\gnucobol'
$mingwbin  = 'C:\MinGW\bin'

# Definir variáveis de ambiente apenas para esta sessão do script
$env:COBOL_HOME   = $gnucobol
$env:CPATH        = "$gnucobol\include"
$env:LIBRARY_PATH = "$gnucobol\lib"
$env:COB_SYNC     = "Y" # Força o flush da saída após cada DISPLAY
$env:PATH         = "$mingwbin;$gnucobol\bin;" + $env:PATH

Write-Host "Compilando olamundo.cob..."
$c = cobc -x -o olamundo.exe olamundo.cob 2>&1
Write-Host $c

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro na compilação (exit code $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Executando olamundo.exe..." -ForegroundColor Green
try {
    # Executa no terminal atual para que a saída seja visível
    & .\olamundo.exe
} catch {
    Write-Host "Falha ao executar olamundo.exe: $_" -ForegroundColor Red
}

Write-Host "`nPrograma finalizado. Pressione Enter para sair..."
Read-Host | Out-Null
