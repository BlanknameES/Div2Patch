proc strnlen c str,num

        xor     eax,eax
        mov     ecx,dword[num]
        jecxz   .end
        push    edi
        mov     edi,dword[str]
        mov     edx,ecx
        repne   scasb
        mov     eax,edx
        jne     @F
        lea     eax,[edi-1]
        sub     eax,dword[str]
        @@:
        pop     edi
        .end:
        ret
endp

proc wcsnlen c wcs,num

        xor     eax,eax
        mov     ecx,dword[num]
        jecxz   .end
        push    edi
        mov     edi,dword[wcs]
        mov     edx,ecx
        repne   scasw
        mov     eax,edx
        jne     @F
        lea     eax,[edi-2]
        sub     eax,dword[wcs]
        shr     eax,1
        @@:
        pop     edi
        .end:
        ret
endp

;--------------------------------------------------

proc CopyMemory Destination,Source,Length

        push    esi edi
        mov     ecx,dword[Length]
        mov     esi,dword[Source]
        mov     edi,dword[Destination]
        mov     edx,ecx
        shr     ecx,2
        rep     movsd
        mov     ecx,edx
        and     ecx,3
        rep     movsb
        pop     edi esi
        ret
endp

proc EqualMemory Source1,Source2,Length

        push    esi edi
        xor     eax,eax
        mov     ecx,dword[Length]
        mov     esi,dword[Source2]
        mov     edi,dword[Source1]
        mov     edx,ecx
        shr     ecx,2
        repe    cmpsd
        sete    al
        mov     ecx,edx
        and     ecx,3
        repe    cmpsb
        sete    cl
        and     al,cl
        pop     edi esi
        ret
endp

;--------------------------------------------------

proc GetModuleFileNameSafeW hModule,lpFilename,nSize

        locals
                TmpFilename rw MAX_PATH
        endl

        push    ebx esi edi
        xor     ebx,ebx
        mov     esi,dword[nSize]
        mov     edi,dword[lpFilename]
        cmp     esi,ebx
        je      .end
        cmp     edi,ebx
        je      .end
        and     word[edi],bx
        lea     eax,[TmpFilename]
        invoke  GetModuleFileNameW,dword[hModule],eax,esi
        mov     ebx,eax
        lea     ecx,[eax-1]
        dec     esi
        cmp     ecx,esi
        sbb     edx,edx
        and     ebx,edx
        and     word[edi],dx
        lea     ecx,[eax*2+2]
        lea     eax,[TmpFilename]
        stdcall CopyMemory,edi,eax,ecx
        .end:
        mov     eax,ebx
        pop     edi esi ebx
        ret
endp

proc GetModuleInfo hModule,lpmodinfo,cb

        push    ebx
        invoke  GetModuleHandle,dword[hModule]
        test    eax,eax
        jz      .end
        mov     ebx,eax
        invoke  GetCurrentProcess
        invoke  GetModuleInformation,eax,ebx,dword[lpmodinfo],dword[cb]
        .end:
        pop     ebx
        ret
endp

;--------------------------------------------------

proc PatchTrap

        push     dword[esp+4]
        pop      dword[0xDEADC0DE]
        .addr = $ - 4
        ;TODO: show warning?
        invoke   ExitProcess,-1 ;EXIT_FAILURE
endp

proc GetRealAddress pPMI,pBaseAddress

        mov     eax,dword[pBaseAddress]
        mov     ecx,dword[pPMI]
        sub     eax,dword[ecx+PATCHMODULEINFO.dwDefImageBase]
        add     eax,dword[ecx+PATCHMODULEINFO.dwCurImageBase]
        ret
endp

proc MPatchByte pBaseAddress,uByte

        lea     eax,[uByte]
        stdcall MPatchBuffer,dword[pBaseAddress],eax,1
        ret
endp

proc MPatchWord pBaseAddress,uWord

        lea     eax,[uWord]
        stdcall MPatchBuffer,dword[pBaseAddress],eax,2
        ret
endp

proc MPatchDword pBaseAddress,uDword

        lea     eax,[uDword]
        stdcall MPatchBuffer,dword[pBaseAddress],eax,4
        ret
endp

proc MPatchAddress pBaseAddress,pDestAddress,bRelAddr

        push    ebx
        mov     eax,dword[pBaseAddress]
        lea     ecx,[eax+4]
        lea     edx,[pDestAddress]
        neg     dword[bRelAddr]
        sbb     ebx,ebx
        and     ecx,ebx
        sub     dword[edx],ecx
        stdcall MPatchBuffer,eax,edx,4
        pop     ebx
        ret
endp

proc MPatchCodeCave pBaseAddress,pCodeCave,nSize

        push    ebx esi
        mov     ebx,dword[nSize]
        xor     eax,eax
        cmp     ebx,5
        jb      .end
        mov     esi,dword[pBaseAddress]
        lea     eax,[nSize] ;use nSize to store bytes
        mov     byte[eax],0xE9
        stdcall MPatchBuffer,esi,eax,1
        test    eax,eax
        jz      .end
        inc     esi
        stdcall MPatchAddress,esi,dword[pCodeCave],1
        test    eax,eax
        jz      .end
        sub     ebx,5
        jz      .end
        add     esi,4
        mov     byte[nSize],0x90 ;0xCC
        .loop:
        lea     eax,[nSize]
        stdcall MPatchBuffer,esi,eax,1
        test    eax,eax
        jz      .end
        inc     esi
        dec     ebx
        jnz     .loop
        .end:
        pop     esi ebx
        ret
endp

proc MPatchBuffer pBaseAddress,pBuffer,nSize

        push    ebx esi edi
        mov     ebx,dword[nSize]
        mov     esi,dword[pBaseAddress]
        mov     edi,dword[pBuffer]
        xor     eax,eax
        cmp     ebx,eax
        je      .end
        lea     eax,[nSize] ;store lpflOldProtect at nSize
        invoke  VirtualProtect,esi,ebx,PAGE_EXECUTE_READWRITE,eax
        test    eax,eax
        jz      .end
        invoke  GetCurrentProcess
        invoke  WriteProcessMemory,eax,esi,edi,ebx,0
        mov     edi,eax
        lea     eax,[nSize]
        invoke  VirtualProtect,esi,ebx,dword[eax],eax
        test    eax,eax
        jz      .end
        test    edi,edi
        setnz   cl
        movzx   eax,cl
        .end:
        pop     edi esi ebx
        ret
endp
