proc DllEntryPoint hinstDLL,fdwReason,lpvReserved

        mov     eax,1
        cmp     dword[fdwReason],eax
        jne     .end
        stdcall DllMain,dword[hinstDLL],eax,dword[lpvReserved]
        .end:
        ret
endp

proc DllMain hinstDLL,fdwReason,lpvReserved

        locals
                szModuleFilename rw MAX_PATH
        endl

        lea     eax,[szModuleFilename]
        stdcall GetModuleFileNameSafe,dword[hinstDLL],eax,MAX_PATH
        test    eax,eax
        jz      .end
        lea     eax,[szModuleFilename]
        stdcall GetIniFileName,ini_filename,eax
        test    eax,eax
        jz      .end
        mov     eax,1
        .end:
        ret
endp

proc GetIniFileNameW lpOutFileName,lpInFileName

        locals
                szNewExtension du '.ini',0
        endl

        push    esi edi
        mov     esi,dword[lpInFileName]
        ccall   wcsnlen,esi,MAX_PATH
        lea     ecx,[eax-1]
        cmp     ecx,MAX_PATH-1
        jae     .error
        shl     eax,1
        mov     edi,dword[lpOutFileName]
        stdcall CopyMemory,edi,esi,eax
        lea     eax,[szNewExtension]
        invoke  PathRenameExtensionW,edi,eax
        test    eax,eax
        jz      .error

        .ok:
        mov     eax,1
        pop     edi esi
        ret

        .error:
        xor     eax,eax
        pop     edi esi
        ret
endp

;--------------------------------------------------

proc InitPatch

        stdcall GetGameVersionInfo
        test    eax,eax
        jz      .end
        stdcall ReadIniSettings
        mov     eax,1
        cmp     dword[ini_main_enable],0
        je      .end
        stdcall ApplyPatches
        .end:
        ret
endp

proc ReadIniSettings

        push    ebx
        mov     ebx,ini_filename
        invoke  GetPrivateProfileInt,sec_main,key_enable,dword[def_enable],ebx
        mov     dword[ini_main_enable],eax
        invoke  GetPrivateProfileInt,sec_options,key_globalfps,dword[def_globalfps],ebx
        mov     dword[ini_opts_globalfps],eax
        ;invoke  GetPrivateProfileInt,sec_options,key_exoptions,dword[def_exoptions],ebx
        ;mov     dword[ini_opts_exoptions],eax
        invoke  GetPrivateProfileInt,sec_options,key_excontrols,dword[def_excontrols],ebx
        mov     dword[ini_opts_excontrols],eax
        invoke  GetPrivateProfileInt,sec_options,key_exgraphics,dword[def_exgraphics],ebx
        mov     dword[ini_opts_exgraphics],eax
        invoke  GetPrivateProfileInt,sec_options,key_exswitches,dword[def_exswitches],ebx
        mov     dword[ini_opts_exswitches],eax
        pop     ebx
        ret
endp

proc GetGameVersionInfo

        locals
                moduleinfo MODULEINFO
                version_str rb 16
                sizeof.version_str = 16
        endl

        push    ebx esi edi

        ;get BaseAddress
        lea     eax,[moduleinfo]
        stdcall GetModuleInfo,0,eax,sizeof.MODULEINFO
        test    eax,eax
        jz      .end
        mov     eax,dword[moduleinfo.lpBaseOfDll]
        mov     dword[PMI_Divinity2Exe.dwDefImageBase],0x00400000
        mov     dword[PMI_Divinity2Exe.dwCurImageBase],eax

        ;compare version strings
        xor     ebx,ebx
        invoke  GetCurrentProcess
        mov     esi,eax
        lea     edi,[version_str]

        .loop:
        lea     eax,[ebx*8]
        add     eax,build_id0_addr
        stdcall GetRealAddress,PMI_Divinity2Exe,dword[eax]
        invoke  ReadProcessMemory,esi,eax,edi,sizeof.version_str,0
        test    eax,eax
        jz      .next
        lea     eax,[ebx*8]
        add     eax,build_id0_pstr
        ccall   strnlen,dword[eax],sizeof.version_str
        lea     ecx,[ebx*8]
        add     ecx,build_id0_pstr
        stdcall EqualMemory,edi,dword[ecx],eax
        test    eax,eax
        jnz     .set_ver
        .next:
        inc     ebx
        cmp     ebx,dword[num_version_ids]
        jb      .loop

        .error:
        or      ebx,-1
        xor     eax,eax

        .set_ver:
        mov     dword[GameVersionID],ebx
        .end:
        pop     edi esi ebx
        ret
endp

proc ApplyPatches

        xor     eax,eax
        cmp     dword[GameVersionID],4 ;Divinity2.exe - v1.4.700.56
        je      .id4
        cmp     dword[GameVersionID],5 ;Divinity2-debug.exe - v1.4.700.57
        je      .id5
        .end:
        ret

        .id4:
        stdcall ApplyPatchesNormal
        jmp     .end

        .id5:
        stdcall ApplyPatchesDebug
        jmp     .end
endp
