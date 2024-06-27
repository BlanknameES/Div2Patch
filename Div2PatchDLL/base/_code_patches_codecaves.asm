;--------------------------------------------------
; show Div2Patch version in mainmenu
;--------------------------------------------------

loc_AD8E3D_n: ;main menu - divinity2.exe

        push    CStrPatchVersionText
        push    eax
        call    near PATCH_TEMP_PROC ;sub_65AA00
        .fixup1 = $-4
        add     esp,8

        .back:
        lea     eax,[esp+24h]
        push    eax
        jmp     near PATCH_TEMP_PROC ;loc_AD2E41
        .fixup2 = $-4

loc_ADB735_n: ;main menu (in game) - divinity2.exe

        push    CStrPatchVersionText
        push    eax
        call    near PATCH_TEMP_PROC ;sub_65AA00
        .fixup1 = $-4
        add     esp,8

        .back:
        lea     eax,[esp+24h]
        push    eax
        jmp     near PATCH_TEMP_PROC ;loc_AD5428
        .fixup2 = $-4

loc_AD8E3D_d: ;main menu - divinity2-debug.exe

        push    CStrPatchVersionText
        push    eax
        call    near PATCH_TEMP_PROC ;sub_65AA00
        .fixup1 = $-4
        add     esp,8

        .back:
        lea     eax,[esp+10h]
        push    eax
        jmp     near PATCH_TEMP_PROC ;loc_AD8E42
        .fixup2 = $-4

loc_ADB735_d: ;main menu (in game) - divinity2-debug.exe

        push    CStrPatchVersionText
        push    eax
        call    near PATCH_TEMP_PROC ;sub_65AA00
        .fixup1 = $-4
        add     esp,8

        .back:
        lea     eax,[esp+14h]
        push    eax
        jmp     near PATCH_TEMP_PROC ;loc_ADB73A
        .fixup2 = $-4

;--------------------------------------------------
; toggle ui
;--------------------------------------------------

loc_91CF27:

        mov     esi,dword[esp+13Ch]
        push    edi
        mov     edi,ecx
        cmp     dword[esi+0],86 ;DIK_F12
        je      .toggleui
        jmp     near PATCH_TEMP_PROC ;loc_91CF31
        .fixup1 = $-4

        .toggleui:
        cmp     dword[esi+4],1 ;key_down?
        jne     .not_handled
        push    2Ah ;DIK_LSHIFT
        mov     ecx,esi
        call    near PATCH_TEMP_PROC ;GetDInputKeyState:0x008EBC60
        .fixup2 = $-4
        test    eax,eax
        jz      .not_handled
        mov     eax,dword[PATCH_TEMP_ADDR] ;pScaleform:0x014F93E8
        .fixup3 = $-4
        test    eax,eax
        jz      .handled
        cmp     byte[eax+114h],0
        setz    cl
        mov     byte[eax+114h],cl
        .handled:
        mov     al,1
        jmp     near PATCH_TEMP_PROC ;loc_91EE96
        .fixup4 = $-4
        .not_handled:
        xor     al,al
        jmp     near PATCH_TEMP_PROC ;loc_91EE96
        .fixup5 = $-4

;--------------------------------------------------
; global fps limiter
;--------------------------------------------------

loc_126526C: ;init fps limiter

        stdcall FPSLimiter_Init,FPSLimiter1
        stdcall FPSLimiter_Init,FPSLimiter2
        stdcall FPSLimiter_Init,FPSLimiter3
        .back:
        lea     eax,[esp+18h]
        push    eax
        jmp     near PATCH_TEMP_PROC ;loc_1265271
        .fixup1 = $-4

proc FPSLimiter_Init pFPSLimiter

        locals
                uiFrequency dq ?
                uiCurrentTime dq ?
        endl

        push    ebx
        mov     ebx,dword[pFPSLimiter]

        invoke  timeBeginPeriod,1 ;set 1ms resolution
        cmp     dword[ebx+FPSLIMITER.bUseQPC],0
        je      .init_tgt

        .init_qpc:
        lea     eax,[uiFrequency]
        invoke  QueryPerformanceFrequency,eax
        test    eax,eax
        jz      .fallback
        fild    qword[uiFrequency]
        fstp    qword[ebx+FPSLIMITER.fFrequency]
        stdcall FPSLimiter_SetMaxFPSFlt,ebx,dword[ebx+FPSLIMITER.fMaxFPS] ;lazy way to update fTimeStep
        fld     qword[ebx+FPSLIMITER.fFrequency]
        fmul    dword[ebx+FPSLIMITER.fSleepThresholdMS] ;TODO: Calculate Sleep(1) duration
        fdiv    qword[dbl_1000_0]
        fstp    qword[ebx+FPSLIMITER.fSleepThreshold]
        lea     eax,[uiCurrentTime]
        invoke  QueryPerformanceCounter,eax
        fild    qword[uiCurrentTime]
        fstp    qword[ebx+FPSLIMITER.fCurrentTime]
        jmp     .continue

        .init_tgt:
        mov     dword[uiFrequency],1000
        and     dword[uiFrequency+4],0
        fild    qword[uiFrequency]
        fstp    qword[ebx+FPSLIMITER.fFrequency]
        stdcall FPSLimiter_SetMaxFPSFlt,ebx,dword[ebx+FPSLIMITER.fMaxFPS] ;lazy way to update fTimeStep
        fld     qword[ebx+FPSLIMITER.fFrequency]
        fmul    dword[ebx+FPSLIMITER.fSleepThresholdMS] ;TODO: Calculate Sleep(1) duration
        fdiv    qword[dbl_1000_0]
        fstp    qword[ebx+FPSLIMITER.fSleepThreshold]
        invoke  timeGetTime
        mov     dword[uiCurrentTime],eax
        and     dword[uiCurrentTime+4],0
        fild    qword[uiCurrentTime]
        fstp    qword[ebx+FPSLIMITER.fCurrentTime]

        .continue:
        mov     dword[ebx+FPSLIMITER.bInitialized],1
        .end:
        pop     ebx
        ret

        .fallback: ;high-resolution performance counter not supported
        and     dword[ebx+FPSLIMITER.bUseQPC],0
        jmp     .init_tgt
endp

proc FPSLimiter_SetMaxFPSInt pFPSLimiter,iMaxFPS

        push    ebx
        mov     ebx,dword[pFPSLimiter]
        cmp     dword[iMaxFPS],0
        je      .zero

        .not_zero:
        mov     dword[ebx+FPSLIMITER.bEnabled],1
        fild    dword[iMaxFPS]
        fst     dword[ebx+FPSLIMITER.fMaxFPS]
        fld     qword[ebx+FPSLIMITER.fFrequency]
        fdivrp  st1,st0
        fstp    qword[ebx+FPSLIMITER.fTimeStep]
        jmp     .end

        .zero:
        and     dword[ebx+FPSLIMITER.bEnabled],0
        fldz
        fst     dword[ebx+FPSLIMITER.fMaxFPS]
        fstp    qword[ebx+FPSLIMITER.fTimeStep]

        .end:
        pop     ebx
        ret
endp

