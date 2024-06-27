proc start

        invoke  GetCommandLine
        mov     ebx,eax
        invoke  GetModuleHandle,0
        stdcall WinMain,eax,0,ebx,SW_SHOWDEFAULT
        invoke  ExitProcess,eax
endp

proc WinMain hInstance,hPrevInstance,lpCmdLine,nCmdShow

        push    ebx esi
        mov     ebx,dword[hInstance]

        stdcall InitPatcherTargets
        stdcall MemInit,0

        mov     dword[picce.dwSize],sizeof.INITCOMMONCONTROLSEX
        mov     dword[picce.dwICC],ICC_ALL_CLASSES
        invoke  InitCommonControlsEx,picce

        .CreateWndClass:
        stdcall CreateWndClass,ebx
        test    eax,eax
        jz      .error1

        .CreateMainWnd:
        stdcall CreateMainWnd,ebx,0,dword[nCmdShow]
        test    eax,eax
        jz      .error2
        mov     esi,eax

        stdcall SetPatcherTargetsFileName,dword[hInstance]
        stdcall OpenPatcherTargets
        stdcall DisablePatcherControls,esi
        stdcall SetIniSettingsFileName,dword[hInstance]
        stdcall CmdLoadIniSettings,esi,FALSE

        .DoMsgLoop:
        stdcall DoMsgLoop,esi,0
        .end:
        pop     esi ebx
        ret

        .error1:
        invoke  MessageBox,0,registererror,errorcap,MB_OK+MB_ICONERROR
        xor     eax,eax
        jmp     .end

        .error2:
        invoke  MessageBox,0,createerror,errorcap,MB_OK+MB_ICONERROR
        xor     eax,eax
        jmp     .end
endp

proc InitPatcherTargets

        and     dword[FilePatcher.Target1.IsFileOpen],PS_OPEN_NOT ;0
        or      dword[FilePatcher.Target1.FileTypeId],PS_TYPE_UNK ;-1
        or      dword[FilePatcher.Target1.FileHandle],INVALID_HANDLE_VALUE ;-1
        and     dword[FilePatcher.Target1.FileSize],0
        or      dword[FilePatcher.Target1.FileStatus],PS_STAT_UNK; -1
        and     dword[FilePatcher.Target1.MemBuffer],0
        and     dword[FilePatcher.Target2.IsFileOpen],PS_OPEN_NOT ;0
        or      dword[FilePatcher.Target2.FileTypeId],PS_TYPE_UNK ;-1
        or      dword[FilePatcher.Target2.FileHandle],INVALID_HANDLE_VALUE ;-1
        and     dword[FilePatcher.Target2.FileSize],0
        or      dword[FilePatcher.Target2.FileStatus],PS_STAT_UNK; -1
        and     dword[FilePatcher.Target2.MemBuffer],0
        ret
endp

proc CreateWndClass hInstance

        push    ebx
        mov     ebx,wndClassEx
        stdcall ZeroMemory,ebx,sizeof.WNDCLASSEX
        mov     dword[ebx+WNDCLASSEX.cbSize],sizeof.WNDCLASSEX
        mov     dword[ebx+WNDCLASSEX.lpfnWndProc],WindowProc
        push    dword[hInstance]
        pop     dword[ebx+WNDCLASSEX.hInstance]
        invoke  LoadIcon,0,IDI_APPLICATION ;dword[hInstance],IDI_MAIN
        mov     dword[ebx+WNDCLASSEX.hIcon],eax
        invoke  LoadCursor,0,IDC_ARROW ;dword[hInstance],IDC_MAIN
        mov     dword[ebx+WNDCLASSEX.hCursor],eax
        mov     dword[ebx+WNDCLASSEX.hbrBackground],COLOR_BTNFACE+1 ;COLOR_BTNFACE=COLOR_3DFACE
        mov     dword[ebx+WNDCLASSEX.lpszClassName],ClassName
        invoke  RegisterClassEx,ebx
        movzx   eax,ax
        pop     ebx
        ret
