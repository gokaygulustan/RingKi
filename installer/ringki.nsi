Unicode true
Name "RingKi"
OutFile "dist/RingKi-Setup-Windows-x86.exe"
InstallDir "$LOCALAPPDATA\Programs\RingKi"
RequestExecutionLevel user
SetCompressor /SOLID lzma
Icon "resources/ringki.ico"
UninstallIcon "resources/ringki.ico"

Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

Section "RingKi" SEC_MAIN
  SetShellVarContext current
  SetOutPath "$INSTDIR"
  File "dist\RingKi\RingKi.exe"
  File "dist\RingKi\README.md"
  File "dist\RingKi\SOURCES.md"
  File "dist\RingKi\LICENSE"
  SetOutPath "$INSTDIR\resources"
  File "dist\RingKi\resources\*.wav"
  SetOutPath "$INSTDIR\LICENSES"
  File "dist\RingKi\LICENSES\*"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateDirectory "$SMPROGRAMS\RingKi"
  CreateShortcut "$SMPROGRAMS\RingKi\RingKi.lnk" "$INSTDIR\RingKi.exe" "" "$INSTDIR\RingKi.exe" 0
  CreateShortcut "$SMPROGRAMS\RingKi\Kaldır.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
  SetShellVarContext current
  Delete "$SMPROGRAMS\RingKi\RingKi.lnk"
  Delete "$SMPROGRAMS\RingKi\Kaldır.lnk"
  RMDir "$SMPROGRAMS\RingKi"
  RMDir /r "$INSTDIR"
  ; Kullanıcı ayarları ve kendi sesleri %APPDATA%\RingKi altında kalır.
SectionEnd