proc FPSLimiter_SetMaxFPSFlt pFPSLimiter,fMaxFPS

        push    ebx
        mov     ebx,dword[pFPSLimiter]
        fldz
        fcomp   dword[fMaxFPS]
        fnstsw  ax
        test    ah,44h
        jnp     .zero

        .not_zero:
        mov     dword[ebx+FPSLIMITER.bEnabled],1
        fld     dword[fMaxFPS]
        fst     dword[ebx+FPSLIMITER.fMaxFPS]
        fld     qword[ebx+FPSLIMITER.fFrequency]
        fdivrp  st1,st0
        fstp    qword[ebx+FPSLIMITER.fTimeStep]
        jmp     .end

        .zero:
        and     dword[ebx+FPSLIMITER.bEnabled],0
        fldz
        fst     dword[ebx+FPSLIMITER.fMaxFPS]
        fstp    qword[ebx+FPSLIMITER.fTimeStep]

        .end:
        pop     ebx
        ret
endp

proc timestep_update1

        cmp     dword[FPSLimiter1.bInitialized],0
        je      .end
        stdcall FPSLimiter_Run,FPSLimiter1
        .end:
        ret
endp

proc timestep_update2

        cmp     dword[FPSLimiter2.bInitialized],0
        je      .end
        stdcall FPSLimiter_Run,FPSLimiter2
        .end:
        ret
endp

proc timestep_update3

        cmp     dword[FPSLimiter3.bInitialized],0
        je      .end
        stdcall FPSLimiter_Run,FPSLimiter3
        .end:
        ret
endp

proc FPSLimiter_Run pFPSLimiter

        locals
                uiCurrentTime dq ?
                fDeltaTime dq ?
                fSleepTime dq ?
        endl

        push    ebx

        mov     ebx,dword[pFPSLimiter]
        test    ebx,ebx
        jz      .end

        cmp     dword[ebx+FPSLIMITER.bEnabled],0
        je      .end

        fld     qword[ebx+FPSLIMITER.fCurrentTime]
        fstp    qword[ebx+FPSLIMITER.fLastTime]
        cmp     dword[ebx+FPSLIMITER.bUseQPC],0
        je      .tgt_loop

        .qpc_loop:
        lea     eax,[uiCurrentTime]
        invoke  QueryPerformanceCounter,eax

        fild    qword[uiCurrentTime]
        fst     qword[ebx+FPSLIMITER.fCurrentTime]
        fsub    qword[ebx+FPSLIMITER.fLastTime]
        fstp    qword[fDeltaTime]

        fldz
        fcomp   qword[fDeltaTime]
        fnstsw  ax
        test    ah,41h
        jp      .end

        fld     qword[ebx+FPSLIMITER.fTimeStep]
        fcomp   qword[fDeltaTime]
        fnstsw  ax
        test    ah,41h
        jne     .end

        fld     qword[ebx+FPSLIMITER.fTimeStep]
        fsub    qword[fDeltaTime]
        fstp    qword[fSleepTime]

        fld     qword[ebx+FPSLIMITER.fSleepThreshold]
        fcomp   qword[fSleepTime]
        fnstsw  ax
        test    ah,41h

        setnp   cl
        and     ecx,1
        invoke  Sleep,ecx
        jmp     .qpc_loop

        .tgt_loop:
        invoke  timeGetTime
        mov     dword[uiCurrentTime],eax
        and     dword[uiCurrentTime+4],0

        fild    qword[uiCurrentTime]
        fst     qword[ebx+FPSLIMITER.fCurrentTime]
        fsub    qword[ebx+FPSLIMITER.fLastTime]
        fstp    qword[fDeltaTime]

        fldz
        fcomp   qword[fDeltaTime]
        fnstsw  ax
        test    ah,41h
        jp      .end

        fld     qword[ebx+FPSLIMITER.fTimeStep]
        fcomp   qword[fDeltaTime]
        fnstsw  ax
        test    ah,41h
        jne     .end

        fld     qword[ebx+FPSLIMITER.fTimeStep]
        fsub    qword[fDeltaTime]
        fstp    qword[fSleepTime]

        fld     qword[ebx+FPSLIMITER.fSleepThreshold]
        fcomp   qword[fSleepTime]
        fnstsw  ax
        test    ah,41h

        setnp   cl
        and     ecx,1
        invoke  Sleep,ecx
        jmp     .tgt_loop

        .end:
        pop     ebx
        ret
endp

loc_126553D: ;free fps limiter

        stdcall FPSLimiter_Free,FPSLimiter1
        stdcall FPSLimiter_Free,FPSLimiter2
        stdcall FPSLimiter_Free,FPSLimiter3
        .back:
        mov     ecx,dword[esp+1CCh]
        jmp     near PATCH_TEMP_PROC ;loc_1265544
        .fixup1 = $-4

proc FPSLimiter_Free pFPSLimiter

        invoke  timeEndPeriod,1
        and     dword[ebx+FPSLIMITER.bInitialized],0
        ret
endp

loc_69D6E6: ;secondary fps cap

        ;do nothing
        jmp     near PATCH_TEMP_PROC ;loc_69D713
        .fixup1 = $-4

loc_757FA9: ;slow character rotation fix

        fld     dword[PATCH_TEMP_ADDR] ;0x0132CE80 -> 0.016666668 = 1 / 60
        .fixup1 = $-4
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_757FB2
        .fixup2 = $-4

;--------------------------------------------------
; extended gameplay options (TODO)
;--------------------------------------------------

;--------------------------------------------------
; extended control options
;--------------------------------------------------

loc_8377DC:

        mov     ecx,dword[eax]
        ;cmp     ecx,2 ;mouse middle button
        ;je      near PATCH_TEMP_PROC ;loc_8377FC
        ;.fixup1 = $-4
        jmp     near PATCH_TEMP_PROC ;loc_8377E5
        .fixup2 = $-4

loc_83796D:

        cmp     ecx,1 ;KEY_ESCAPE
        jne     .back
        xor     ecx,ecx ;KEY_NOKEY
        .back:
        push    ecx
        lea     ecx,dword[esp+10h]
        jmp     near PATCH_TEMP_PROC ;loc_837972
        .fixup1 = $-4

loc_79C155:

        lea     ecx,[esp+50h]
        cmp     dword[ecx+4],4 ;keyboard
        jne     .find
        cmp     dword[ecx+8],0 ;KEY_NOKEY
        jne     .find
        or      eax,-1
        jmp     .back

        .find:
        push    ecx
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;sub_82EB80
        .fixup1 = $-4

        .back:
        jmp     near PATCH_TEMP_PROC ;loc_79C161
        .fixup2 = $-4

loc_A92C6B: ;alt camera movement (human form)

        call    near PATCH_TEMP_PROC ;sub_94B8D0:0x0094B8D0
        .fixup1 = $-4
        test    eax,eax
        jz      .end

        .rotate:
        sub     esp,8 ;stack space for args
        fild    dword[esp+20h+8] ;int y
        fmul    dword[PATCH_TEMP_ADDR] ;MouseSensitivityHumanPitch:0x014D7728
        .fixup2 = $-4
        fstp    dword[esp+20h+8] ;float y * MouseSensitivityHumanPitch
        fild    dword[esp+20h+4] ;int x
        fmul    dword[PATCH_TEMP_ADDR] ;MouseSensitivityHumanYaw:0x014D7724
        .fixup3 = $-4
        fstp    dword[esp+20h+4] ;float x * MouseSensitivityHumanYaw
        fld     dword[esp+20h+8]
        fstp    dword[esp+4] ;arg 2
        fld     dword[esp+20h+4]
        fstp    dword[esp] ;arg 1
        mov     ecx,eax
        call    near PATCH_TEMP_PROC ;rotate_camera2:0x0094BCD0
        .fixup4 = $-4

        .end:
        pop     edi
        pop     esi
        add     esp,10h
        retn    8

