directory       RT_VERSION,versions

;--------------------------------------------------

resource versions,\
                IDV_MAIN,LANG_ENGLISH+SUBLANG_DEFAULT,version_info

;--------------------------------------------------

versioninfoex version_info,\
                VER_FILEVERSION,VER_PRODUCTVERSION,VER_FILEFLAGSMASK,VER_FILEFLAGS,VER_FILEOS,VER_FILETYPE,VER_FILESUBTYPE,VER_LANGID,VER_CHARSETID,\
                'FileDescription',<FileDescription>,\
                'FileVersion',<FileVersion>,\
                'ProductName',<ProductName>,\
                'ProductVersion',<ProductVersion>,\
                'LegalCopyright',<LegalCopyright>,\
                'OriginalFilename',<OriginalFileName>
