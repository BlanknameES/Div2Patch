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

proc ZeroMemory Destination,Length

        push    edi
        mov     ecx,dword[Length]
        mov     edx,ecx
        xor     eax,eax
        shr     ecx,2
        mov     edi,dword[Destination]
        rep     stosd
        mov     ecx,edx
        and     ecx,3 
        rep     stosb               
        pop     edi
        ret
endp

;--------------------------------------------------

proc PathIsFileW pszPath

        xor     eax,eax
        mov     ecx,dword[pszPath]
        test    ecx,ecx
        jz      .end
        cmp     word[ecx],ax
        je      .end
        invoke  GetFileAttributesW,ecx
        xor     ecx,ecx
        test    eax,FILE_ATTRIBUTE_DIRECTORY
        setz    cl
        cmp     eax,INVALID_FILE_ATTRIBUTES
        sbb     eax,eax
        and     eax,ecx
        .end:
        ret
endp

;--------------------------------------------------

proc GetFileSizeByHandleECX hFile

        push    ebx
        invoke  SetLastError,0
        lea     eax,dword[hFile] ;FileSizeHigh
        invoke  GetFileSize,dword[hFile],eax
        mov     ebx,eax ;FileSizeLow
        invoke  GetLastError
        xor     ecx,ecx
        test    eax,eax
        setz    cl
        mov     eax,ebx ;FileSizeLow
        mov     edx,dword[hFile] ;FileSizeHigh
        pop     ebx
        ret
endp

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

proc WritePrivateProfileIntW lpAppName,lpKeyName,nInteger,lpFileName

        locals
                szTempStr rw 16
                szConvFmt du '%ld',0
        endl

        push    ebx
        lea     ebx,[szTempStr]
        lea     eax,[szConvFmt]
        cinvoke wsprintfW,ebx,eax,dword[nInteger]
        invoke  WritePrivateProfileStringW,dword[lpAppName],dword[lpKeyName],ebx,dword[lpFileName]
        pop     ebx
        ret
endp

;--------------------------------------------------

proc MemInit bMT

        xor     eax,eax
        mov     ecx,dword[bMT]
        test    ecx,ecx
        setz    al
        invoke  HeapCreate,eax,0x1000,0
        mov     dword[hHeap],eax
        test    eax,eax
        jz      .error0
        ret
        .error0:
        stdcall MemError,0,dword[esp+4]
endp

proc MemAlloc nSize

        mov     eax,dword[nSize]
        test    eax,eax
        jz      .end
        invoke  HeapAlloc,dword[hHeap],0,eax
        test    eax,eax
        jz      .error1
        .end:
        ret
        .error1:
        stdcall MemError,1,dword[esp+4]
endp

proc MemFree lpMem

        mov     eax,dword[lpMem]
        test    eax,eax
        jz      .end
        invoke  HeapFree,dword[hHeap],0,eax
        test    eax,eax
        jz      .error2
        .end:
        ret
        .error2:
        stdcall MemError,2,dword[esp+4]
endp

proc MemResize lpMem,nSize

        mov     edx,dword[lpMem]
        mov     ecx,dword[nSize]
        lea     eax,[ecx+edx]
        test    eax,eax
        jz      .end
        test    ecx,ecx
        jz      .free
        test    edx,edx
        jz      .alloc
        invoke  HeapReAlloc,dword[hHeap],0,edx,ecx
        test    eax,eax
        jz      .error3
        .end:
        ret
        .error3:
        stdcall MemError,3,dword[esp+4]

        .alloc:
        invoke  HeapAlloc,dword[hHeap],0,ecx
        test    eax,eax
        jz      .end
        ret
        .error1:
        stdcall MemError,1,dword[esp+4]

        .free:
        invoke  HeapFree,dword[hHeap],0,edx
        test    eax,eax
        jz     .error2
        ret
        .error2:
        stdcall MemError,2,dword[esp+4]
endp

