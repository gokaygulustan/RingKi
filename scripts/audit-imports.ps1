param([string]$Exe = "build/RingKi.exe")
$allowed = @(
  "kernel32.dll", "user32.dll", "gdi32.dll", "comctl32.dll",
  "comdlg32.dll", "winmm.dll", "shell32.dll", "msvcrt.dll",
  "advapi32.dll", "ole32.dll", "uuid.dll"
)
$lines = & objdump -p $Exe
if ($LASTEXITCODE -ne 0) { throw "objdump failed" }
$imports = @($lines | Select-String -Pattern "DLL Name:" | ForEach-Object { ($_ -split "DLL Name:")[-1].Trim().ToLowerInvariant() } | Sort-Object -Unique)
$bad = @($imports | Where-Object { $_ -notin $allowed })
if ($bad.Count) { throw "Unexpected DLL imports: $($bad -join ', ')" }
Write-Host "Allowed Windows system DLL imports: $($imports -join ', ')"