endp

proc CreateMainWnd hInstance,hMenu,nCmdShow

        locals
                rect RECT
        endl

        push    ebx esi edi

        lea     ebx,[rect]
        ;invoke  GetDesktopWindow
        ;invoke  GetWindowRect,eax,ebx
        ;mov     eax,dword[ebx+RECT.right]
        ;lea     esi,dword[eax-WindowWidth]
        ;shr     esi,1
        ;mov     eax,dword[ebx+RECT.bottom]
        ;lea     edi,dword[eax-WindowHeight]
        ;shr     edi,1
        invoke  GetSystemMetrics,SM_CXFULLSCREEN
        sub     eax,WindowWidth
        cmp     eax,0x80000000
        sbb     ecx,ecx
        and     eax,ecx
        shr     eax,1
        mov     esi,eax
        invoke  GetSystemMetrics,SM_CYFULLSCREEN
        sub     eax,WindowHeight
        cmp     eax,0x80000000
        sbb     ecx,ecx
        and     eax,ecx
        shr     eax,1
        mov     edi,eax

        and     dword[ebx+RECT.left],0
        and     dword[ebx+RECT.top],0
        mov     dword[ebx+RECT.right],WindowWidth
        mov     dword[ebx+RECT.bottom],WindowHeight
        xor     eax,eax
        cmp     dword[hMenu],0
        setne   al
        invoke  AdjustWindowRectEx,ebx,WindowStyles,eax,WindowExStyles

        mov     eax,dword[ebx+RECT.right]
        sub     eax,dword[ebx+RECT.left]
        mov     ecx,dword[ebx+RECT.bottom]
        sub     ecx,dword[ebx+RECT.top]
        invoke  CreateWindowEx,WindowExStyles,ClassName,WindowName,WindowStyles,esi,edi,eax,ecx,0,dword[hMenu],dword[hInstance],0
        test    eax,eax
        jz      .end

        mov     ebx,eax
        invoke  ShowWindow,ebx,dword[nCmdShow]
        invoke  UpdateWindow,ebx
        mov     eax,ebx

        .end:
        pop     edi esi ebx
        ret
endp

proc SetPatcherTargetsFileName hInstance

        locals
                szModuleDirectory rw MAX_PATH
        endl

        push    ebx
        and     word[FileName_T1],0
        and     word[FileName_T2],0
        lea     ebx,[szModuleDirectory]
        stdcall GetModuleFileNameSafe,dword[hInstance],ebx,MAX_PATH
        test    eax,eax
        jz      .end
        invoke  PathRemoveFileSpec,ebx
        invoke  PathCombine,FileName_T1,ebx,patcher_t1_basename
        invoke  PathCombine,FileName_T2,ebx,patcher_t2_basename
        .end:
        pop     ebx
        ret
endp

proc OpenPatcherTargets

        ;invoke  MessageBox,0,FileName_T1,infocap,MB_OK+MB_ICONINFORMATION
        ;invoke  MessageBox,0,FileName_T2,infocap,MB_OK+MB_ICONINFORMATION
        ret
endp

proc DisablePatcherControls hWnd

        push    ebx esi
        mov     ebx,dword[hWnd]

        mov     esi,IDC_T1_VERSIONTEXT
        .loop_t1:
        invoke  GetDlgItem,ebx,esi
        invoke  EnableWindow,eax,FALSE
        inc     esi
        cmp     esi,IDC_T1_RESTORE
        jbe     .loop_t1

        mov     esi,IDC_T2_VERSIONTEXT
        .loop_t2:
        invoke  GetDlgItem,ebx,esi
        invoke  EnableWindow,eax,FALSE
        inc     esi
        cmp     esi,IDC_T2_RESTORE
        jbe     .loop_t2

        pop     esi ebx
        ret
endp