proc MemErrorW ErrorCode,ErrorOffset

        locals
                msgbuf rw 32
                capbuf rw 32
                errcap du 'Heap Error Code: 0x%08X',0
                errmsg du 'Virtual Address: 0x%08X',0
        endl

        lea     esi,[msgbuf]
        lea     edi,[capbuf]
        and     word[esi],0
        and     word[edi],0
        sub     dword[ErrorOffset],5
        lea     eax,[errcap]
        cinvoke wsprintfW,esi,eax,dword[ErrorCode]
        lea     eax,[errmsg]
        cinvoke wsprintfW,edi,eax,dword[ErrorOffset]
        invoke  MessageBox,0,edi,esi,MB_OK+MB_ICONERROR
        invoke  ExitProcess,0xFF
endp

;--------------------------------------------------

proc DPatchRelAddr lpBaseAddress,lpDestAddress

        mov     eax,1 ;TODO: anything meaningful?
        mov     ecx,dword[lpBaseAddress]
        mov     edx,dword[lpDestAddress]
        lea     edx,[edx-ecx+4]
        mov     dword[ecx],edx
        ret
endp

proc DPatchCodeCave lpBaseAddress,lpDestProc,nSize

        push    ebx esi
        mov     ebx,dword[nSize]
        xor     eax,eax
        cmp     ebx,5
        jb      .end
        mov     esi,dword[lpBaseAddress]
        mov     byte[esi],0xE9
        inc     esi
        stdcall DPatchRelAddr,esi,dword[lpDestProc]
        sub     ebx,5
        jz      .end
        add     esi,4
        .loop:
        mov     byte[esi],0x90
        inc     esi
        dec     ebx
        jnz     .loop
        .end:
        pop     esi ebx
        ret
endp

proc DPatchCopyList lpBaseAddress,lpPatchList,bPatched ;TODO: use structs

        locals
                NumPatches rd 1
        endl

        push    ebx esi edi
        mov     ecx,dword[lpPatchList]
        mov     eax,dword[ecx] ;num patches
        test    eax,eax
        jz      .end
        mov     dword[NumPatches],eax
        mov     ebx,dword[lpBaseAddress]
        lea     esi,[ecx+4] ;ptr first patch
        neg     dword[bPatched]
        sbb     edi,edi
        .rep:
        mov     edx,dword[esi+4]
        mov     ecx,edx
        and     ecx,edi
        lea     ecx,[esi+8+ecx]
        mov     eax,ebx
        add     eax,dword[esi+0]
        stdcall CopyMemory,eax,ecx,edx
        mov     eax,dword[esi+4]
        lea     esi,[esi+8+eax*2]
        dec     dword[NumPatches]
        jnz     .rep
        mov     eax,1
        .end:
        pop     edi esi ebx
        ret
endp

proc DPatchCompList lpBaseAddress,lpPatchList,bPatched ;TODO: use structs

        locals
                NumPatches rd 1
                bEqual rd 1
        endl

        push    ebx esi edi
        mov     ecx,dword[lpPatchList]
        mov     eax,dword[ecx] ;num patches
        test    eax,eax
        jz      .end
        mov     dword[bEqual],1
        mov     dword[NumPatches],eax
        mov     ebx,dword[lpBaseAddress]
        lea     esi,[ecx+4] ;ptr first patch
        neg     dword[bPatched]
        sbb     edi,edi
        .rep:
        mov     edx,dword[esi+4]
        mov     ecx,edx
        and     ecx,edi
        lea     ecx,[esi+8+ecx]
        mov     eax,ebx
        add     eax,dword[esi+0]
        stdcall EqualMemory,eax,ecx,edx
        and     dword[bEqual],eax
        mov     eax,dword[esi+4]
        lea     esi,[esi+8+eax*2]
        dec     dword[NumPatches]
        jnz     .rep
        mov     eax,dword[bEqual]
        .end:
        pop     edi esi ebx
        ret
endp
