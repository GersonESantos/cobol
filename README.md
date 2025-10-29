# cobol

Quick notes to compile and run the sample `olamundo.cob` with GnuCOBOL on Windows (PowerShell).

Prerequisites
- GnuCOBOL (cobc) built for MinGW is installed (example path: `C:\MinGW`).

Compile
```powershell
# compile with verbose output and create olamundo.exe
cobc -x -v -o olamundo.exe olamundo.cob
```

Run
```powershell
.\olamundo.exe
```

Recommended environment variables
If the compiler fails with errors such as "fatal error: libcob.h: No such file or directory" or the linker cannot find `-lcob`, set these environment variables.

Temporary (current PowerShell session only)
```powershell
$env:CPATH = 'C:\MinGW\share\gnucobol\include'
$env:LIBRARY_PATH = 'C:\MinGW\share\gnucobol\lib'
$env:PATH = 'C:\MinGW\bin;C:\MinGW\share\gnucobol\bin;' + $env:PATH
```

Persistent (User-level) — no admin required
Run these once to persist for your Windows user (then restart terminals):
```powershell
$minGWBin   = 'C:\MinGW\bin'
$gncBin     = 'C:\MinGW\share\gnucobol\bin'
$gncInclude = 'C:\MinGW\share\gnucobol\include'
$gncLib     = 'C:\MinGW\share\gnucobol\lib'

# prepend to the User PATH if not already present
$userPath = [Environment]::GetEnvironmentVariable('Path','User')
$prefix = "$minGWBin;$gncBin;"
if ($userPath -notmatch [regex]::Escape($minGWBin)) {
	[Environment]::SetEnvironmentVariable('Path', $prefix + $userPath, 'User')
}

#[persist CPATH and LIBRARY_PATH]
[Environment]::SetEnvironmentVariable('CPATH', $gncInclude, 'User')
[Environment]::SetEnvironmentVariable('LIBRARY_PATH', $gncLib, 'User')

# After running the above, close and reopen any terminals to pick up the new User environment.
```

Quick diagnostic commands
```powershell
# check header and lib exist
Test-Path 'C:\MinGW\share\gnucobol\include\libcob.h'
Test-Path 'C:\MinGW\share\gnucobol\lib\libcob.a'

# compile and save verbose log
cobc -x -v -o olamundo.exe olamundo.cob 2>&1 | Tee-Object cobc_verbose_current.txt

# run and capture stdout/stderr in PowerShell
.\olamundo.exe *> run_stdout_pwsh.txt
Get-Content run_stdout_pwsh.txt -TotalCount 200
```

Notes and troubleshooting
- If `libcob.h` is missing, make sure `CPATH` points to the `...\\share\\gnucobol\\include` directory.
- If the linker cannot find `-lcob`, ensure `LIBRARY_PATH` points to `...\\share\\gnucobol\\lib` and `PATH` includes `...\\share\\gnucobol\\bin` (DLLs).
- If you prefer a POSIX-like environment, consider installing MSYS2 or using WSL and installing packages there — many users find GnuCOBOL easier to manage in those environments.

If you want an automated helper script, a `run.ps1`/`run_diag.ps1` can be added to compile with verbose logging and capture program output.

Happy hacking — open an issue or message if you want me to add a `run_diag.ps1` that automates these steps.
