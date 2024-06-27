num_version_ids         dd 6

;gog
build_id0_addr          dd 0x01476AA0
build_id0_pstr          dd VER_v1_4_700_38
build_id1_addr          dd 0x0147D9A0
build_id1_str           dd VER_v1_4_700_41

;steam
build_id2_addr          dd 0x0147EA00
build_id2_str           dd VER_v1_4_700_47
build_id3_addr          dd 0x01476B20
build_id3_str           dd VER_v1_4_700_49

;yaxis hotfix
build_id4_addr          dd 0x01476B70
build_id4_str           dd VER_v1_4_700_56
build_id5_addr          dd 0x0147EA50
build_id5_str           dd VER_v1_4_700_57

VER_v1_4_700_38         db 'v1.4.700.38',0 ;Divinity2.exe
VER_v1_4_700_41         db 'v1.4.700.41',0 ;Divinity2-debug.exe
VER_v1_4_700_47         db 'v1.4.700.47',0 ;Divinity2-debug.exe
VER_v1_4_700_49         db 'v1.4.700.49',0 ;Divinity2.exe
VER_v1_4_700_56         db 'v1.4.700.56',0 ;Divinity2.exe
VER_v1_4_700_57         db 'v1.4.700.57',0 ;Divinity2-debug.exe

;--------------------------------------------------

sec_main                du 'Main',0
key_enable              du 'EnablePatch',0
def_enable              dd 1

sec_options             du 'Options',0
key_globalfps           du 'GlobalFPSUnlock',0
def_globalfps           dd 1
;key_exoptions           du 'ExtendedGameplayOptions',0
;def_exoptions           dd 1
key_excontrols          du 'ExtendedControlsOptions',0
def_excontrols          dd 1
key_exgraphics          du 'ExtendedGraphicsOptions',0
def_exgraphics          dd 1
key_exswitches          du 'ExtendedGlobalSwitches',0
def_exswitches          dd 1

;--------------------------------------------------

dbl_1000_0              dq 1000.0

;--------------------------------------------------
; Div2Patch version display
;--------------------------------------------------

CStrPatchVersionText    db ' | ',ProjectName,' v',ProjectVersion,0

;--------------------------------------------------
; extended control options
;--------------------------------------------------

iZoomRangeMin           dd -10
iZoomRangeMax           dd 10

WStr_KeyMod_LC          du '(LC)+',0
WStr_KeyMod_RC          du '(RC)+',0
WStr_KeyMod_LS          du '(LS)+',0
WStr_KeyMod_RS          du '(RS)+',0
WStr_KeyMod_LA          du '(LA)+',0
WStr_KeyMod_RA          du '(RA)+',0

CStr_AM_ZoomIn          db 'AM_ZOOM_IN',0
CStr_AM_ZoomOut         db 'AM_ZOOM_OUT',0
CStr_AM_ZoomReset       db 'AM_ZOOM_RESET',0

WStr_ControlCamera      du 'Look around in pause mode',0
WStr_ToggleMenu         du 'Open Main Menu',0
WStr_ToggleConsole      du 'Open Developer Console',0
WStr_ToggleDebug        du 'Toggle debug info',0
WStr_ZoomIn             du 'Zoom in',0
WStr_ZoomOut            du 'Zoom out',0
WStr_ZoomReset          du 'Reset zoom',0

;--------------------------------------------------
; extended graphic options
;--------------------------------------------------

WStrFullscreen          du 'Fullscreen',0
WStrBorderless          du 'Borderless',0

CStrBorderless          db 'Borderless',0

FPSCapDefaultValue      dd 30
FPSCapSliderMinFPS      dd 30
FPSCapSliderMaxFPS      dd 240

;--------------------------------------------------
; extended global switches
;--------------------------------------------------

CStrPlayIntroVideo      db 'PlayIntroVideo',0
CStrCustomCameraFOV     db 'CustomCameraFOV',0
CStrDynamicCameraZoom   db 'DynamicCameraZoom',0

uiFOVRangeMin           dd 60
uiFOVRangeMax           dd 120
fZoomStepsDist          dq 0.25
fHumanCameraDistance    dq 3.75
fDragonCameraDistance   dq 7.0