loc_A92DF7: ;alt camera movement (dragon form)

        call    near PATCH_TEMP_PROC ;sub_94B8D0:0x0094B8D0
        .fixup1 = $-4
        mov     esi,eax
        test    esi,esi
        jz      .rotate
        mov     ecx,esi
        call    near PATCH_TEMP_PROC ;zero_y:0x0094BC20
        .fixup2 = $-4
        mov     ecx,esi
        call    near PATCH_TEMP_PROC ;zero_x:0x0094BC30
        .fixup3 = $-4

        .rotate:
        sub     esp,8 ;stack space for args
        fild    dword[esp+20h+8] ;int y
        fmul    dword[PATCH_TEMP_ADDR] ;MouseSensitivityDragonPitch:0x014D7730
        .fixup4 = $-4
        fstp    dword[esp+20h+8] ;float y * MouseSensitivityDragonPitch
        fild    dword[esp+20h+4] ;int x
        fmul    dword[PATCH_TEMP_ADDR] ;MouseSensitivityDragonYaw:0x014D772C
        .fixup5 = $-4
        fstp    dword[esp+20h+4] ;float x * MouseSensitivityDragonYaw
        fld     dword[esp+20h+8]
        fstp    dword[esp+4] ;arg 2
        fld     dword[esp+20h+4]
        fstp    dword[esp] ;arg 1
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;rotate_camera1:0x00A915E0
        .fixup6 = $-4

        .end:
        pop     edi
        pop     esi
        add     esp,10h
        retn    8

loc_A95926: ;pause mode camera fix 1

        jmp     .skip ;skip x-axis zeroing code

        call    near PATCH_TEMP_PROC ;sub_94B8D0:0x0094B8D0
        .fixup1 = $-4
        .back:
        jmp    near PATCH_TEMP_PROC ;loc_A9592B:0x00A9592B
        .fixup2 = $-4
        .skip:
        jmp    near PATCH_TEMP_PROC ;loc_A95936:0x00A95936
        .fixup3 = $-4

loc_A95027: ;pause mode camera fix 2

        jmp     .skip ;skip x-axis zeroing code

        call    near PATCH_TEMP_PROC ;sub_A92C20:0x00A92C20
        .fixup1 = $-4
        .skip:
        jmp    near PATCH_TEMP_PROC ;loc_A9502E:0x00A9502E
        .fixup2 = $-4

loc_9F7C09: ;pause mode camera fix 3

        jmp     .skip ;skip x-axis zeroing code

        jmp    near PATCH_TEMP_PROC ;sub_A92C20:0x00A92C20
        .fixup1 = $-4
        .skip:
        retn    0

check_xbuttons:

        .uMsg = 4
        .wParam = 8
        .lParam = 12
        .pointer = 16

        cmp     eax,10 ;523 = WM_XBUTTONDOWN
        je      .xbutton_down
        cmp     eax,11 ;524 = WM_XBUTTONUP
        je      .xbutton_up
        .end:
        pop     esi
        add     esp,452
        retn    0

        .xbutton_down:
        mov     eax,dword[esp+452+4+.wParam]
        shr     eax,16
        cmp     eax,1
        je      .xbutton1_down
        cmp     eax,2
        je      .xbutton2_down
        pop     esi
        add     esp,452
        retn    0

        .xbutton_up:
        mov     eax,dword[esp+452+4+.wParam]
        shr     eax,16
        cmp     eax,1
        je      .xbutton1_up
        cmp     eax,2
        je      .xbutton2_up
        pop     esi
        add     esp,452
        retn    0

        .xbutton1_down:
        mov     ecx,dword[esp+452+4+.lParam]
        movsx   eax,cx ;x-position
        shr     ecx,16
        movsx   edx,cx ;y-position
        mov     ecx,dword[esp+452+4+.pointer]
        stdcall SendMouseInput,3,1,eax,edx
        pop     esi
        add     esp,452
        retn    0

        .xbutton2_down:
        mov     ecx,dword[esp+452+4+.lParam]
        movsx   eax,cx ;x-position
        shr     ecx,16
        movsx   edx,cx ;y-position
        mov     ecx,dword[esp+452+4+.pointer]
        stdcall SendMouseInput,4,1,eax,edx
        pop     esi
        add     esp,452
        retn    0

        .xbutton1_up:
        mov     ecx,dword[esp+452+4+.lParam]
        movsx   eax,cx ;x-position
        shr     ecx,16
        movsx   edx,cx ;y-position
        mov     ecx,dword[esp+452+4+.pointer]
        stdcall SendMouseInput,3,0,eax,edx
        pop     esi
        add     esp,452
        retn    0

        .xbutton2_up:
        mov     ecx,dword[esp+452+4+.lParam]
        movsx   eax,cx ;x-position
        shr     ecx,16
        movsx   edx,cx ;y-position
        mov     ecx,dword[esp+452+4+.pointer]
        stdcall SendMouseInput,4,0,eax,edx
        pop     esi
        add     esp,452
        retn    0

proc SendMouseInput KeyCode,KeyState,PositionX,PositionY

        locals
                InputMouse rd 4
                InputDevice rd 5
        endl

        push    ebx esi edi
        mov     ebx,ecx
        lea     eax,[InputMouse]
        mov     ecx,dword[KeyCode]
        mov     edx,dword[KeyState]
        mov     esi,dword[PositionX]
        mov     edi,dword[PositionY]
        mov     dword[eax+0],ecx ;KeyCode
        mov     dword[eax+4],edx ;KeyState
        mov     dword[eax+8],esi ;Position.x
        mov     dword[eax+12],edi ;Position.y
        push    eax
        lea     ecx,[InputDevice]
        call    near PATCH_TEMP_PROC ;SetNiInputDevice_Mouse:0x008EBB70
        .fixup1 = $-4
        lea     eax,[InputDevice]
        push    eax
        push    0 ;unknown
        mov     ecx,ebx
        call    near PATCH_TEMP_PROC ;SendInput:0x008EB010
        .fixup2 = $-4
        pop     edi esi ebx
        ret
endp

loc_9F7D70: ;dynamiczoommode (human-normal)

        fild    dword[iCameraZoomLevel]
        fmul    qword[fZoomStepsDist]
        fchs
        cmp     byte[bDynamicZoom],0
        jne     .dynamic
        .static:
        fadd    qword[fHumanCameraDistance]
        jmp     .extra
        .dynamic:
        fadd    dword[esp+0Ch-4]
        .extra:
        fadd    dword[PATCH_TEMP_ADDR] ;ExtraZoom:0x014FE078
        .fixup1 = $-4
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_9F7D7A
        .fixup2 = $-4

loc_9F7E0A: ;dynamiczoommode (dragon-normal)

        fild    dword[iCameraZoomLevel]
        fmul    qword[fZoomStepsDist]
        fchs
        fadd    qword[fDragonCameraDistance]
        .extra:
        fadd    dword[PATCH_TEMP_ADDR] ;ExtraZoom:0x014FE078
        .fixup1 = $-4
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_9F7E16
        .fixup2 = $-4

loc_A95B05: ;dynamiczoommode (human-paused)

        fild    dword[iCameraZoomLevel]
        fmul    qword[fZoomStepsDist]
        fchs
        cmp     byte[bDynamicZoom],0
        jne     .dynamic
        .static:
        fadd    qword[fHumanCameraDistance]
        jmp     .extra
        .dynamic:
        fadd    dword[esp+14h-8]
        .extra:
        fadd    dword[PATCH_TEMP_ADDR] ;ExtraZoom:0x014FE078
        .fixup1 = $-4
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_A95B0F
        .fixup2 = $-4

