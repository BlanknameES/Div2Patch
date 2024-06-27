;--------------------------------
;Include Modern UI

    !include "MUI2.nsh"

;--------------------------------
;Defines

    !define VERSION "0.97"
    !define INSTFILES "InstallFiles"
    !define /file TEXT_TOP "Data\Text_Top.txt"
    !define /file TEXT_MID "Data\Text_Mid.txt"
    !define MUI_TEXT_DIRECTORY_SUBTITLE "${TEXT_TOP}"
    !define MUI_DIRECTORYPAGE_TEXT_TOP "${TEXT_MID}"
    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN "$INSTDIR\bin\Div2Patch.exe"

;--------------------------------
;Backup Macros

    !macro BackupFile ORG_DIR ORG_FILE BUP_DIR BUP_FILE
        IfFileExists "${ORG_DIR}\${ORG_FILE}" 0 +4
            IfFileExists "${BUP_DIR}\*.*" +2
                CreateDirectory "${BUP_DIR}"
            Rename "${ORG_DIR}\${ORG_FILE}" "${BUP_DIR}\${BUP_FILE}"
    !macroend

    !macro RestoreFile BUP_DIR BUP_FILE ORG_DIR ORG_FILE
        IfFileExists "${BUP_DIR}\${BUP_FILE}" 0 +2
            Rename "${BUP_DIR}\${BUP_FILE}" "${ORG_DIR}\${ORG_FILE}"
        IfFileExists "${BUP_DIR}\*.*" 0 +2
            RMDir "${BUP_DIR}"
    !macroend

;--------------------------------
;General

    Unicode true
    ShowInstDetails show
    ShowUninstDetails show

    ;Name and file
    Name "Div2Patch"
    OutFile "Div2Patch_v${VERSION}_Setup.exe"

    ;Default installation folder
    InstallDir "$PROGRAMFILES\Divinity II - Developers Cut\"

    ;Get installation folder from registry if available
    ;InstallDirRegKey HKCU "Software\??" "Path"

    ;Request application privileges for Windows Vista
    RequestExecutionLevel admin
    
;--------------------------------
;Interface Settings

    ;!define MUI_LANGDLL_ALLLANGUAGES
    ;!define MUI_ICON "Data\Icon.ico"
    ;!define MUI_UNICON "Data\Icon.ico"
    ;!define MUI_HEADERIMAGE
    ;!define MUI_HEADERIMAGE_BITMAP "Data\Logo.bmp"
    ;!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
    ;!define MUI_HEADERIMAGE_RIGHT
    !define MUI_BGCOLOR FFFFFF
    !define MUI_TEXTCOLOR 000000
    !define MUI_HEADER_TRANSPARENT_TEXT

;--------------------------------
;Pages

    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

    !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Install Files"

    DetailPrint "Backing up files..."
    CreateDirectory "$INSTDIR\Div2PatchBackup"
    !insertmacro BackupFile "$INSTDIR\bin" "Divinity2.exe" "$INSTDIR\Div2PatchBackup\bin" "Divinity2.exe.bak"
    !insertmacro BackupFile "$INSTDIR\bin" "Divinity2-debug.exe" "$INSTDIR\Div2PatchBackup\bin" "Divinity2-debug.exe.bak"
    !insertmacro BackupFile "$INSTDIR\Data" "globalswitches.xml" "$INSTDIR\Div2PatchBackup\Data" "globalswitches.xml.bak"

    DetailPrint "Installing files..."
    SetOutPath "$INSTDIR\bin"
    File "${INSTFILES}\bin\Div2Patch.dll"
    File "${INSTFILES}\bin\Div2Patch.exe"
    File "${INSTFILES}\bin\Div2Patch.ini"
    File "${INSTFILES}\bin\Divinity2.exe"
    File "${INSTFILES}\bin\Divinity2-debug.exe"
    SetOutPath "$INSTDIR\Data"
    File "${INSTFILES}\Data\globalswitches.xml"

    DetailPrint "Deleting old unused files..."
    Delete "$INSTDIR\bin\Div2PatchEditor.exe"
    Delete "$INSTDIR\bin\Divinity2.dll"
    Delete "$INSTDIR\bin\Divinity2.ini"

    DetailPrint "Writing uninstaller..."
    WriteUninstaller "$INSTDIR\Div2PatchUninstaller.exe"
    ;CreateShortCut "$DESKTOP\Div2PatchUninstaller.lnk" "$INSTDIR\Div2PatchUninstaller.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

    DetailPrint "Uninstalling files..."
    Delete "$INSTDIR\bin\Div2Patch.dll"
    Delete "$INSTDIR\bin\Div2Patch.exe"
    Delete "$INSTDIR\bin\Div2Patch.ini"
    Delete "$INSTDIR\bin\Divinity2.exe"
    Delete "$INSTDIR\bin\Divinity2-debug.exe"
    RMDir "$INSTDIR\bin"
    Delete "$INSTDIR\Data\globalswitches.xml"
    RMDir "$INSTDIR\Data"
    
    DetailPrint "Restoring backed up files..."
    !insertmacro RestoreFile "$INSTDIR\Div2PatchBackup\bin" "Divinity2.exe.bak" "$INSTDIR\bin" "Divinity2.exe"
    !insertmacro RestoreFile "$INSTDIR\Div2PatchBackup\bin" "Divinity2-debug.exe.bak" "$INSTDIR\bin" "Divinity2-debug.exe"
    !insertmacro RestoreFile "$INSTDIR\Div2PatchBackup\Data" "globalswitches.xml.bak" "$INSTDIR\Data" "globalswitches.xml"
    RMDir "$INSTDIR\Div2PatchBackup"

    DetailPrint "Deleting uninstaller..."
    Delete "$INSTDIR\Div2PatchUninstaller.exe"
    ;Delete "$DESKTOP\Div2PatchUninstaller.lnk"

SectionEnd
