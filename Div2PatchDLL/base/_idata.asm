library advapi32,'ADVAPI32.DLL',\
        comctl32,'COMCTL32.DLL',\
        comdlg32,'COMDLG32.DLL',\
        gdi32,'GDI32.DLL',\
        kernel32,'KERNEL32.DLL',\
        shell32,'SHELL32.DLL',\
        user32,'USER32.DLL',\
        wsock32,'WSOCK32.DLL',\
        psapi,'PSAPI.DLL',\
        shlwapi,'SHLWAPI.DLL',\
        winmm,'WINMM.DLL'

include 'api\advapi32.inc'
include 'api\comctl32.inc'
include 'api\comdlg32.inc'
include 'api\gdi32.inc'
include 'api\kernel32.inc'
include 'api\shell32.inc'
include 'api\user32.inc'
include 'api\wsock32.inc'

import  psapi,\
        GetModuleInformation,'GetModuleInformation'

import  shlwapi,\
        PathRenameExtensionW,'PathRenameExtensionW'

import  winmm,\
        timeGetTime,'timeGetTime',\
        timeBeginPeriod,'timeBeginPeriod',\
        timeEndPeriod,'timeEndPeriod'
