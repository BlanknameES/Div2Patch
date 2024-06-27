# Div2Patch

Div2Patch is a fan-made patch for 'Divinity II: Developer's Cut' that focuses in bug fixes, QoL improvements and improving overall compatibility with modern systems.

# Current feature list:

- Includes the latest official patch: the 'Y-Axis HotFix' (v1.4.700.56/57).
- Large Address Aware flag enabled in both executables (AKA the 4GB patch).
- All internal frame limit caps from the engine are removed.
- Added Fullscreen and Borderless Window checkboxes in the graphic options menu.
- New 'CustomCameraFOV' setting added to globalswitches.xml. Allows to change the Field of View of the camera.
- New 'PlayIntroVideo' setting added to globalswitches.xml. Allows to skip the intro video.
- Keybinds can now be unassigned by pressing ESC.
- Changed camera rotation method in human-form. This new method has no negative mouse acceleration and movement should be more fluid than before.
- Fixed player rotation speed being tied to frame rate. This caused the character model to turn around extremely slow when running at high FPS.
- New experimental setting 'DynamicCameraZoom' added to globalswitches.xml. When disabled, moving the camera up/down will not affect camera distance from the player anymore.
- Improved the detection of extra mouse buttons 1 and 2 (AKA Forward/Back buttons).
- A new in-game FPS limiter has been implemented (the old one was the cause of the camera stuttering issues).
- 'Vsync' and 'FPS Cap' options are now visible by default without ticking 'Show Advanced Options'.
- Fixed mouse scroll down bogus behaviour when used as keybind.
- Keybinding to an already bound key is now possible.
- Mouse middle button is now bindable.
- Removed legacy keybinds that were hard-coded in the engine. One of these keybinds was the cause of player attacking when clicking left-alt key.
- Keyboard key modifiers (control/shift/alt) of keybinds are now properly displayed.
- Added new keybinds: 'Zoom In', 'Zoom Out' and 'Reset Zoom'. The new keybinds cannot be remapped (yet).
- All hard-coded keybinds are now visible in the options menu. These previously hidden keybinds cannot be remapped (yet).