proc SetIniSettingsFileName hInstance

        locals
                szModuleDirectory rw MAX_PATH
        endl

        push    ebx
        and     word[FileName_INI],0
        lea     ebx,[szModuleDirectory]
        stdcall GetModuleFileNameSafe,dword[hInstance],ebx,MAX_PATH
        test    eax,eax
        jz      .end
        invoke  PathRemoveFileSpec,ebx
        invoke  PathCombine,FileName_INI,ebx,ini_basename
        .end:
        pop     ebx
        ret
endp

proc ResetIniSettings

        push    dword[ini_def_enable]
        pop     dword[IniSettings.Main.EnablePatch]
        push    dword[ini_def_globalfps]
        pop     dword[IniSettings.Options.GlobalFPS]
        push    dword[ini_def_excontrols]
        pop     dword[IniSettings.Options.ExControls]
        push    dword[ini_def_exgraphics]
        pop     dword[IniSettings.Options.ExGraphics]
        push    dword[ini_def_exswitches]
        pop     dword[IniSettings.Options.ExSwitches]
        ret
endp

proc LoadIniSettings

        push    ebx
        mov     ebx,FileName_INI
        invoke  GetPrivateProfileInt,ini_sec_main,ini_key_enable,dword[ini_def_enable],ebx
        mov     dword[IniSettings.Main.EnablePatch],eax
        invoke  GetPrivateProfileInt,ini_sec_patches,ini_key_globalfps,dword[ini_def_globalfps],ebx
        mov     dword[IniSettings.Options.GlobalFPS],eax
        invoke  GetPrivateProfileInt,ini_sec_patches,ini_key_excontrols,dword[ini_def_excontrols],ebx
        mov     dword[IniSettings.Options.ExControls],eax
        invoke  GetPrivateProfileInt,ini_sec_patches,ini_key_exgraphics,dword[ini_def_exgraphics],ebx
        mov     dword[IniSettings.Options.ExGraphics],eax
        invoke  GetPrivateProfileInt,ini_sec_patches,ini_key_exswitches,dword[ini_def_exswitches],ebx
        mov     dword[IniSettings.Options.ExSwitches],eax
        pop     ebx
        ret
endp

proc SaveIniSettings

        push    ebx
        mov     ebx,FileName_INI
        stdcall WritePrivateProfileIntW,ini_sec_main,ini_key_enable,dword[IniSettings.Main.EnablePatch],ebx
        stdcall WritePrivateProfileIntW,ini_sec_patches,ini_key_globalfps,dword[IniSettings.Options.GlobalFPS],ebx
        stdcall WritePrivateProfileIntW,ini_sec_patches,ini_key_excontrols,dword[IniSettings.Options.ExControls],ebx
        stdcall WritePrivateProfileIntW,ini_sec_patches,ini_key_exgraphics,dword[IniSettings.Options.ExGraphics],ebx
        stdcall WritePrivateProfileIntW,ini_sec_patches,ini_key_exswitches,dword[IniSettings.Options.ExSwitches],ebx
        pop     ebx
        ret
endp

proc DoMsgLoop hWnd,hAccel

        locals
                Msg MSG
        endl

        push    ebx esi edi
        lea     ebx,[Msg]
        mov     esi,dword[hWnd]
        ;mov     edi,dword[hAccel]
        .msg_loop:
        invoke  GetMessage,ebx,0,0,0
        test    eax,eax
        jz      .msg_end
        sub     eax,-1
        jnc     .end
        ;invoke  TranslateAccelerator,esi,edi,ebx
        ;test    eax,eax
        ;jnz     .msg_loop
        invoke  IsDialogMessage,esi,ebx
        test    eax,eax
        jnz     .msg_loop
        invoke  TranslateMessage,ebx
        invoke  DispatchMessage,ebx
        jmp     .msg_loop
        .msg_end:
        mov     eax,dword[ebx+MSG.wParam]
        .end:
        pop     edi esi ebx
        ret
endp

