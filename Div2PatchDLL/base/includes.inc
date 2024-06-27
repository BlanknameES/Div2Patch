include 'win32w.inc'

GetModuleFileNameSafe equ GetModuleFileNameSafeW
GetIniFileName equ GetIniFileNameW

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

struct MODULEINFO

        lpBaseOfDll             dd ?
        SizeOfImage             dd ?
        EntryPoint              dd ?
ends

;--------------------------------------------------

define PATCH_TEMP_PROC PatchTrap
define PATCH_TEMP_ADDR PatchTrap.addr

struct PATCHMODULEINFO

        dwDefImageBase          dd ?
        dwCurImageBase          dd ?
ends

;--------------------------------------------------

struct FPSLIMITER

        bInitialized            dd ?
        bUseQPC                 dd ?
        fSleepThresholdMS       dd ? ;Windows min timer resolution is ~1.8ms
        fMaxFPS                 dd ?
        bEnabled                dd ?
        fFrequency              dq ?
        fTimeStep               dq ?
        fSleepThreshold         dq ?
        fCurrentTime            dq ?
        fLastTime               dq ?
ends