loc_A95B9F: ;dynamiczoommode (dragon-paused)

        fild    dword[iCameraZoomLevel]
        fmul    qword[fZoomStepsDist]
        fchs
        fadd    qword[fDragonCameraDistance]
        .extra:
        fadd    dword[PATCH_TEMP_ADDR] ;ExtraZoom:0x014FE078
        .fixup1 = $-4
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_A95BAB
        .fixup2 = $-4

loc_832498: ;remove legacy keybinds

        jmp     near PATCH_TEMP_PROC ;loc_832636
        .fixup1 = $-4

loc_8EFF55: ;show keyboard key modifiers

        stdcall get_keyboard_multikey_string,esi,dword[ecx+8],dword[ecx+12]
        mov     eax,esi ;prob not needed
        pop     esi
        pop     ecx
        retn    4

proc get_keyboard_multikey_string loc_str,key_id,keymod_id

        push    esi edi
        mov     esi,dword[loc_str]
        mov     eax,dword[keymod_id]
        test    eax,eax
        jz      .get_str
        stdcall get_keyboard_keymod_string,eax
        .get_str:
        mov     edi,eax
        mov     ecx,dword[key_id]
        push    ecx
        push    esi
        call    near PATCH_TEMP_PROC ;get_keyboard_key_string:0x008EBDB0
        .fixup1 = $-4
        add     esp,8
        test    edi,edi
        jz      .end
        push    edi
        push    0
        lea     ecx,[esi+1Ch] ;wstr
        call    dword[PATCH_TEMP_PROC] ;std::wstring::insert:0x012BE56C
        .fixup2 = $-4
        .end:
        mov     eax,esi
        pop     edi esi
        ret
endp

proc get_keyboard_keymod_string key_id ;TODO: localized strings

        mov     ecx,dword[key_id]
        .lc:
        cmp     ecx,29 ;L-Ctrl
        jne     .rc
        mov     eax,WStr_KeyMod_LC
        ret
        .rc:
        cmp     ecx,107 ;R-Ctrl
        jne     .ls
        mov     eax,WStr_KeyMod_RC
        ret
        .ls:
        cmp     ecx,42 ;L-Shift
        jne     .rs
        mov     eax,WStr_KeyMod_LS
        ret
        .rs:
        cmp     ecx,54 ;R-Shift
        jne     .la
        mov     eax,WStr_KeyMod_RS
        ret
        .la:
        cmp     ecx,56 ;L-Alt
        jne     .ra
        mov     eax,WStr_KeyMod_LA
        ret
        .ra:
        cmp     ecx,118 ;R-Alt
        jne     .end
        mov     eax,WStr_KeyMod_RA
        ret
        .end:
        xor     eax,eax
        ret
endp

loc_8313A2: ;add new actions

        mov     ecx,esi
        stdcall add_action_entry,97,CStr_AM_ZoomIn
        mov     ecx,esi
        stdcall add_action_entry,98,CStr_AM_ZoomOut
        mov     ecx,esi
        stdcall add_action_entry,99,CStr_AM_ZoomReset
        pop     edi
        pop     esi
        pop     ebp
        pop     ebx
        add     esp,372
        retn    0

proc add_action_entry action_id,action_str

        locals
                tmp_str rb 28 ;basic_string
        endl

        push    ebx esi
        mov     ebx,ecx
        lea     esi,[tmp_str]
        push    dword[action_str]
        mov     ecx,esi
        call    dword[PATCH_TEMP_PROC] ;0x012BE590 -> std::string::string(char const *)
        .fixup1 = $-4
        push    esi
        push    dword[action_id]
        mov     ecx,ebx
        call    near PATCH_TEMP_PROC ;AddActionID:0x0082EF40
        .fixup2 = $-4
        mov     ecx,esi
        call    dword[PATCH_TEMP_PROC] ;0x012BE598 -> std::string::~string(void)
        .fixup3 = $-4
        pop     esi ebx
        ret
endp

loc_832716_n: ;add new keybinds (divinity2.exe)

        .zoom_in:
        mov     ecx,esi
        stdcall insert_keyboard_keybind,97,122,0 ;AM_ZOOM_IN,KEY_PRIOR,KEY_NOKEY
        mov     ecx,esi
        stdcall insert_mouse_keybind,97,8 ;AM_ZOOM_IN,MOUSE_WHEEL_UP

        .zoom_out:
        mov     ecx,esi
        stdcall insert_keyboard_keybind,98,127,0 ;AM_ZOOM_OUT,KEY_NEXT,KEY_NOKEY
        mov     ecx,esi
        stdcall insert_mouse_keybind,98,9 ;AM_ZOOM_OUT,MOUSE_WHEEL_DOWN

        .zoom_reset:
        mov     ecx,esi
        stdcall insert_keyboard_keybind,99,120,0 ;AM_ZOOM_RESET,KEY_HOME,KEY_NOKEY

        .end:
        mov     dword[esi+0Ch],23 ;??
        pop     esi
        retn    0

loc_832716_d: ;add new keybinds (divinity2-debug.exe)

        .zoom_in:
        mov     ecx,esi
        stdcall insert_keyboard_keybind,97,122,0 ;AM_ZOOM_IN,KEY_PRIOR,KEY_NOKEY
        mov     ecx,esi
        stdcall insert_mouse_keybind,97,8 ;AM_ZOOM_IN,MOUSE_WHEEL_UP

        .zoom_out:
        mov     ecx,esi
        stdcall insert_keyboard_keybind,98,127,0 ;AM_ZOOM_OUT,KEY_NEXT,KEY_NOKEY
        mov     ecx,esi
        stdcall insert_mouse_keybind,98,9 ;AM_ZOOM_OUT,MOUSE_WHEEL_DOWN

        .zoom_reset:
        mov     ecx,esi
        stdcall insert_keyboard_keybind,99,120,0 ;AM_ZOOM_RESET,KEY_HOME,KEY_NOKEY

        .end:
        mov     dword[esi+0Ch],23 ;??
        pop     esi
        add     esp,60
        retn    0

proc insert_keyboard_keybind action_id,key_id,keymod_id

        locals
                TmpControllerInput rb 20
        endl

        push    ebx
        mov     ebx,ecx
        push    dword[keymod_id]
        push    dword[key_id]
        lea     ecx,[TmpControllerInput]
        call    near PATCH_TEMP_PROC ;GetKeyboardKeyCode:0x008EFDD0
        .fixup1 = $-4
        push    dword[TmpControllerInput+16]
        push    dword[TmpControllerInput+12]
        push    dword[TmpControllerInput+8]
        push    dword[TmpControllerInput+4]
        push    dword[TmpControllerInput]
        push    dword[action_id]
        mov     ecx,ebx
        call    near PATCH_TEMP_PROC ;MapKeyToAction:0x00831960
        .fixup2 = $-4
        pop     ebx
        ret
endp

proc insert_mouse_keybind action_id,key_id

        locals
                TmpControllerInput rb 20
        endl

        push    ebx
        mov     ebx,ecx
        push    dword[key_id]
        lea     ecx,[TmpControllerInput]
        call    near PATCH_TEMP_PROC ;GetMouseKeyCode:0x008EFB10
        .fixup1 = $-4
        push    dword[TmpControllerInput+16]
        push    dword[TmpControllerInput+12]
        push    dword[TmpControllerInput+8]
        push    dword[TmpControllerInput+4]
        push    dword[TmpControllerInput]
        push    dword[action_id]
        mov     ecx,ebx
        call    near PATCH_TEMP_PROC ;MapKeyToAction:0x00831960
        .fixup2 = $-4
        pop     ebx
        ret
