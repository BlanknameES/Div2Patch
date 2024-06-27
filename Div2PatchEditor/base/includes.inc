include 'win32w.inc'

;--------------------------------------------------
; Unicode

GetModuleFileNameSafe equ GetModuleFileNameSafeW
MemError equ MemErrorW
PathCombine equ PathCombineW
PathIsFile equ PathIsFileW
PathRemoveFileSpec equ PathRemoveFileSpecW
WritePrivateProfileInt equ WritePrivateProfileIntW

;--------------------------------------------------
; Equates

;HINSTANCE equ DWORD
;HWND equ DWORD
;HBRUSH equ DWORD
;HFONT equ DWORD

;--------------------------------------------------
; VERSIONINFO extra constants

VS_FF_RELEASE         = 0x00000000 ;non-standard
VS_FF_DEBUG           = 0x00000001
VS_FF_PRERELEASE      = 0x00000002
VS_FF_PATCHED         = 0x00000004
VS_FF_PRIVATEBUILD    = 0x00000008
VS_FF_INFOINFERRED    = 0x00000010
VS_FF_SPECIALBUILD    = 0x00000020
VS_FFI_FILEFLAGSMASK  = 0x0000003F

;--------------------------------------------------
; INITCOMMONCONTROLSEX extra constants

ICC_PAGESCROLLER_CLASS  = 1000h
ICC_NATIVEFNTCTL_CLASS  = 2000h
ICC_STANDARD_CLASSES    = 4000h ;v6.0+
ICC_LINK_CLASS          = 8000h ;v6.0+

ICC_ALL_CLASSES         = 0xFFFF

;--------------------------------------------------
; FontQuality Enum extra constants

CLEARTYPE_QUALITY = 5

;--------------------------------------------------
; GetFileAttributes extra constants

INVALID_FILE_ATTRIBUTES = 0xFFFFFFFF

;--------------------------------------------------
; SetFilePointerEx extra constants

INVALID_SET_FILE_POINTER = 0xFFFFFFFF

;--------------------------------------------------
; Patcher

PS_OPEN_NOT = 0
PS_OPEN_ING = 1
PS_OPEN_RDY = 2

PS_TYPE_UNK = -1
PS_TYPE_ID0 = 0 ;v1.4.700.38 (Divinity2.exe)
PS_TYPE_ID1 = 1 ;v1.4.700.41 (Divinity2-debug.exe)
PS_TYPE_ID2 = 2 ;v1.4.700.47 (Divinity2-debug.exe)
PS_TYPE_ID3 = 3 ;v1.4.700.49 (Divinity2.exe)
PS_TYPE_ID4 = 4 ;v1.4.700.56 (Divinity2.exe)
PS_TYPE_ID5 = 5 ;v1.4.700.57 (Divinity2-debug.exe)

PS_STAT_UNK = -1
PS_STAT_UNP = 0
PS_STAT_PAT = 1
PS_STAT_MOD = 2
PS_STAT_OLD = 3

struct PATCHERTARGET

        IsFileOpen      dd ?
        FileTypeId      dd ?
        FileHandle      dd ?
        FileSize        dd ?
        FileStatus      dd ?
        MemBuffer       dd ?
ends

struct FILEPATCHER

        Target1         PATCHERTARGET ;Divinity2.exe
        Target2         PATCHERTARGET ;Divinity2-debug.exe
ends

;--------------------------------------------------
; Ini

struct INISECTIONMAIN

        EnablePatch     dd ?
ends

struct INISECTIONOPTIONS

        GlobalFPS       dd ?
        ExControls      dd ?
        ExGraphics      dd ?
        ExSwitches      dd ?
ends

struct INISETTINGS

        Main            INISECTIONMAIN
        Options         INISECTIONOPTIONS
ends
