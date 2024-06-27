proc ApplyPatchesDebug

        push    ebx
        mov     ebx,1

        .showversion:
        ;main menu
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00AD8E3D
        stdcall MPatchCodeCave,eax,loc_AD8E3D_d,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0065AA00
        stdcall MPatchAddress,loc_AD8E3D_d.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00AD8E42
        stdcall MPatchAddress,loc_AD8E3D_d.fixup2,eax,1
        and     ebx,eax

        ;main menu (in game)
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00ADB735
        stdcall MPatchCodeCave,eax,loc_ADB735_d,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0065AA00
        stdcall MPatchAddress,loc_ADB735_d.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00ADB73A
        stdcall MPatchAddress,loc_ADB735_d.fixup2,eax,1
        and     ebx,eax

        if 0
        .toggleui:
        ;toggle ui (lshift+f12) - for aethe
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0091CF27
        stdcall MPatchCodeCave,eax,loc_91CF27,10
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0091CF31
        stdcall MPatchAddress,loc_91CF27.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EBC60
        stdcall MPatchAddress,loc_91CF27.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0014F93E8
        stdcall MPatchAddress,loc_91CF27.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0091EE96
        stdcall MPatchAddress,loc_91CF27.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0091EE96
        stdcall MPatchAddress,loc_91CF27.fixup5,eax,1
        and     ebx,eax
        end if

        .globalfps:
        cmp     dword[ini_opts_globalfps],0
        je      .exoptions

        ;new fps limiter
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0126526C
        stdcall MPatchCodeCave,eax,loc_126526C,4+1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01265271
        stdcall MPatchAddress,loc_126526C.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0136AC68
        stdcall MPatchAddress,eax,timestep_update1,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0131BB24
        stdcall MPatchAddress,eax,timestep_update2,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0131E1CC
        stdcall MPatchAddress,eax,timestep_update3,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0126553D
        stdcall MPatchCodeCave,eax,loc_126553D,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01265544
        stdcall MPatchAddress,loc_126553D.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0069D6E6
        stdcall MPatchCodeCave,eax,loc_69D6E6,45
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0069D713
        stdcall MPatchAddress,loc_69D6E6.fixup1,eax,1
        and     ebx,eax

        ;slow character rotation fix
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00757FA9
        stdcall MPatchCodeCave,eax,loc_757FA9,6+3
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0132CE80
        stdcall MPatchAddress,loc_757FA9.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00757FB2
        stdcall MPatchAddress,loc_757FA9.fixup2,eax,1
        and     ebx,eax

        .exoptions:
        ;cmp     dword[ini_opts_exoptions],0
        ;jz      .excontrols

        .excontrols:
        cmp     dword[ini_opts_excontrols],0
        jz      .exgraphics

        ;enable mouse middle button binding
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008377DC
        stdcall MPatchCodeCave,eax,loc_8377DC,2+2+3+2
        and     ebx,eax
        ;stdcall GetRealAddress,PMI_Divinity2Exe,0x008377FC
        ;stdcall MPatchAddress,loc_8377DC.fixup1,eax,1
        ;and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008377E5
        stdcall MPatchAddress,loc_8377DC.fixup2,eax,1
        and     ebx,eax

        ;unassign keybinds by pressing esc
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008378B8
        stdcall MPatchByte,eax,0x01 ;exclude KEY_ESCAPE from key input validation
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0083796D
        stdcall MPatchCodeCave,eax,loc_83796D,5 ;assign KEY_NOKEY to KEY_ESCAPE
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00837972
        stdcall MPatchAddress,loc_83796D.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079C155
        stdcall MPatchCodeCave,eax,loc_79C155,5 ;exclude KEY_NOKEY from key-already-assigned check
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082EB80
        stdcall MPatchAddress,loc_79C155.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079C161
        stdcall MPatchAddress,loc_79C155.fixup2,eax,1
        and     ebx,eax

        ;remove x-axis 2x sensitivity calculation
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A88746
        stdcall MPatchWord,eax,0x9090
        and     ebx,eax

        ;alternative humanform camera movement
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A92C6B
        stdcall MPatchCodeCave,eax,loc_A92C6B,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094B8D0
        stdcall MPatchAddress,loc_A92C6B.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D7728
        stdcall MPatchAddress,loc_A92C6B.fixup2,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D7724
        stdcall MPatchAddress,loc_A92C6B.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094BCD0
        stdcall MPatchAddress,loc_A92C6B.fixup4,eax,1
        and     ebx,eax

        ;alternative dragonform camera movement (no real changes were made here)
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A92DF7
        stdcall MPatchCodeCave,eax,loc_A92DF7,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094B8D0
        stdcall MPatchAddress,loc_A92DF7.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094BC20
        stdcall MPatchAddress,loc_A92DF7.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094BC30
        stdcall MPatchAddress,loc_A92DF7.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D7730
        stdcall MPatchAddress,loc_A92DF7.fixup4,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D772C
        stdcall MPatchAddress,loc_A92DF7.fixup5,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A915E0
        stdcall MPatchAddress,loc_A92DF7.fixup6,eax,1
        and     ebx,eax

        ;pause mode camera fix
        ;stdcall GetRealAddress,PMI_Divinity2Exe,0x00A92E50
        ;mov     esi,eax
        ;stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95873
        ;stdcall MPatchAddress,eax,esi,1
        ;and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95926
        stdcall MPatchCodeCave,eax,loc_A95926,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094B8D0
        stdcall MPatchAddress,loc_A95926.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A9592B
        stdcall MPatchAddress,loc_A95926.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95936
        stdcall MPatchAddress,loc_A95926.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95027
        stdcall MPatchCodeCave,eax,loc_A95027,2+5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A92C20
        stdcall MPatchAddress,loc_A95027.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A9502E
        stdcall MPatchAddress,loc_A95027.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F7C09
        stdcall MPatchCodeCave,eax,loc_9F7C09,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A92C20
        stdcall MPatchAddress,loc_9F7C09.fixup1,eax,1
        and     ebx,eax

        ;mouse extra buttons improved support
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EF5A8
        stdcall MPatchAddress,eax,check_xbuttons,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EBB70
        stdcall MPatchAddress,SendMouseInput.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EB010
        stdcall MPatchAddress,SendMouseInput.fixup2,eax,1
        and     ebx,eax

        ;dynamiczoommode
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F7D70 ;human
        stdcall MPatchCodeCave,eax,loc_9F7D70,6+4
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014FE078
        stdcall MPatchAddress,loc_9F7D70.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F7D7A
        stdcall MPatchAddress,loc_9F7D70.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F7E0A ;dragon
        stdcall MPatchCodeCave,eax,loc_9F7E0A,6+6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014FE078
        stdcall MPatchAddress,loc_9F7E0A.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F7E16
        stdcall MPatchAddress,loc_9F7E0A.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95B05 ;human (paused)
        stdcall MPatchCodeCave,eax,loc_A95B05,6+4
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014FE078
        stdcall MPatchAddress,loc_A95B05.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95B0F
        stdcall MPatchAddress,loc_A95B05.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95B9F ;dragon (paused)
        stdcall MPatchCodeCave,eax,loc_A95B9F,6+6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014FE078
        stdcall MPatchAddress,loc_A95B9F.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95BAB
        stdcall MPatchAddress,loc_A95B9F.fixup2,eax,1
        and     ebx,eax

        ;fix mouse wheel down
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EF074
        stdcall MPatchDword,eax,0x88888889
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EF07A
        stdcall MPatchByte,eax,0x03
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EF089
        stdcall MPatchByte,eax,0x8D
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EF11C
        stdcall MPatchByte,eax,0x01
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EF317
        stdcall MPatchByte,eax,0xEB
        and     ebx,eax

        ;allow binding different hotkeys to the same key
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00831B47
        stdcall MPatchByte,eax,0x90
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00831B48
        stdcall MPatchByte,eax,0xE9
        and     ebx,eax

        ;remove legacy keybinds
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00832498
        stdcall MPatchCodeCave,eax,loc_832498,3+2 ;TODO: remove code for actions from sub_A93D70?
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00832636
        stdcall MPatchAddress,loc_832498.fixup1,eax,1
        and     ebx,eax

        ;show keyboard key modifiers
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EFF55 ;TODO: sub_AE6920/sub_AE05B0
        stdcall MPatchCodeCave,eax,loc_8EFF55,20
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EBDB0
        stdcall MPatchAddress,get_keyboard_multikey_string.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE56C
        stdcall MPatchAddress,get_keyboard_multikey_string.fixup2,eax,0
        and     ebx,eax

        ;add new actions
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B8108
        stdcall MPatchByte,eax,97+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00830482
        stdcall MPatchByte,eax,97+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082EAA6
        stdcall MPatchByte,eax,96+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082E93C
        stdcall MPatchByte,eax,96+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008313A2
        stdcall MPatchCodeCave,eax,loc_8313A2,4+6+1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE590
        stdcall MPatchAddress,add_action_entry.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082EF40
        stdcall MPatchAddress,add_action_entry.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE598
        stdcall MPatchAddress,add_action_entry.fixup3,eax,0
        and     ebx,eax

        ;add new keybinds
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00832716
        stdcall MPatchCodeCave,eax,loc_832716_d,7+1+3+1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EFDD0
        stdcall MPatchAddress,insert_keyboard_keybind.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00831960
        stdcall MPatchAddress,insert_keyboard_keybind.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EFB10
        stdcall MPatchAddress,insert_mouse_keybind.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00831960
        stdcall MPatchAddress,insert_mouse_keybind.fixup2,eax,1
        and     ebx,eax

        ;add strings for new/hidden keybinds
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082FA9F
        stdcall MPatchCodeCave,eax,loc_82FA9F,2+6+4
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008E88D0
        stdcall MPatchAddress,add_keybind_text_entry.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006EE0B0
        stdcall MPatchAddress,add_keybind_text_entry.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006E8CA0
        stdcall MPatchAddress,add_keybind_text_entry.fixup3,eax,1
        and     ebx,eax

        ;keybinds blacklist
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079D234
        stdcall MPatchCodeCave,eax,loc_79D234,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079EE20
        stdcall MPatchAddress,loc_79D234.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079D2CE ;TODO: pop up message: This key cannot be changed.
        stdcall MPatchAddress,loc_79D234.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0132A7C6
        stdcall MPatchAddress,loc_79D234.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079D239
        stdcall MPatchAddress,loc_79D234.fixup4,eax,1
        and     ebx,eax

        ;code for new actions
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A93DD3
        stdcall MPatchAddress,eax,loc_A943AA,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A943AA
        stdcall MPatchAddress,loc_A943AA.fixup1,eax,1
        and     ebx,eax

        ;code for new actions in pause mode
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95061
        stdcall MPatchCodeCave,eax,loc_A95061,3+3
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95067
        stdcall MPatchAddress,loc_A95061.fixup1,eax,1
        and     ebx,eax

        ;fix zoom not updating in pause mode
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95912
        stdcall MPatchCodeCave,eax,loc_A95912,3+3
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95A84
        stdcall MPatchAddress,loc_A95912.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A95918
        stdcall MPatchAddress,loc_A95912.fixup2,eax,1
        and     ebx,eax

        .exgraphics:
        cmp     dword[ini_opts_exgraphics],0
        je      .exswitches

        ;extended fpscap slider + float value converted to int
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0155040C
        stdcall MPatchAddress,MenuSetFPSCap.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0155040C
        stdcall MPatchAddress,MenuGetFPSCap.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BB630
        stdcall MPatchAddress,eax,MenuSetFPSCap,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BB63A
        stdcall MPatchAddress,eax,MenuGetFPSCap,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BB63F
        stdcall MPatchAddress,eax,MenuGetFPSCap,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BB643
        stdcall MPatchWord,eax,0x8689 ;change fstp esi+x to mov esi+x,eax
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BA117
        stdcall MPatchWord,eax,0x8689 ;change fstp esi+x to mov esi+x,eax
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B262B
        stdcall MPatchCodeCave,eax,loc_9B262B,6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2631
        stdcall MPatchAddress,loc_9B262B.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B26F3
        stdcall MPatchCodeCave,eax,loc_9B26F3,31
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2712
        stdcall MPatchAddress,loc_9B26F3.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2763
        stdcall MPatchCodeCave,eax,loc_9B2763,31
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2782
        stdcall MPatchAddress,loc_9B2763.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079CC4F
        stdcall MPatchCodeCave,eax,loc_79CC4F,45
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079CC7C
        stdcall MPatchAddress,loc_79CC4F.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BC855
        stdcall MPatchCodeCave,eax,loc_9BC855,60
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BC891
        stdcall MPatchAddress,loc_9BC855.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BC3FA
        stdcall MPatchCodeCave,eax,loc_9BC3FA,17
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BC40B
        stdcall MPatchAddress,loc_9BC3FA.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A2DF0
        stdcall MPatchCodeCave,eax,loc_6A2DF0,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A2DF7
        stdcall MPatchAddress,loc_6A2DF0.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A5440
        stdcall MPatchCodeCave,eax,loc_6A5440,8
        and     ebx,eax

        ;fullscreen+borderless checkboxes
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088DAC3
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088DAE6
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088DC34
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088DC58
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0155040C
        stdcall MPatchAddress,MenuGetFullscreen.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0155040C
        stdcall MPatchAddress,MenuSetFullscreen.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0155040C
        stdcall MPatchAddress,MenuGetBorderless.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0155040C
        stdcall MPatchAddress,MenuSetBorderless.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6BD2
        stdcall MPatchCodeCave,eax,loc_9B6BD2,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2E50
        stdcall MPatchAddress,loc_9B6BD2.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F9B50
        stdcall MPatchAddress,loc_9B6BD2.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B3440
        stdcall MPatchAddress,loc_9B6BD2.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F9B50
        stdcall MPatchAddress,loc_9B6BD2.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B3440
        stdcall MPatchAddress,loc_9B6BD2.fixup5,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6BD7
        stdcall MPatchAddress,loc_9B6BD2.fixup6,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BB662
        stdcall MPatchCodeCave,eax,loc_9BB662,14
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BB670
        stdcall MPatchAddress,loc_9BB662.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BC492
        stdcall MPatchCodeCave,eax,loc_9BC492,6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BC492
        stdcall MPatchAddress,loc_9BC492.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088ED05
        stdcall MPatchCodeCave,eax,loc_88ED05,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088ED0C
        stdcall MPatchAddress,loc_88ED05.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BA23A
        stdcall MPatchCodeCave,eax,loc_9BA23A,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BA23F
        stdcall MPatchAddress,loc_9BA23A.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BCCCD
        stdcall MPatchCodeCave,eax,loc_9BCCCD,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F990C
        stdcall MPatchAddress,loc_9BCCCD.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009BCCD4
        stdcall MPatchAddress,loc_9BCCCD.fixup2,eax,1
        and     ebx,eax

        ;borderless code
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A2E7D
        stdcall MPatchCodeCave,eax,loc_6A2E7D,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x005FA5F0
        stdcall MPatchAddress,loc_6A2E7D.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A2E82
        stdcall MPatchAddress,loc_6A2E7D.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B47AB7
        stdcall MPatchCodeCave,eax,loc_B47AB7,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B47ABC
        stdcall MPatchAddress,loc_B47AB7.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B47AF5
        stdcall MPatchCodeCave,eax,loc_B47AF5,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B47AFA
        stdcall MPatchAddress,loc_B47AF5.fixup1,eax,1
        and     ebx,eax

        ;write borderless to settings
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A4143
        stdcall MPatchCodeCave,eax,loc_6A4143,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE590
        stdcall MPatchAddress,loc_6A4143.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A54B0
        stdcall MPatchAddress,loc_6A4143.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE594
        stdcall MPatchAddress,loc_6A4143.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006572A0
        stdcall MPatchAddress,loc_6A4143.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE594
        stdcall MPatchAddress,loc_6A4143.fixup5,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006587A0
        stdcall MPatchAddress,loc_6A4143.fixup6,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE598
        stdcall MPatchAddress,loc_6A4143.fixup7,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012BE598
        stdcall MPatchAddress,loc_6A4143.fixup8,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0131BC80
        stdcall MPatchAddress,loc_6A4143.fixup9,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A4148
        stdcall MPatchAddress,loc_6A4143.fixup10,eax,1
        and     ebx,eax

        ;read borderless from settings
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A4FAB
        stdcall MPatchCodeCave,eax,loc_6A4FAB,11
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A5F80
        stdcall MPatchAddress,loc_6A4FAB.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0131BE9C
        stdcall MPatchAddress,loc_6A4FAB.fixup2,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A4FB6
        stdcall MPatchAddress,loc_6A4FAB.fixup3,eax,1
        and     ebx,eax

        ;move vsync/fpscap outside of advanced options
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6BD7
        stdcall MPatchCodeCave,eax,loc_9B6BD7,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0133FB88
        stdcall MPatchAddress,loc_9B6BD7.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F9B50
        stdcall MPatchAddress,loc_9B6BD7.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0133FBB0
        stdcall MPatchAddress,loc_9B6BD7.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F9B50
        stdcall MPatchAddress,loc_9B6BD7.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2BE0
        stdcall MPatchAddress,loc_9B6BD7.fixup5,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01340320
        stdcall MPatchAddress,loc_9B6BD7.fixup6,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F9B50
        stdcall MPatchAddress,loc_9B6BD7.fixup7,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01340340
        stdcall MPatchAddress,loc_9B6BD7.fixup8,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F9B50
        stdcall MPatchAddress,loc_9B6BD7.fixup9,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2610
        stdcall MPatchAddress,loc_9B6BD7.fixup10,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6BDC
        stdcall MPatchAddress,loc_9B6BD7.fixup11,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6C2E
        stdcall MPatchDword,eax,0xCCCC49EB
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B74C8
        stdcall MPatchDword,eax,0xCCCC4BEB
        and     ebx,eax

        .exswitches:
        cmp     dword[ini_opts_exswitches],0
        jz      .end

        ;read settings
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006D6BE4
        stdcall MPatchCodeCave,eax,loc_6D6BE4,68
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D6ED2
        stdcall MPatchAddress,loc_6D6BE4.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A5F80
        stdcall MPatchAddress,loc_6D6BE4.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A5FD0
        stdcall MPatchAddress,loc_6D6BE4.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A5F80
        stdcall MPatchAddress,loc_6D6BE4.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006D6C28
        stdcall MPatchAddress,loc_6D6BE4.fixup5,eax,1
        and     ebx,eax

        ;check default config changed
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D6EE6
        stdcall MPatchAddress,CheckConfigChanged.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F9916
        stdcall MPatchAddress,CheckConfigChanged.fixup2,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F9940
        stdcall MPatchAddress,CheckConfigChanged.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D6EDE
        stdcall MPatchAddress,CheckConfigChanged.fixup4,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F993C
        stdcall MPatchAddress,CheckConfigChanged.fixup5,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014D6ED2
        stdcall MPatchAddress,CheckConfigChanged.fixup6,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F9964
        stdcall MPatchAddress,CheckConfigChanged.fixup7,eax,0
        and     ebx,eax

        ;playintrovideo
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B3F900
        stdcall MPatchCodeCave,eax,loc_B3F900,8
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B47F10
        stdcall MPatchAddress,loc_B3F900.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B3F908
        stdcall MPatchAddress,loc_B3F900.fixup2,eax,1
        and     ebx,eax

        ;customcamerafov
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00873BA8
        stdcall MPatchAddress,eax,set_cameraFOV,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094BDA8 ;unused?
        stdcall MPatchAddress,eax,set_cameraFOV,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01550408
        stdcall MPatchAddress,set_cameraFOV.fixup1,eax,0
        and     ebx,eax

        .end:
        mov     eax,ebx
        pop     ebx
        ret
endp
