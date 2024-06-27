VER_FILEVERSION equ SubProjectLongVer
VER_PRODUCTVERSION equ ProjectLongVer
VER_FILEFLAGSMASK equ VS_FFI_FILEFLAGSMASK
VER_FILEFLAGS equ VS_FF_RELEASE
VER_FILEOS equ VOS_NT_WINDOWS32
VER_FILETYPE equ VFT_DLL
VER_FILESUBTYPE equ VFT2_UNKNOWN
VER_LANGID equ LANG_ENGLISH+SUBLANG_DEFAULT
VER_CHARSETID equ 1200

FileDescription equ SubProjectName
FileVersion equ SubProjectVersion
ProductName equ ProjectName,' by Blankname'
ProductVersion equ ProjectVersion
LegalCopyright equ 'No rights reserved.'
OriginalFileName equ ProjectName,'.dll'

;--------------------------------------------------

IDV_MAIN = 1
