;--------------------------------------------------
; global fps limiter
;--------------------------------------------------

FPSLimiter1             FPSLIMITER 0,1,2.0,30.0 ;bInitialized, bUseQPC, fSleepThreshold, fMaxFPS
FPSLimiter2             FPSLIMITER 0,1,2.0,30.0 ;bInitialized, bUseQPC, fSleepThreshold, fMaxFPS
FPSLimiter3             FPSLIMITER 0,1,2.0,30.0 ;bInitialized, bUseQPC, fSleepThreshold, fMaxFPS

;--------------------------------------------------
; extended control options
;--------------------------------------------------

iCameraZoomLevel        dd 0

bUpdatePausedCam        dd 0

;--------------------------------------------------
; extended global switches
;--------------------------------------------------

bPlayIntroVideo         db 1
uiCustomCameraFOV       dd 0
bDynamicZoom            db 1