proc WindowProc hWnd,uMsg,wParam,lParam

        cmp     dword[uMsg],WM_CREATE
        je      .wmcreate
        cmp     dword[uMsg],WM_COMMAND
        je      .wmcommand
        cmp     dword[uMsg],WM_CLOSE
        je      .wmclose
        cmp     dword[uMsg],WM_DESTROY
        je      .wmdestroy
        .DefWindowProc:
        invoke  DefWindowProc,dword[hWnd],dword[uMsg],dword[wParam],dword[lParam]
        ret

        .wmcreate:
        invoke  GetWindowLong,dword[hWnd],GWL_HINSTANCE
        stdcall CreateWnds,dword[hWnd],eax
        jmp     .end

        .wmcommand:
        cmp     word[wParam+0],IDC_INI_SAVE
        je      .cmd_ini_save
        cmp     word[wParam+0],IDC_INI_RESET
        je      .cmd_ini_reset
        jmp     .end

        .cmd_ini_reset:
        stdcall CmdResetIniSettings,dword[hWnd],FALSE
        jmp     .end

        .cmd_ini_save:
        stdcall CmdSaveIniSettings,dword[hWnd],TRUE
        jmp     .end

        .wmclose:
        invoke  DestroyWindow,dword[hWnd]
        jmp     .end

        .wmdestroy:
        invoke  PostQuitMessage,0
        ;jmp     .end

        .end:
        xor     eax,eax
        .ret:
        ret
endp

proc CreateWnds hWnd,hInstance

        .style_statusbar = WS_VISIBLE+WS_CHILD
        .style_static = WS_VISIBLE+WS_CHILD+SS_LEFTNOWORDWRAP
        .style_staticbox = WS_VISIBLE+WS_CHILD+WS_BORDER+ES_CENTER+WS_DISABLED
        .style_editint = WS_VISIBLE+WS_CHILD+WS_BORDER+WS_TABSTOP+ES_UPPERCASE ;using ES_UPPERCASE as int flag
        .style_editflt = WS_VISIBLE+WS_CHILD+WS_BORDER+WS_TABSTOP+ES_LOWERCASE ;using ES_LOWERCASE as flt flag
        .style_editstr = WS_VISIBLE+WS_CHILD+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL
        .style_checkbox = WS_VISIBLE+WS_CHILD+WS_TABSTOP+BS_AUTOCHECKBOX
        .style_group = WS_VISIBLE+WS_CHILD+BS_GROUPBOX
        .style_button = WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON+WS_TABSTOP
        .style_hseparator = WS_VISIBLE+WS_CHILD+SS_ETCHEDHORZ
        .style_vseparator = WS_VISIBLE+WS_CHILD+SS_ETCHEDVERT

        push    ebx esi edi
        mov     ebx,1
        mov     esi,dword[hWnd]
        mov     edi,dword[hInstance]

        ;patcher target 1
        invoke  CreateWindowEx,0,WC_BUTTON,gb_t1_gb,.style_group,10,10,200,100,esi,IDC_T1_GROUPBOX,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,st_t1_version,.style_static,20,30,90,20,esi,IDC_T1_VERSIONTEXT,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,eb_t1_version,.style_static,110,30,90,20,esi,IDC_T1_VERSION,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,st_t1_status,.style_static,20,50,90,20,esi,IDC_T1_STATUSTEXT,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,eb_t1_status,.style_static,110,50,90,20,esi,IDC_T1_STATUS,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,bu_t1_patch,.style_button,70,80,60,20,esi,IDC_T1_PATCH,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,bu_t1_restore,.style_button,140,80,60,20,esi,IDC_T1_RESTORE,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx

        ;patcher target 2
        invoke  CreateWindowEx,0,WC_BUTTON,gb_t2_gb,.style_group,220,10,200,100,esi,IDC_T2_GROUPBOX,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,st_t2_version,.style_static,230,30,90,20,esi,IDC_T2_VERSIONTEXT,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,eb_t2_version,.style_static,320,30,90,20,esi,IDC_T2_VERSION,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,st_t2_status,.style_static,230,50,90,20,esi,IDC_T2_STATUSTEXT,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,eb_t2_status,.style_static,320,50,90,20,esi,IDC_T2_STATUS,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,bu_t2_patch,.style_button,280,80,60,20,esi,IDC_T2_PATCH,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,bu_t2_restore,.style_button,350,80,60,20,esi,IDC_T2_RESTORE,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx

        ;separator
        invoke  CreateWindowEx,0,WC_STATIC,0,.style_hseparator,10,120,410,2,esi,0,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx

        ;ini stuff
        invoke  CreateWindowEx,0,WC_BUTTON,gb_settings,.style_group,10,130,410,230,esi,IDC_INI_GB,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,st_main,.style_static,20,150,390,50,esi,IDC_MAIN_GB,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,cb_enable,.style_checkbox,30,170,370,20,esi,IDC_MAIN_ENABLE,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_STATIC,st_options,.style_static,20,210,390,110,esi,IDC_OPTIONS_GB,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,cb_globalfps,.style_checkbox,30,230,370,20,esi,IDC_OPTIONS_GLOBALFPS,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,cb_excontrols,.style_checkbox,30,250,370,20,esi,IDC_OPTIONS_EXCONTROLS,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,cb_exgraphics,.style_checkbox,30,270,370,20,esi,IDC_OPTIONS_EXGRAPHICS,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,cb_exswitches,.style_checkbox,30,290,370,20,esi,IDC_OPTIONS_EXSWITCHES,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,bu_save,.style_button,280,330,60,20,esi,IDC_INI_SAVE,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx
        invoke  CreateWindowEx,0,WC_BUTTON,bu_reset,.style_button,350,330,60,20,esi,IDC_INI_RESET,edi,0
        neg     eax
        sbb     ecx,ecx
        and     ebx,ecx

        stdcall InitWnds,esi
        and     ebx,eax

        mov     eax,ebx
        pop     edi esi ebx
        ret