endp

loc_82FA9F: ;add strings for new keybinds

        .arg_0 = 4
        .arg_4 = 8

        mov     eax,dword[esp+2040+.arg_0]
        cmp     eax,57 ;AM_MOUSE_CONTROLS_CHARACTERANDCAMERA
        je      .control_camera
        cmp     eax,85 ;AM_TOGGLE_MENU
        je      .toggle_menu
        cmp     eax,87 ;AM_TOGGLE_CONSOLE
        je      .toggle_console
        cmp     eax,88 ;AM_TOGGLE_DEBUG_INFO
        je      .toggle_debug
        cmp     eax,97 ;AM_ZOOM_IN
        je      .zoom_in
        cmp     eax,98 ;AM_ZOOM_OUT
        je      .zoom_out
        cmp     eax,99 ;AM_ZOOM_RESET
        je      .zoom_reset
        .default:
        xor     al,al
        add     esp,2040
        retn    8

        .control_camera:
        stdcall add_keybind_text_entry,WStr_ControlCamera,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

        .toggle_console:
        stdcall add_keybind_text_entry,WStr_ToggleConsole,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

        .toggle_menu:
        stdcall add_keybind_text_entry,WStr_ToggleMenu,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

        .toggle_debug:
        stdcall add_keybind_text_entry,WStr_ToggleDebug,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

        .zoom_in:
        stdcall add_keybind_text_entry,WStr_ZoomIn,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

        .zoom_out:
        stdcall add_keybind_text_entry,WStr_ZoomOut,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

        .zoom_reset:
        stdcall add_keybind_text_entry,WStr_ZoomReset,dword[esp+2040+.arg_4]
        mov     al,1
        add     esp,2040
        retn    8

proc add_keybind_text_entry str,pointer

        locals
                tmp_int rd 1
                tmp_str rb 56 ;LocalizedString
        endl

        push    ebx
        lea     ebx,[tmp_str]
        push    1
        lea     eax,[tmp_int]
        push    eax
        push    dword[str]
        mov     ecx,ebx
        and     dword[tmp_int],0
        call    near PATCH_TEMP_PROC ;sub_8E88D0
        .fixup1 = $-4
        push    ebx
        mov     ecx,[pointer]
        call    near PATCH_TEMP_PROC ;sub_6EE0B0
        .fixup2 = $-4
        mov     ecx,ebx
        call    near PATCH_TEMP_PROC ;sub_6E8CA0
        .fixup3 = $-4
        pop     ebx
        ret
endp

loc_79D234: ;keybinds blacklist

        .var_AC = -218h

        lea     ecx,[esp+230h+.var_AC]
        call    near PATCH_TEMP_PROC ;sub_79EE20
        .fixup1 = $-4
        stdcall can_action_be_changed,dword[eax+4]
        test    eax,eax
        jz      near PATCH_TEMP_PROC ;loc_79D2CE
        .fixup2 = $-4
        .back:
        push    PATCH_TEMP_ADDR ;0x0132A7C6
        .fixup3 = $-4
        jmp     near PATCH_TEMP_PROC ;loc_79D239
        .fixup4 = $-4

proc can_action_be_changed id

        mov     eax,1
        mov     ecx,dword[id]
        cmp     ecx,57 ;AM_MOUSE_CONTROLS_CHARACTERANDCAMERA
        je      .nope
        cmp     ecx,85 ;AM_TOGGLE_MENU
        je      .nope
        cmp     ecx,87 ;AM_TOGGLE_CONSOLE
        je      .nope
        cmp     ecx,88 ;AM_TOGGLE_DEBUG_INFO
        je      .nope
        cmp     ecx,97 ;AM_ZOOM_IN
        je      .nope
        cmp     ecx,98 ;AM_ZOOM_OUT
        je      .nope
        cmp     ecx,99 ;AM_ZOOM_RESET
        je      .nope
        .end:
        ret

        .nope:
        xor     eax,eax
        ret
endp

loc_A943AA: ;code for new actions

        add     eax,4
        cmp     eax,97 ;AM_ZOOM_IN
        je      .zoom_in
        cmp     eax,98 ;AM_ZOOM_OUT
        je      .zoom_out
        cmp     eax,99 ;AM_ZOOM_RESET
        je      .zoom_reset
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_A943AA
        .fixup1 = $-4

        .zoom_in:
        cmp     dword[ebp],1 ;key down
        jne     .zoom_in_end
        stdcall IncreaseZoomLevel
        .zoom_in_end:
        mov     al,1
        pop     ebp
        pop     edi
        pop     esi
        add     esp,8
        retn    4

        .zoom_out:
        cmp     dword[ebp],1 ;key down
        jne     .zoom_out_end
        stdcall DecreaseZoomLevel
        .zoom_out_end:
        mov     al,1
        pop     ebp
        pop     edi
        pop     esi
        add     esp,8
        retn    4

        .zoom_reset:
        cmp     dword[ebp],1 ;key down
        jne     .zoom_reset_end
        stdcall ResetZoomLevel
        .zoom_reset_end:
        mov     al,1
        pop     ebp
        pop     edi
        pop     esi
        add     esp,8
        retn    4

loc_A95061: ;code for new actions in pause mode

        mov     eax,dword[edi+4]
        cmp     eax,97 ;AM_ZOOM_IN
        je      .zoom_in
        cmp     eax,98 ;AM_ZOOM_OUT
        je      .zoom_out
        cmp     eax,99 ;AM_ZOOM_RESET
        je      .zoom_reset
        add     eax,-10
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_A95067
        .fixup1 = $-4

        .zoom_in:
        cmp     dword[edi],1 ;key down
        jne     .zoom_in_end
        stdcall IncreaseZoomLevel
        stdcall RefreshPausedCamera
        .zoom_in_end:
        mov     al,1
        pop     edi
        pop     esi
        pop     ebx
        retn    4

        .zoom_out:
        cmp     dword[edi],1 ;key down
        jne     .zoom_out_end
        stdcall DecreaseZoomLevel
        stdcall RefreshPausedCamera
        .zoom_out_end:
        mov     al,1
        pop     edi
        pop     esi
        pop     ebx
        retn    4

        .zoom_reset:
        cmp     dword[edi],1 ;key down
        jne     .zoom_reset_end
        stdcall ResetZoomLevel
        stdcall RefreshPausedCamera
        .zoom_reset_end:
        mov     al,1
        pop     edi
        pop     esi
        pop     ebx
        retn    4

proc IncreaseZoomLevel

        mov     eax,dword[iCameraZoomLevel]
        mov     edx,dword[iZoomRangeMax]
        inc     eax
        cmp     eax,edx
        jle     .store
        mov     eax,edx
        .store:
        mov     dword[iCameraZoomLevel],eax
        ret
endp

proc DecreaseZoomLevel

        mov     eax,dword[iCameraZoomLevel]
        mov     edx,dword[iZoomRangeMin]
        dec     eax
        cmp     eax,edx
        jge     .store
        mov     eax,edx
        .store:
        mov     dword[iCameraZoomLevel],eax
        ret
endp

proc ResetZoomLevel

        and     dword[iCameraZoomLevel],0
        ret
endp

proc RefreshPausedCamera ;TODO: find a better solution

        mov     dword[bUpdatePausedCam],1
        .end:
        ret
endp

