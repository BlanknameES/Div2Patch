patcher_t1_basename     du 'Divinity2.exe',0
patcher_t2_basename     du 'Divinity2-debug.exe',0

ini_basename            du ProjectName,'.ini',0

;--------------------------------------------------

ini_sec_main            du 'Main',0
ini_key_enable          du 'EnablePatch',0
ini_def_enable          dd 1

ini_sec_patches         du 'Options',0
ini_key_globalfps       du 'GlobalFPSUnlock',0
ini_def_globalfps       dd 1
ini_key_excontrols      du 'ExtendedControlsOptions',0
ini_def_excontrols      dd 1
ini_key_exgraphics      du 'ExtendedGraphicsOptions',0
ini_def_exgraphics      dd 1
ini_key_exswitches      du 'ExtendedGlobalSwitches',0
ini_def_exswitches      dd 1

;--------------------------------------------------

ClassName               du SubProjectName,'Class',0
WindowName              du SubProjectName,' v',SubProjectVersion,0

errorcap                du 'Error',0
registererror           du 'Could not register window class!',0
createerror             du 'Could not create main window!',0
;openerror               du 'Could not open file!',0
;versionerror            du 'Unknown file version!',0
;readerror               du 'Could not read file!',0
;saveerror               du 'Could not patch file!',0
;writeerror              du 'Could not write file!',0

warncap                 du 'Warning',0
fonterror               du 'Failed to create main font for window controls. Texts may not be displayed properly.',0
;patchederror            du 'File already patched!',0
;unpatchederror          du 'File is not patched!',0

;infocap                 du 'Information',0
;notopenerror            du 'Select a file to open first',0

gb_t1_gb                du 'Divinity.exe',0
st_t1_version           du 'Version: ',0
eb_t1_version           du 'Unknown',0
st_t1_status            du 'Status: ',0
eb_t1_status            du 'Unknown',0
bu_t1_patch             du 'Patch',0
bu_t1_restore           du 'Restore',0

gb_t2_gb                du 'Divinity-debug.exe',0
st_t2_version           du 'Version: ',0
eb_t2_version           du 'Unknown',0
st_t2_status            du 'Status: ',0
eb_t2_status            du 'Unknown',0
bu_t2_patch             du 'Patch',0
bu_t2_restore           du 'Restore',0

gb_settings             du 'Settings',0
st_main                 du 'Main',0
cb_enable               du 'EnablePatch',0
st_options              du 'Options',0
cb_globalfps            du 'GlobalFPSUnlock',0
cb_excontrols           du 'ExtendedControlsOptions',0
cb_exgraphics           du 'ExtendedGraphicsOptions',0
cb_exswitches           du 'ExtendedGlobalSwitches',0
bu_save                 du 'Save',0
bu_reset                du 'Reset',0

;stat_unknown            du 'Unknown',0
;stat_unpatched          du 'Not patched',0
;stat_patched            du 'Patched',0
;stat_modified           du 'Modified',0
;stat_oldpatch           du 'Patched*',0

WC_BUTTON               du 'Button',0
WC_EDIT                 du 'Edit',0
WC_STATIC               du 'Static',0

fnt_arial               du 'Arial',0