endp

proc InitWnds hWnd

        push    ebx esi
        mov     ebx,dword[hWnd]

        ;use default font for now
        jmp     .setfocus

        .createfonts:
        invoke  CreateFont,-12,-6,0,0,800,FALSE,FALSE,FALSE,ANSI_CHARSET,OUT_RASTER_PRECIS,CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY,VARIABLE_PITCH+FF_SWISS,fnt_arial
        test    eax,eax
        jnz    .setfont
        .fonterror:
        invoke  MessageBox,0,fonterror,warncap,MB_OK+MB_ICONWARNING ;hWnd?

        .setfont:
        push    esi
        mov     esi,eax
        invoke  GetDlgItem,ebx,IDC_T1_PATCH
        invoke  SendMessage,eax,WM_SETFONT,esi,TRUE
        invoke  GetDlgItem,ebx,IDC_T1_RESTORE
        invoke  SendMessage,eax,WM_SETFONT,esi,TRUE
        invoke  GetDlgItem,ebx,IDC_T2_PATCH
        invoke  SendMessage,eax,WM_SETFONT,esi,TRUE
        invoke  GetDlgItem,ebx,IDC_T2_RESTORE
        invoke  SendMessage,eax,WM_SETFONT,esi,TRUE
        invoke  GetDlgItem,ebx,IDC_INI_SAVE
        invoke  SendMessage,eax,WM_SETFONT,esi,TRUE
        invoke  GetDlgItem,ebx,IDC_INI_RESET
        invoke  SendMessage,eax,WM_SETFONT,esi,TRUE
        pop     esi

        .setfocus:
        invoke  SetFocus,ebx
        test    eax,eax
        setnz   al
        movzx   eax,al

        pop     ebx
        ret
endp