loc_A95912: ;fix zoom not updating in pause mode

        cmp     dword[bUpdatePausedCam],ebx ;ebx = 0
        je      .back
        mov     dword[bUpdatePausedCam],ebx
        jmp     near PATCH_TEMP_PROC ;loc_A95A84
        .fixup1 = $-4

        .back:
        mov     eax,dword[esi+14h]
        cmp     eax,1
        jmp     near PATCH_TEMP_PROC ;loc_A95918
        .fixup2 = $-4

;--------------------------------------------------
; extended graphic options
;--------------------------------------------------

MenuGetFPSCap:

        mov     eax,dword[PATCH_TEMP_ADDR] ;pGraphicSettings:0x0155040C
        .fixup1 = $-4
        mov     eax,dword[eax+50h]
        retn    0

MenuSetFPSCap:

        mov     ecx,dword[PATCH_TEMP_ADDR] ;pGraphicSettings:0x0155040C
        .fixup1 = $-4
        test    ecx,ecx
        jz      .ret
        mov     eax,dword[esp+4]
        push    eax
        call    SetFPSCap
        .ret:
        retn    0

proc SetFPSCap iValue

        cmp     byte[ecx+31h],0
        jnz     .end
        mov     eax,dword[iValue]
        cmp     dword[ecx+50h],eax
        jz      .end
        mov     dword[ecx+50h],eax
        cmp     dword[ini_opts_globalfps],0
        jne     .new_limiter
        .old_limiter:
        mov     byte[ecx+32h],1 ;restart game popup
        jmp     .end
        .new_limiter:
        push    ebx
        mov     ebx,eax
        stdcall FPSLimiter_SetMaxFPSInt,FPSLimiter1,ebx
        stdcall FPSLimiter_SetMaxFPSInt,FPSLimiter2,ebx
        stdcall FPSLimiter_SetMaxFPSInt,FPSLimiter3,ebx
        pop     ebx
        .end:
        ret
endp

loc_9B262B: ;slider tickmarks

        fld1
        fiadd   dword[FPSCapSliderMaxFPS]
        fisub   dword[FPSCapSliderMinFPS]
        jmp     near PATCH_TEMP_PROC ;loc_9B2631
        .fixup1 = $-4

loc_9B26F3: ;slider handle position

        ;fld     dword[slider9ticmarks_flt]
        ;fstp    dword[esp+58h]
        call    dword[esp+14h] ;MenuGetFPSCap()
        test    eax,eax
        jz      .set_pos
        ;fix slider out of bounds
        mov     ecx,dword[FPSCapSliderMinFPS]
        mov     edx,dword[FPSCapSliderMaxFPS]
        .check_min:
        cmp     eax,ecx
        jge     .check_max
        mov     eax,ecx
        .check_max:
        cmp     eax,edx
        jle     .adjust
        mov     eax,edx
        .adjust:
        sub     eax,ecx
        add     eax,1
        .set_pos:
        jmp     near PATCH_TEMP_PROC ;loc_9B2712
        .fixup1 = $-4

loc_9B2763: ;slider set value

        ;code here comes right after MenuGetFPSCap()
        mov     dword[esp+18h],eax
        lea     ecx,[esp+0B4h]
        jmp     near PATCH_TEMP_PROC ;loc_9B2782
        .fixup1 = $-4

loc_79CC4F: ;ui update set value

        fstp    dword[esp+10h]
        pop     ecx
        mov     eax,dword[esp+20h]
        test    eax,eax
        jz      .set_fps
        add     eax,dword[FPSCapSliderMinFPS]
        sub     eax,1
        .set_fps:
        push    eax
        call    ecx ;MenuSetFPSCap()
        add     esp,4
        mov     eax,dword[esp+20h]
        test    eax,eax
        jz      .set_value
        add     eax,dword[FPSCapSliderMinFPS]
        sub     eax,1
        .set_value:
        mov     dword[esp+14h],eax
        lea     ecx,[esp+1F4h]
        jmp     near PATCH_TEMP_PROC ;loc_79CC7C
        .fixup1 = $-4

loc_9BC855: ;copy data

        test    bl,bl
        jnz     .changed
        mov     edx,dword[esi+1FCh]
        cmp     edx,dword[edi+1FCh]
        jz      .back
        .changed:
        mov     eax,dword[edi+1FCh]
        push    eax
        mov     ecx,dword[esi+200h]
        call    ecx
        mov     edx,dword[esi+204h]
        add     esp,4
        call    edx
        mov     dword[esi+1FCh],eax
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_9BC891
        .fixup1 = $-4

loc_9BC3FA: ;init slider value

        mov     edi,dword[FPSCapDefaultValue] ;default fps cap
        mov     dword[esi+1FCh],edi
        mov     edi,4
        jmp     near PATCH_TEMP_PROC ;loc_9BC40B
        .fixup1 = $-4

loc_6A2DF0: ;init value

        mov     edx,dword[FPSCapDefaultValue]
        mov     dword[esi+50h],edx  ;default fps cap
        jmp     near PATCH_TEMP_PROC ;loc_6A2DF7
        .fixup1 = $-4

loc_6A5440: ;update fMaxFPS right after loading graphicoptions.xml

        push    ebx
        mov     ebx,dword[esi+50h]
        stdcall FPSLimiter_SetMaxFPSInt,FPSLimiter1,ebx
        stdcall FPSLimiter_SetMaxFPSInt,FPSLimiter2,ebx
        stdcall FPSLimiter_SetMaxFPSInt,FPSLimiter3,ebx
        pop     ebx
        .end:
        mov     al, 1
        pop     edi
        pop     esi
        add     esp,4
        retn    4

MenuGetFullscreen:

        mov     eax,dword[PATCH_TEMP_ADDR] ;pGraphicSettings:0x0155040C
        .fixup1 = $-4
        mov     al,byte[eax+35h]
        retn    0

MenuSetFullscreen:

        mov     ecx,dword[PATCH_TEMP_ADDR] ;pGraphicSettings:0x0155040C
        .fixup1 = $-4
        test    ecx,ecx
        jz      .ret
        mov     eax,dword[esp+4]
        push    eax
        call    SetFullscreen
        .ret:
        retn    0

SetFullscreen:

        cmp     byte[ecx+31h],0 ;->bSettingsLock?
        jnz     .ret
        mov     al,byte[esp+4]
        cmp     byte[ecx+35h],al ;->Fullscreen
        jz      .ret
        mov     byte[ecx+35h],al ;->Fullscreen
        mov     byte[ecx+32h],1 ;->bSettingsChanged?
        .ret:
        retn    4

MenuGetBorderless:

        mov     eax,dword[PATCH_TEMP_ADDR] ;pGraphicSettings:0x0155040C
        .fixup1 = $-4
        mov     al,byte[eax+36h]
        retn    0

MenuSetBorderless:

        mov     ecx,dword[PATCH_TEMP_ADDR] ;pGraphicSettings:0x0155040C
        .fixup1 = $-4
        test    ecx,ecx
        jz      .ret
        mov     eax,dword[esp+4]
        push    eax
        call    SetBorderless
        .ret:
        retn    0

SetBorderless:

        cmp     byte[ecx+31h],0 ;->bSettingsLock?
        jnz     .ret
        mov     al,byte[esp+4]
        cmp     byte[ecx+36h],al ;->Borderless
        jz      .ret
        mov     byte[ecx+36h],al ;->Borderless
        mov     byte[ecx+32h],1 ;->bSettingsChanged?
        .ret:
        retn    4

