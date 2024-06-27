proc ApplyPatchesNormal

        push    ebx
        mov     ebx,1

        .showversion:
        ;main menu
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00AD2E3C
        stdcall MPatchCodeCave,eax,loc_AD8E3D_n,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0065AA00
        stdcall MPatchAddress,loc_AD8E3D_n.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00AD2E41
        stdcall MPatchAddress,loc_AD8E3D_n.fixup2,eax,1
        and     ebx,eax

        ;main menu (in game)
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00AD5423
        stdcall MPatchCodeCave,eax,loc_ADB735_n,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0065AA00
        stdcall MPatchAddress,loc_ADB735_n.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00AD5428
        stdcall MPatchAddress,loc_ADB735_n.fixup2,eax,1
        and     ebx,eax

        .globalfps:
        cmp     dword[ini_opts_globalfps],0
        je      .exoptions

        ;new fps limiter
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0125EB5C
        stdcall MPatchCodeCave,eax,loc_126526C,4+1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0125EB61
        stdcall MPatchAddress,loc_126526C.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01362D90
        stdcall MPatchAddress,eax,timestep_update1,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01314B24
        stdcall MPatchAddress,eax,timestep_update2,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01316604
        stdcall MPatchAddress,eax,timestep_update3,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0125EE2D
        stdcall MPatchCodeCave,eax,loc_126553D,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0125EE34
        stdcall MPatchAddress,loc_126553D.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0069D6E6
        stdcall MPatchCodeCave,eax,loc_69D6E6,45
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0069D713
        stdcall MPatchAddress,loc_69D6E6.fixup1,eax,1
        and     ebx,eax

        ;slow character rotation fix
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00754479
        stdcall MPatchCodeCave,eax,loc_757FA9,6+3
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x013252B8
        stdcall MPatchAddress,loc_757FA9.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00754482
        stdcall MPatchAddress,loc_757FA9.fixup2,eax,1
        and     ebx,eax

        .exoptions:
        ;cmp     dword[ini_opts_exoptions],0
        ;jz      .excontrols

        .excontrols:
        cmp     dword[ini_opts_excontrols],0
        je      .exgraphics

        ;enable mouse middle button binding
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00833DBC
        stdcall MPatchCodeCave,eax,loc_8377DC,2+2+3+2
        and     ebx,eax
        ;stdcall GetRealAddress,PMI_Divinity2Exe,0x00833DDC
        ;stdcall MPatchAddress,loc_8377DC.fixup1,eax,1
        ;and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00833DC5
        stdcall MPatchAddress,loc_8377DC.fixup2,eax,1
        and     ebx,eax

        ;unassign keybinds by pressing esc
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00833E98
        stdcall MPatchByte,eax,0x01 ;exclude KEY_ESCAPE from key input validation
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00833F4D
        stdcall MPatchCodeCave,eax,loc_83796D,5 ;assign KEY_NOKEY to KEY_ESCAPE
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00833F52
        stdcall MPatchAddress,loc_83796D.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x007985F5
        stdcall MPatchCodeCave,eax,loc_79C155,5 ;exclude KEY_NOKEY from key-already-assigned check
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082B360
        stdcall MPatchAddress,loc_79C155.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00798601
        stdcall MPatchAddress,loc_79C155.fixup2,eax,1
        and     ebx,eax

        ;remove x-axis 2x sensitivity calculation
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A824C6
        stdcall MPatchWord,eax,0x9090
        and     ebx,eax

        ;alternative humanform camera movement
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8C9DB
        stdcall MPatchCodeCave,eax,loc_A92C6B,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00945ED0
        stdcall MPatchAddress,loc_A92C6B.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CF728
        stdcall MPatchAddress,loc_A92C6B.fixup2,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CF724
        stdcall MPatchAddress,loc_A92C6B.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009462D0
        stdcall MPatchAddress,loc_A92C6B.fixup4,eax,1
        and     ebx,eax

        ;alternative dragonform camera movement (no real changes were made here)
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8CB67
        stdcall MPatchCodeCave,eax,loc_A92DF7,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00945ED0
        stdcall MPatchAddress,loc_A92DF7.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00946220
        stdcall MPatchAddress,loc_A92DF7.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00946230
        stdcall MPatchAddress,loc_A92DF7.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CF730
        stdcall MPatchAddress,loc_A92DF7.fixup4,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CF72C
        stdcall MPatchAddress,loc_A92DF7.fixup5,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8B350
        stdcall MPatchAddress,loc_A92DF7.fixup6,eax,1
        and     ebx,eax

        ;pause mode camera fix
        ;stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8CBC0
        ;mov     esi,eax
        ;stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F5E3
        ;stdcall MPatchAddress,eax,esi,1
        ;and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F696
        stdcall MPatchCodeCave,eax,loc_A95926,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00945ED0
        stdcall MPatchAddress,loc_A95926.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F69B
        stdcall MPatchAddress,loc_A95926.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F6A6
        stdcall MPatchAddress,loc_A95926.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8ED97
        stdcall MPatchCodeCave,eax,loc_A95027,2+5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8C990
        stdcall MPatchAddress,loc_A95027.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8ED9E
        stdcall MPatchAddress,loc_A95027.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F22F9
        stdcall MPatchCodeCave,eax,loc_9F7C09,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8C990
        stdcall MPatchAddress,loc_9F7C09.fixup1,eax,1
        and     ebx,eax

        ;mouse extra buttons improved support
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EBC98
        stdcall MPatchAddress,eax,check_xbuttons,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008E8270
        stdcall MPatchAddress,SendMouseInput.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008E7710
        stdcall MPatchAddress,SendMouseInput.fixup2,eax,1
        and     ebx,eax

        ;dynamiczoommode
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F2460 ;human
        stdcall MPatchCodeCave,eax,loc_9F7D70,6+4
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F6068
        stdcall MPatchAddress,loc_9F7D70.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F246A
        stdcall MPatchAddress,loc_9F7D70.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F24FA ;dragon
        stdcall MPatchCodeCave,eax,loc_9F7E0A,6+6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F6068
        stdcall MPatchAddress,loc_9F7E0A.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009F2506
        stdcall MPatchAddress,loc_9F7E0A.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F875 ;human (paused)
        stdcall MPatchCodeCave,eax,loc_A95B05,6+4
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F6068
        stdcall MPatchAddress,loc_A95B05.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F87F
        stdcall MPatchAddress,loc_A95B05.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F90F ;dragon (paused)
        stdcall MPatchCodeCave,eax,loc_A95B9F,6+6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F6068
        stdcall MPatchAddress,loc_A95B9F.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F91B
        stdcall MPatchAddress,loc_A95B9F.fixup2,eax,1
        and     ebx,eax

        ;fix mouse wheel down
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EB764
        stdcall MPatchDword,eax,0x88888889
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EB76A
        stdcall MPatchByte,eax,0x03
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EB779
        stdcall MPatchByte,eax,0x8D
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EB80C
        stdcall MPatchByte,eax,0x01
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EBA07
        stdcall MPatchByte,eax,0xEB
        and     ebx,eax

        ;allow binding different hotkeys to the same key
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082E327
        stdcall MPatchByte,eax,0x90
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082E328
        stdcall MPatchByte,eax,0xE9
        and     ebx,eax

        ;remove legacy keybinds
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082EB95
        stdcall MPatchCodeCave,eax,loc_832498,3+2 ;TODO: remove code for actions from sub_A93D70?
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082ED05
        stdcall MPatchAddress,loc_832498.fixup1,eax,1
        and     ebx,eax

        ;show keyboard key modifiers
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EC645 ;TODO: sub_AE6920/sub_AE05B0
        stdcall MPatchCodeCave,eax,loc_8EFF55,20
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008E84A0
        stdcall MPatchAddress,get_keyboard_multikey_string.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B7568
        stdcall MPatchAddress,get_keyboard_multikey_string.fixup2,eax,0
        and     ebx,eax

        ;add new actions
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B2828
        stdcall MPatchByte,eax,97+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082CC62
        stdcall MPatchByte,eax,97+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082B286
        stdcall MPatchByte,eax,96+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082B11C
        stdcall MPatchByte,eax,96+3 ;+3 actions
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082DB82
        stdcall MPatchCodeCave,eax,loc_8313A2,4+6+1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B758C
        stdcall MPatchAddress,add_action_entry.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082B720
        stdcall MPatchAddress,add_action_entry.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B7594
        stdcall MPatchAddress,add_action_entry.fixup3,eax,0
        and     ebx,eax

        ;add new keybinds
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082ED05
        stdcall MPatchCodeCave,eax,loc_832716_n,7+1+1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EC4C0
        stdcall MPatchAddress,insert_keyboard_keybind.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082E140
        stdcall MPatchAddress,insert_keyboard_keybind.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008EC200
        stdcall MPatchAddress,insert_mouse_keybind.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082E140
        stdcall MPatchAddress,insert_mouse_keybind.fixup2,eax,1
        and     ebx,eax

        ;add strings for new/hidden keybinds
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0082C27F
        stdcall MPatchCodeCave,eax,loc_82FA9F,2+6+4
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008E4FD0
        stdcall MPatchAddress,add_keybind_text_entry.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006EA530
        stdcall MPatchAddress,add_keybind_text_entry.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006E5120
        stdcall MPatchAddress,add_keybind_text_entry.fixup3,eax,1
        and     ebx,eax

        ;keybinds blacklist
        stdcall GetRealAddress,PMI_Divinity2Exe,0x007996D4
        stdcall MPatchCodeCave,eax,loc_79D234,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079B2C0
        stdcall MPatchAddress,loc_79D234.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079976E ;TODO: pop up message: This key cannot be changed.
        stdcall MPatchAddress,loc_79D234.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01322BFE
        stdcall MPatchAddress,loc_79D234.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x007996D9
        stdcall MPatchAddress,loc_79D234.fixup4,eax,1
        and     ebx,eax

        ;code for new actions
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8DB43
        stdcall MPatchAddress,eax,loc_A943AA,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8E11A
        stdcall MPatchAddress,loc_A943AA.fixup1,eax,1
        and     ebx,eax

        ;code for new actions in pause mode
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8EDD1
        stdcall MPatchCodeCave,eax,loc_A95061,3+3
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8EDD7
        stdcall MPatchAddress,loc_A95061.fixup1,eax,1
        and     ebx,eax

        ;fix zoom not updating in pause mode
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F682
        stdcall MPatchCodeCave,eax,loc_A95912,3+3
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F7F4
        stdcall MPatchAddress,loc_A95912.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00A8F688
        stdcall MPatchAddress,loc_A95912.fixup2,eax,1
        and     ebx,eax

        .exgraphics:
        cmp     dword[ini_opts_exgraphics],0
        je      .exswitches

        ;extended fpscap slider + float value converted to int
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483EC
        stdcall MPatchAddress,MenuSetFPSCap.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483EC
        stdcall MPatchAddress,MenuGetFPSCap.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B5D50
        stdcall MPatchAddress,eax,MenuSetFPSCap,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B5D5A
        stdcall MPatchAddress,eax,MenuGetFPSCap,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B5D5F
        stdcall MPatchAddress,eax,MenuGetFPSCap,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B5D63
        stdcall MPatchWord,eax,0x8689 ;change fstp esi+x to mov esi+x,eax
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B4837
        stdcall MPatchWord,eax,0x8689 ;change fstp esi+x to mov esi+x,eax
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACD4B
        stdcall MPatchCodeCave,eax,loc_9B262B,6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACD51
        stdcall MPatchAddress,loc_9B262B.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACE13
        stdcall MPatchCodeCave,eax,loc_9B26F3,31
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACE32
        stdcall MPatchAddress,loc_9B26F3.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACE83
        stdcall MPatchCodeCave,eax,loc_9B2763,31
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACEA2
        stdcall MPatchAddress,loc_9B2763.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x007990EF
        stdcall MPatchCodeCave,eax,loc_79CC4F,45
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0079911C
        stdcall MPatchAddress,loc_79CC4F.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6F75
        stdcall MPatchCodeCave,eax,loc_9BC855,60
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6FB1
        stdcall MPatchAddress,loc_9BC855.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6B1A
        stdcall MPatchCodeCave,eax,loc_9BC3FA,17
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6B2B
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
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088A143
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088A166
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088A2B4
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088A2D8
        stdcall MPatchDword,eax,2500+12*2 ;fullscreen+borderless
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483EC
        stdcall MPatchAddress,MenuGetFullscreen.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483EC
        stdcall MPatchAddress,MenuSetFullscreen.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483EC
        stdcall MPatchAddress,MenuGetBorderless.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483EC
        stdcall MPatchAddress,MenuSetBorderless.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B12F2
        stdcall MPatchCodeCave,eax,loc_9B6BD2,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009AD570
        stdcall MPatchAddress,loc_9B6BD2.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F6240
        stdcall MPatchAddress,loc_9B6BD2.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ADB60
        stdcall MPatchAddress,loc_9B6BD2.fixup3,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F6240
        stdcall MPatchAddress,loc_9B6BD2.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ADB60
        stdcall MPatchAddress,loc_9B6BD2.fixup5,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B12F7
        stdcall MPatchAddress,loc_9B6BD2.fixup6,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B5D82
        stdcall MPatchCodeCave,eax,loc_9BB662,14
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B5D90
        stdcall MPatchAddress,loc_9BB662.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6BB2
        stdcall MPatchCodeCave,eax,loc_9BC492,6
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B6BB8
        stdcall MPatchAddress,loc_9BC492.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088B385
        stdcall MPatchCodeCave,eax,loc_88ED05,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0088B38C
        stdcall MPatchAddress,loc_88ED05.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B495A
        stdcall MPatchCodeCave,eax,loc_9BA23A,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B495F
        stdcall MPatchAddress,loc_9BA23A.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B73ED
        stdcall MPatchCodeCave,eax,loc_9BCCCD,7
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F18FC
        stdcall MPatchAddress,loc_9BCCCD.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B73F4
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
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B41757
        stdcall MPatchCodeCave,eax,loc_B47AB7,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B4175C
        stdcall MPatchAddress,loc_B47AB7.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B41795
        stdcall MPatchCodeCave,eax,loc_B47AF5,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B4179A
        stdcall MPatchAddress,loc_B47AF5.fixup1,eax,1
        and     ebx,eax

        ;write borderless to settings
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A4143
        stdcall MPatchCodeCave,eax,loc_6A4143,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B758C
        stdcall MPatchAddress,loc_6A4143.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A54B0
        stdcall MPatchAddress,loc_6A4143.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B7590
        stdcall MPatchAddress,loc_6A4143.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006572A0
        stdcall MPatchAddress,loc_6A4143.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B7590
        stdcall MPatchAddress,loc_6A4143.fixup5,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006587A0
        stdcall MPatchAddress,loc_6A4143.fixup6,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B7594
        stdcall MPatchAddress,loc_6A4143.fixup7,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x012B7594
        stdcall MPatchAddress,loc_6A4143.fixup8,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01314C80
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
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01314E9C
        stdcall MPatchAddress,loc_6A4FAB.fixup2,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006A4FB6
        stdcall MPatchAddress,loc_6A4FAB.fixup3,eax,1
        and     ebx,eax

        ;move vsync/fpscap outside of advanced options
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B12F7
        stdcall MPatchCodeCave,eax,loc_9B6BD7,5
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01337FD0
        stdcall MPatchAddress,loc_9B6BD7.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F6240
        stdcall MPatchAddress,loc_9B6BD7.fixup2,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01337FF8
        stdcall MPatchAddress,loc_9B6BD7.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F6240
        stdcall MPatchAddress,loc_9B6BD7.fixup4,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009AD300
        stdcall MPatchAddress,loc_9B6BD7.fixup5,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01338768
        stdcall MPatchAddress,loc_9B6BD7.fixup6,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F6240
        stdcall MPatchAddress,loc_9B6BD7.fixup7,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x01338788
        stdcall MPatchAddress,loc_9B6BD7.fixup8,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x008F6240
        stdcall MPatchAddress,loc_9B6BD7.fixup9,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009ACD30
        stdcall MPatchAddress,loc_9B6BD7.fixup10,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B1317
        stdcall MPatchAddress,loc_9B6BD7.fixup11,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B134E
        stdcall MPatchDword,eax,0xCCCC49EB
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x009B1BE8
        stdcall MPatchDword,eax,0xCCCC4BEB
        and     ebx,eax

        .exswitches:
        cmp     dword[ini_opts_exswitches],0
        je      .end

        ;read settings
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006D3646
        stdcall MPatchCodeCave,eax,loc_6D6BE4,68
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CEED2
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
        stdcall GetRealAddress,PMI_Divinity2Exe,0x006D368A
        stdcall MPatchAddress,loc_6D6BE4.fixup5,eax,1
        and     ebx,eax

        ;check default config changed
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CEEE6
        stdcall MPatchAddress,CheckConfigChanged.fixup1,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F1906
        stdcall MPatchAddress,CheckConfigChanged.fixup2,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F1930
        stdcall MPatchAddress,CheckConfigChanged.fixup3,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CEEDE
        stdcall MPatchAddress,CheckConfigChanged.fixup4,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F192C
        stdcall MPatchAddress,CheckConfigChanged.fixup5,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014CEED2
        stdcall MPatchAddress,CheckConfigChanged.fixup6,eax,0
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x014F1954
        stdcall MPatchAddress,CheckConfigChanged.fixup7,eax,0
        and     ebx,eax

        ;playintrovideo
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B39590
        stdcall MPatchCodeCave,eax,loc_B3F900,8
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B41BB0
        stdcall MPatchAddress,loc_B3F900.fixup1,eax,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00B39598
        stdcall MPatchAddress,loc_B3F900.fixup2,eax,1
        and     ebx,eax

        ;customcamerafov
        stdcall GetRealAddress,PMI_Divinity2Exe,0x00873BA8
        stdcall MPatchAddress,eax,set_cameraFOV,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x0094BDA8 ;unused?
        stdcall MPatchAddress,eax,set_cameraFOV,1
        and     ebx,eax
        stdcall GetRealAddress,PMI_Divinity2Exe,0x015483E8
        stdcall MPatchAddress,set_cameraFOV.fixup1,eax,0
        and     ebx,eax

        .end:
        mov     eax,ebx
        pop     ebx
        ret
endp