proc UpdateIniSettings hWnd

        push    ebx
        mov     ebx,dword[hWnd]

        invoke  GetDlgItem,ebx,IDC_MAIN_ENABLE
        invoke  SendMessage,eax,BM_GETCHECK,0,0
        xor     ecx,ecx
        test    eax,eax
        setnz   cl
        mov     dword[IniSettings.Main.EnablePatch],ecx

        invoke  GetDlgItem,ebx,IDC_OPTIONS_GLOBALFPS
        invoke  SendMessage,eax,BM_GETCHECK,0,0
        xor     ecx,ecx
        test    eax,eax
        setnz   cl
        mov     dword[IniSettings.Options.GlobalFPS],ecx

        invoke  GetDlgItem,ebx,IDC_OPTIONS_EXCONTROLS
        invoke  SendMessage,eax,BM_GETCHECK,0,0
        xor     ecx,ecx
        test    eax,eax
        setnz   cl
        mov     dword[IniSettings.Options.ExControls],ecx

        invoke  GetDlgItem,ebx,IDC_OPTIONS_EXGRAPHICS
        invoke  SendMessage,eax,BM_GETCHECK,0,0
        xor     ecx,ecx
        test    eax,eax
        setnz   cl
        mov     dword[IniSettings.Options.ExGraphics],ecx

        invoke  GetDlgItem,ebx,IDC_OPTIONS_EXSWITCHES
        invoke  SendMessage,eax,BM_GETCHECK,0,0
        xor     ecx,ecx
        test    eax,eax
        setnz   cl
        mov     dword[IniSettings.Options.ExSwitches],ecx

        pop     ebx
        ret
endp

proc UpdateIniControls hWnd

        push    ebx
        mov     ebx,dword[hWnd]

        invoke  GetDlgItem,ebx,IDC_MAIN_ENABLE
        xor     ecx,ecx
        cmp     dword[IniSettings.Main.EnablePatch],0
        setne   cl
        invoke  SendMessage,eax,BM_SETCHECK,ecx,0

        invoke  GetDlgItem,ebx,IDC_OPTIONS_GLOBALFPS
        xor     ecx,ecx
        cmp     dword[IniSettings.Options.GlobalFPS],0
        setne   cl
        invoke  SendMessage,eax,BM_SETCHECK,ecx,0

        invoke  GetDlgItem,ebx,IDC_OPTIONS_EXCONTROLS
        xor     ecx,ecx
        cmp     dword[IniSettings.Options.ExControls],0
        setne   cl
        invoke  SendMessage,eax,BM_SETCHECK,ecx,0

        invoke  GetDlgItem,ebx,IDC_OPTIONS_EXGRAPHICS
        xor     ecx,ecx
        cmp     dword[IniSettings.Options.ExGraphics],0
        setne   cl
        invoke  SendMessage,eax,BM_SETCHECK,ecx,0

        invoke  GetDlgItem,ebx,IDC_OPTIONS_EXSWITCHES
        xor     ecx,ecx
        cmp     dword[IniSettings.Options.ExSwitches],0
        setne   cl
        invoke  SendMessage,eax,BM_SETCHECK,ecx,0

        pop     ebx
        ret
endp

proc CmdResetIniSettings hWnd,bBeep

        stdcall ResetIniSettings
        stdcall UpdateIniControls,dword[hWnd]
        cmp     dword[bBeep],0
        je      .end
        invoke  MessageBeep,MB_ICONINFORMATION
        .end:
        ret
endp

proc CmdLoadIniSettings hWnd,bBeep

        stdcall LoadIniSettings
        stdcall UpdateIniControls,dword[hWnd]
        cmp     dword[bBeep],0
        je      .end
        invoke  MessageBeep,MB_ICONINFORMATION
        .end:
        ret
endp

proc CmdSaveIniSettings hWnd,bBeep

        stdcall UpdateIniSettings,dword[hWnd]
        stdcall SaveIniSettings
        cmp     dword[bBeep],0
        je      .end
        invoke  MessageBeep,MB_ICONINFORMATION
        .end:
        ret
endp