loc_9B6BD2: ;create controls

        call    near PATCH_TEMP_PROC ;MenuAddCtrlType3_DropDown:0x009B2E50
        .fixup1 = $-4

        .fullscreen:
        lea     eax,[esp+14h]
        push    eax
        push    WStrFullscreen
        lea     ecx,[esp+20h]
        mov     dword[esp+1Ch],ebx
        call    near PATCH_TEMP_PROC ;sub_8F9B50:0x008F9B50
        .fixup2 = $-4
        mov     eax,dword[esi+2504]
        mov     ecx,dword[esi+2508]
        mov     edx,dword[esp+18h]
        push    eax
        push    ecx
        push    edx
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;MenuAddUnlocalizedCtrlType4_CheckBox:0x009B3440
        .fixup3 = $-4

        .borderless:
        lea     eax,[esp+14h]
        push    eax
        push    WStrBorderless
        lea     ecx,[esp+20h]
        mov     dword[esp+1Ch],ebx
        call    near PATCH_TEMP_PROC ;sub_8F9B50:0x008F9B50
        .fixup4 = $-4
        mov     eax,dword[esi+2516]
        mov     ecx,dword[esi+2520]
        mov     edx,dword[esp+18h]
        push    eax
        push    ecx
        push    edx
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;MenuAddUnlocalizedCtrlType4_CheckBox:0x009B3440
        .fixup5 = $-4

        .back:
        jmp     near PATCH_TEMP_PROC ;loc_9B6BD7
        .fixup6 = $-4

loc_9BB662: ;link procs to controls

        mov     dword[esi+208h],eax

        .fullscreen:
        mov     dword[esi+2504],MenuSetFullscreen
        mov     dword[esi+2508],MenuGetFullscreen
        call    MenuGetFullscreen
        mov     byte[esi+2500],al

        .borderless:
        mov     dword[esi+2516],MenuSetBorderless
        mov     dword[esi+2520],MenuGetBorderless
        call    MenuGetBorderless
        mov     byte[esi+2512],al

        .back:
        lea     edi,[esi+214h]
        mov     ecx,edi
        jmp     near PATCH_TEMP_PROC ;loc_9BB670
        .fixup1 = $-4

loc_9BC492: ;init controls default value

        mov     dword[esi+1CCh],edx

        .init:
        mov     byte[esi+2500],1 ;fullscreen
        mov     byte[esi+2512],0 ;borderless

        .back:
        jmp     near PATCH_TEMP_PROC ;loc_9BC498
        .fixup1 = $-4

loc_88ED05: ;copy controls data

        mov     dword[esi+9C0h],eax

        .fullscreen:
        mov     eax,dword[edi+2500]
        mov     dword[esi+2500],eax
        mov     ecx,dword[edi+2504]
        mov     dword[esi+2504],ecx
        mov     edx,dword[edi+2508]
        mov     dword[esi+2508],edx

        .borderless:
        mov     eax,dword[edi+2512]
        mov     dword[esi+2512],eax
        mov     ecx,dword[edi+2516]
        mov     dword[esi+2516],ecx
        mov     edx,dword[edi+2520]
        mov     dword[esi+2520],edx

        .back:
        pop     edi
        jmp     near PATCH_TEMP_PROC ;loc_88ED0C
        .fixup1 = $-4

loc_9BA23A: ;set controls data

        call    edx
        fstp    dword[esi+58h]

        .fullscreen:
        mov     eax,dword[esi+2508]
        call    eax
        mov     byte[esi+2500],al

        .borderless:
        mov     eax,dword[esi+2520]
        call    eax
        mov     byte[esi+2512],al

        .back:
        jmp     near PATCH_TEMP_PROC ;loc_9BA23F
        .fixup1 = $-4

loc_9BCCCD: ;update controls data

        .fullscreen:
        test    bl,bl
        jnz     .fullscreen_changed
        mov     al,byte[esi+2500]
        cmp     al,byte[edi+2500]
        jz      .borderless
        .fullscreen_changed:
        movzx   ecx,byte[edi+2500]
        push    ecx
        mov     edx,dword[esi+2504]
        call    edx
        add     esp,4
        mov     eax,dword[esi+2508]
        call    eax
        mov     byte[esi+2500],al

        .borderless:
        test    bl,bl
        jnz     .borderless_changed
        mov     al,byte[esi+2512]
        cmp     al,byte[edi+2512]
        jz      .back
        .borderless_changed:
        movzx   ecx,byte[edi+2512]
        push    ecx
        mov     edx,dword[esi+2516]
        call    edx
        add     esp,4
        mov     eax,dword[esi+2520]
        call    eax
        mov     byte[esi+2512],al

        .back:
        cmp     dword[PATCH_TEMP_ADDR],0 ;bXbox
        .fixup1 = $-4-1
        jmp     near PATCH_TEMP_PROC ;loc_9BCCD4
        .fixup2 = $-4

loc_6A2E7D: ;borderless code part 1

        .borderless:
        mov     byte[esi+36h],0 ;default value

        .back:
        call    near PATCH_TEMP_PROC ;NiNew:0x005FA5F0
        .fixup1 = $-4
        jmp     near PATCH_TEMP_PROC ;loc_6A2E82
        .fixup2 = $-4

loc_B47AB7: ;borderless code part 2

        cmp     byte[ebp+36h],0
        je      .off
        .on:
        push    0x80000000
        jmp     .back
        .off:
        push    0x00CA0000
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_B47ABC
        .fixup1 = $-4

loc_B47AF5: ;borderless code part 3

        cmp     byte[ebp+36h],0
        je      .off
        .on:
        push    0x80000000
        jmp     .back
        .off:
        push    0x00CA0000
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_B47AFA
        .fixup1 = $-4

loc_6A4143: ;write borderless to graphicsettings.xml

        .borderless:
        push    CStrBorderless ;-> "Borderless"
        lea     ecx,[esp+0Ch] ;str1
        call    dword[PATCH_TEMP_PROC] ;0x012BE590 -> std::string::string(char const *)
        .fixup1 = $-4
        lea     edx,[esi+36h] ;GraphicSettings->bBorderless
        push    edx
        lea     eax,[esp+28h] ;str2
        push    eax
        call    near PATCH_TEMP_PROC ;0x006A54B0
        .fixup2 = $-4
        add     esp,8
        push    -1
        lea     ecx,[esp+28h] ;str2
        call    dword[PATCH_TEMP_PROC] ;0x012BE594 -> std::string::c_str(void)
        .fixup3 = $-4
        push    eax
        call    near PATCH_TEMP_PROC ;0x006572A0
        .fixup4 = $-4
        add     esp,8
        push    eax
        lea     ecx,[esp+0Ch] ;str1
        call    dword[PATCH_TEMP_PROC] ;0x012BE594 -> std::string::c_str(void)
        .fixup5 = $-4
        push    eax
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;0x006587A0
        .fixup6 = $-4
        lea     ecx,[esp+24h] ;str2
        call    dword[PATCH_TEMP_PROC] ;0x012BE598 -> std::string::~string(void)
        .fixup7 = $-4
        lea     ecx,[esp+8h] ;str1
        call    dword[PATCH_TEMP_PROC] ;0x012BE598 -> std::string::~string(void)
        .fixup8 = $-4

        .back:
        push    PATCH_TEMP_ADDR ;0x0131BC80 -> "RenderMethod"
        .fixup9 = $-4
        jmp     near PATCH_TEMP_PROC ;loc_6A4148
        .fixup10 = $-4

