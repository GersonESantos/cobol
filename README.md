# cobol

Quick notes to compile and run the sample `olamundo.cob` with GnuCOBOL on Windows (PowerShell).

Prerequisites
- GnuCOBOL (cobc) built for MinGW is installed (example path: `C:\MinGW`).

Compile
```powershell
# compile with verbose output and create olamundo.exe
# Compile com saída detalhada e crie olamundo.exe
cobc -x -v -o olamundo.exe olamundo.cob
```

Run
```powershell
.\olamundo.exe
```

Recommended environment variables
If the compiler fails with errors such as "fatal error: libcob.h: No such file or directory" or the linker cannot find `-lcob`, set these environment variables.

Temporary (current PowerShell session only)

Variáveis ​​de ambiente recomendadas
Se o compilador falhar com erros como "erro fatal: libcob.h: Arquivo ou diretório inexistente" ou se o vinculador não encontrar `-lcob`, defina estas variáveis ​​de ambiente.

Temporário (somente para a sessão atual do PowerShell)

```powershell
$env:CPATH = 'C:\MinGW\share\gnucobol\include'
$env:LIBRARY_PATH = 'C:\MinGW\share\gnucobol\lib'
$env:PATH = 'C:\MinGW\bin;C:\MinGW\share\gnucobol\bin;' + $env:PATH
```

Persistent (User-level) — no admin required
Run these once to persist for your Windows user (then restart terminals):

Persistente (nível de usuário) — não requer privilégios de administrador
Execute estes comandos uma vez para que as alterações sejam permanentes para o seu usuário do Windows (e reinicie os terminais):


```powershell
$minGWBin   = 'C:\MinGW\bin'
$gncBin     = 'C:\MinGW\share\gnucobol\bin'
$gncInclude = 'C:\MinGW\share\gnucobol\include'
$gncLib     = 'C:\MinGW\share\gnucobol\lib'

# prepend to the User PATH if not already present
# Adicionar ao PATH do usuário se ainda não estiver presente
$userPath = [Environment]::GetEnvironmentVariable('Path','User')
$prefix = "$minGWBin;$gncBin;"
if ($userPath -notmatch [regex]::Escape($minGWBin)) {
	[Environment]::SetEnvironmentVariable('Path', $prefix + $userPath, 'User')
}

#[persist CPATH and LIBRARY_PATH]
#[persistir CPATH e LIBRARY_PATH]
[Environment]::SetEnvironmentVariable('CPATH', $gncInclude, 'User')
[Environment]::SetEnvironmentVariable('LIBRARY_PATH', $gncLib, 'User')

# After running the above, close and reopen any terminals to pick up the new User environment.
Após executar o comando acima, feche e abra novamente todos os terminais para que o novo ambiente de usuário seja reconhecido.
```

Quick diagnostic commands
```powershell
# check header and lib exist
# Verificar se o cabeçalho e a biblioteca existem
Test-Path 'C:\MinGW\share\gnucobol\include\libcob.h'
Test-Path 'C:\MinGW\share\gnucobol\lib\libcob.a'

# compile and save verbose log
# compilar e salvar log detalhado
cobc -x -v -o olamundo.exe olamundo.cob 2>&1 | Tee-Object cobc_verbose_current.txt

# run and capture stdout/stderr in PowerShell
# Executar e capturar stdout/stderr no PowerShell
.\olamundo.exe *> run_stdout_pwsh.txt
Get-Content run_stdout_pwsh.txt -TotalCount 200
```

Notes and troubleshooting
- If `libcob.h` is missing, make sure `CPATH` points to the `...\\share\\gnucobol\\include` directory.
- If the linker cannot find `-lcob`, ensure `LIBRARY_PATH` points to `...\\share\\gnucobol\\lib` and `PATH` includes `...\\share\\gnucobol\\bin` (DLLs).
- If you prefer a POSIX-like environment, consider installing MSYS2 or using WSL and installing packages there — many users find GnuCOBOL easier to manage in those environments.

If you want an automated helper script, a `run.ps1`/`run_diag.ps1` can be added to compile with verbose logging and capture program output.

Happy hacking — open an issue or message if you want me to add a `run_diag.ps1` that automates these steps.
