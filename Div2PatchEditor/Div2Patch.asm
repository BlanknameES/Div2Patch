;--------------------------------------------------
;=================> FASM 1.73.32 <=================
;--------------------------------------------------
;
;  Div2PatcherEditor by Blankname
;
;--------------------------------------------------

include 'base\includes.inc'
include 'base\macros.inc'
include 'base\variables.inc'
include 'base\rsrc.inc'

;--------------------------------------------------

format PE GUI 4.0 at 0x00400000 as 'exe'
entry start

section '.code' code readable executable
include 'base\_code.asm'
include 'base\_code_utils.asm'

section '.idata' import data readable
include 'base\_idata.asm'

;section '.edata' export data readable
;include 'base\_edata.asm'

section '.rdata' data readable
include 'base\_rdata.asm'
include 'base\_rdata_patches.asm'

section '.data' data readable writeable
include 'base\_data.asm'

;section '.bss' readable writeable
;include 'base\_bss.asm'

section '.rsrc' resource data readable
include 'base\_rsrc.asm'

;section '.reloc' fixups data readable discardable
;include 'base\_reloc.asm'