loc_6A4FAB: ;read borderless from graphicsettings.xml

        mov     byte[ebx],al

        .borderless:
        lea     ebx,[esi+36h] ;GraphicSettings->bBorderless
        push    ebx
        push    CStrBorderless ;-> "Borderless"
        push    edi
        call    near PATCH_TEMP_PROC ;XMLValueToBool:0x006A5F80
        .fixup1 = $-4
        add     esp,12
        mov     byte[ebx],al

        .back:
        push    PATCH_TEMP_ADDR ;0x0131BE9C -> "RenderMethod"
        .fixup2 = $-4
        lea     ecx,[esp+14h]
        jmp     near PATCH_TEMP_PROC ;loc_6A4FB6
        .fixup3 = $-4

loc_9B6BD7:

        .vsync:
        lea     ecx,[esp+10h]
        push    ecx
        push    PATCH_TEMP_ADDR ;0x0133FB88 -> "User VSync Tooltip."
        .fixup1 = $-4
        lea     ecx,[esp+20h]
        mov     dword[esp+1Ch],ebx
        mov     dword[esp+18h],ebx
        call    near PATCH_TEMP_PROC ;sub_8F9B50:0x008F9B50
        .fixup2 = $-4
        lea     edx,[esp+14h]
        push    edx
        push    PATCH_TEMP_ADDR ;0x0133FBB0 -> "Use VSync"
        .fixup3 = $-4
        lea     ecx,[esp+24h]
        call    near PATCH_TEMP_PROC ;sub_8F9B50:0x008F9B50
        .fixup4 = $-4
        mov     ecx,dword[esp+18h]
        mov     edx,dword[esi+11Ch]
        push    ecx
        mov     ecx,dword[esi+120h]
        push    edx
        mov     edx,dword[eax]
        push    ecx
        push    edx
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;MenuAddCtrlType4_CheckBox:0x009B2BE0
        .fixup5 = $-4

        .fpscap:
        lea     ecx,[esp+10h]
        push    ecx
        push    PATCH_TEMP_ADDR ;0x01340320 -> "FPSCap Tooltip"
        .fixup6 = $-4
        lea     ecx,[esp+20h]
        mov     dword[esp+18h],ebx
        call    near PATCH_TEMP_PROC ;sub_8F9B50:0x008F9B50
        .fixup7 = $-4
        lea     edx,[esp+14h]
        push    edx
        push    PATCH_TEMP_ADDR ;0x01340340 -> "FPS Cap"
        .fixup8 = $-4
        lea     ecx,[esp+24h]
        mov     dword[esp+1Ch],ebx
        call    near PATCH_TEMP_PROC ;sub_8F9B50:0x008F9B50
        .fixup9 = $-4
        mov     eax,dword[esp+18h]
        mov     ecx,dword[esi+200h]
        mov     edx,dword[esi+204h]
        push    eax
        mov     eax,dword[esp+20h]
        push    ecx
        push    edx
        push    eax
        mov     ecx,edi
        call    near PATCH_TEMP_PROC ;MenuAddCtrlType9_Slider:0x009B2610
        .fixup10 = $-4

        .back:
        lea     eax,[esp+10h]
        push    eax
        jmp     near PATCH_TEMP_PROC ;loc_9B6BDC
        .fixup11 = $-4

;--------------------------------------------------
; extended global switches
;--------------------------------------------------

loc_6D6BE4: ;read settings

        mov     byte[PATCH_TEMP_ADDR],al ;bGraphicsOptions:0x014D6ED2
        .fixup1 = $-4

        .playintro:
        push    bPlayIntroVideo
        push    CStrPlayIntroVideo
        push    esi
        call    near PATCH_TEMP_PROC ;XMLValueToBool:0x006A5F80
        .fixup2 = $-4
        add     esp,12
        mov     byte[bPlayIntroVideo],al

        .camerafov: ;TODO: change to float?
        push    uiCustomCameraFOV
        push    CStrCustomCameraFOV
        push    esi
        call    near PATCH_TEMP_PROC ;XMLValueToInt:0x006A5FD0
        .fixup3 = $-4
        add     esp,12
        stdcall ValidateFOVRange,eax
        mov     dword[uiCustomCameraFOV],eax

        .dynamiczoom:
        push    bDynamicZoom
        push    CStrDynamicCameraZoom
        push    esi
        call    near PATCH_TEMP_PROC ;XMLValueToBool:0x006A5F80
        .fixup4 = $-4
        add     esp,12
        mov     byte[bDynamicZoom],al

        .check_config:
        stdcall CheckConfigChanged

        .back:
        jmp     near PATCH_TEMP_PROC ;loc_6D6BF0
        .fixup5 = $-4

proc ValidateFOVRange value

        mov     eax,dword[value]
        test    eax,eax
        jz      .end
        mov     ecx,dword[uiFOVRangeMin]
        mov     edx,dword[uiFOVRangeMax]
        .check_min:
        cmp     eax,ecx
        jae     .check_max
        .set_min:
        mov     eax,ecx
        .check_max:
        cmp     eax,edx
        jbe     .no_neg
        .set_max:
        mov     eax,edx
        .no_neg: ;clamp to positive range for fild instruction
        cmp     eax,0x80000000
        sbb     ecx,ecx
        and     eax,ecx
        .end:
        ret
endp

proc CheckConfigChanged

        xor     eax,eax

        .playvideo:
        cmp     byte[PATCH_TEMP_ADDR],0 ;PlayVideo:0x014D6EE6
        .fixup1 = $-4-1
        je      .config_changed

        .render_framerate:
        cmp     byte[PATCH_TEMP_ADDR],0 ;render_framerate:0x014F9916
        .fixup2 = $-4-1
        jne     .config_changed

        .storylog:
        cmp     byte[PATCH_TEMP_ADDR],0 ;StoryLog:0x014F9940
        .fixup3 = $-4-1
        jne     .config_changed

        .loadvegetation:
        cmp     byte[PATCH_TEMP_ADDR],0 ;LoadVegetation:0x014D6EDE
        .fixup4 = $-4-1
        je      .config_changed

        .showposition:
        cmp     byte[PATCH_TEMP_ADDR],0 ;ShowPosition:0x014F993C
        .fixup5 = $-4-1
        jne     .config_changed

        .graphicsoptions:
        cmp     byte[PATCH_TEMP_ADDR],0 ;GraphicsOptions:0x014D6ED2
        .fixup6 = $-4-1
        je      .config_changed

        .playintro:
        cmp     byte[bPlayIntroVideo],0
        je      .config_changed

        .camerafov:
        cmp     dword[uiCustomCameraFOV],0
        jne     .config_changed

        .dynamiczoom:
        cmp     byte[bDynamicZoom],0
        je      .config_changed

        .config_not_changed:
        xor     al,al
        jmp     .end

        .config_changed:
        mov     al,1

        .end:
        mov     byte[PATCH_TEMP_ADDR],al ;bGraphicsOptionsChanged:0x014F9964
        .fixup7 = $-4
        ret
endp

loc_B3F900: ;playintrovideo

        cmp     byte[bPlayIntroVideo],0
        je      .back
        mov     ecx,dword[esi+7Ch]
        call    near PATCH_TEMP_PROC ;PlayIntroVideo:0x00B47F10
        .fixup1 = $-4
        .back:
        jmp     near PATCH_TEMP_PROC ;loc_B3F908
        .fixup2 = $-4

proc set_cameraFOV ;customcamerafov

        cmp     dword[uiCustomCameraFOV],0
        je      .def
        .custom:
        fild    dword[uiCustomCameraFOV]
        jmp     .set
        .def:
        mov     eax,dword[PATCH_TEMP_ADDR] ;pGameGlobals:0x01550408
        .fixup1 = $-4
        fld     dword[eax+44h]
        .set:
        fstp    dword[ecx+60h]
        mov     byte[ecx+64h],1
        ret
endp
