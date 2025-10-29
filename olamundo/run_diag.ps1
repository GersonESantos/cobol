<#
run_diag.ps1

Automates diagnostics for the olamundo sample.
What it does:
 - temporarily prepends MinGW/gnucobol to PATH for this session
 - sets CPATH and LIBRARY_PATH for this session
 - compiles with `cobc -x -v` and saves verbose log to cobc_verbose_current.txt
 - runs the produced exe under PowerShell and under cmd, capturing stdout/stderr
 - checks for files the COBOL program may write (out.txt and C:\Temp\out_cobol.txt)
 - prints a short summary and locations of generated logs

Usage (PowerShell):
  .\run_diag.ps1

#>
[CmdletBinding()]
param()

function Write-Header($s){
    Write-Host "`n=== $s ===" -ForegroundColor Cyan
}

$minGWBin   = 'C:\MinGW\bin'
$gncBin     = 'C:\MinGW\share\gnucobol\bin'
$gncInclude = 'C:\MinGW\share\gnucobol\include'
$gncLib     = 'C:\MinGW\share\gnucobol\lib'

Write-Header "Setup session environment"
$prefix = "$minGWBin;$gncBin;"
# $env:PATH may already contain these; prepend for this session
$env:PATH = $prefix + $env:PATH
$env:CPATH = $gncInclude
$env:LIBRARY_PATH = $gncLib

Write-Host "Session CPATH: $env:CPATH"
Write-Host "Session LIBRARY_PATH: $env:LIBRARY_PATH"
Write-Host "Session PATH (head): " + (($env:PATH -split ';' | Select-Object -First 6) -join ';')

Write-Header "Check required files"
Write-Host "libcob.h exists: " (Test-Path (Join-Path $gncInclude 'libcob.h'))
Write-Host "libcob.a exists: " (Test-Path (Join-Path $gncLib 'libcob.a'))

Write-Header "Compile with cobc (verbose)"
$cobcLog = Join-Path (Get-Location) 'cobc_verbose_current.txt'
try {
    cobc -x -v -o olamundo.exe olamundo.cob 2>&1 | Tee-Object -FilePath $cobcLog
} catch {
    Write-Host "cobc invocation failed: $_" -ForegroundColor Red
}

if (Test-Path .\olamundo.exe) {
    Write-Host "Built: .\olamundo.exe (size:" (Get-Item .\olamundo.exe).Length ")"
} else {
    Write-Host "Build failed: olamundo.exe not found" -ForegroundColor Red
}

Write-Header "Run executable (PowerShell)"
$pwshOut = Join-Path (Get-Location) 'run_stdout_pwsh.txt'
try {
    .\olamundo.exe *> $pwshOut
} catch {
    Write-Host "Execution (pwsh) failed: $_" -ForegroundColor Yellow
}
Write-Host "Exit code (pwsh run): $LASTEXITCODE"

Write-Header "Run executable (cmd)"
$cmdOut = Join-Path (Get-Location) 'run_stdout_cmd.txt'
try {
    cmd /c ".\\olamundo.exe > $cmdOut 2>&1"
} catch {
    Write-Host "Execution (cmd) failed: $_" -ForegroundColor Yellow
}

Write-Header "Check program-created files"
$localOut = Join-Path (Get-Location) 'out.txt'
$absOut = 'C:\Temp\out_cobol.txt'

if (Test-Path $localOut) {
    $fi = Get-Item $localOut
    Write-Host "out.txt => size: $($fi.Length) bytes, lastWrite: $($fi.LastWriteTime)"
    if ($fi.Length -gt 0 -and $fi.Length -lt 200000) { Write-Host "--- out.txt (head) ---"; Get-Content $localOut -TotalCount 100 }
} else { Write-Host "out.txt not present" }

if (Test-Path $absOut) {
    $fi = Get-Item $absOut
    Write-Host "C:\Temp\out_cobol.txt => size: $($fi.Length) bytes, lastWrite: $($fi.LastWriteTime)"
    if ($fi.Length -gt 0 -and $fi.Length -lt 200000) { Write-Host "--- C:\Temp\out_cobol.txt (head) ---"; Get-Content $absOut -TotalCount 100 }
} else { Write-Host "C:\Temp\out_cobol.txt not present" }

Write-Header "Show captured outputs (short)"
if (Test-Path $pwshOut) { Write-Host "PowerShell run output (first 200 lines):"; Get-Content $pwshOut -TotalCount 200 } else { Write-Host "No $pwshOut" }
if (Test-Path $cmdOut) { Write-Host "cmd run output (first 200 lines):"; Get-Content $cmdOut -TotalCount 200 } else { Write-Host "No $cmdOut" }

Write-Header "Summary"
Write-Host "Logs created: $cobcLog, $pwshOut, $cmdOut"
Write-Host 'If the program printed to a file, check the file paths above. If still no visible output, try running under MSYS2 or WSL for alternate environment.'

Write-Host "Run complete."
