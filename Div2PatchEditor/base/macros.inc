;# made by Tomasz Grysztar
struc db [data]
{
        common . db data 
        sizeof.#. = $ - .
}

struc dd [data]
{
        common . dd data 
        sizeof.#. = $ - .
}

struc du [data]
{
        common . du data 
        sizeof.#. = $ - .
}

struc dq [data]
{
        common . dq data
        sizeof.#. = $ - .
}

struc du [data]
{
        common . du data 
        sizeof.#. = $ - .
}

macro versioninfoex label,filever,productver,flagsmask,fileflags,fileos,filetype,filesubtype,lang,cp,[name,value] ;modified versioninfo macro
 { common
    local data,size,vivalue,visize
    label dd RVA data,size,0,0
    data dw size,visize,0
    du 'VS_VERSION_INFO',0,0
    vivalue dd 0FEEF04BDh,00010000h
    virtual at 0
     db filever
     count = $
     fileversion = 0
     shift = 16
     repeat count
      load char from %-1
      if char='.'
       if shift mod 32
        shift = shift-16
       else
        shift = shift+32+16
       end if
      else
       fileversion = (fileversion and not (0FFFFh shl shift)) or ((fileversion shr shift and 0FFFFh)*10+char-'0') shl shift
      end if
     end repeat
    end virtual
    virtual at 0
     db productver
     count = $
     productversion = 0
     shift = 16
     repeat count
      load char from %-1
      if char='.'
       if shift mod 32
        shift = shift-16
       else
        shift = shift+32+16
       end if
      else
       productversion = (productversion and not (0FFFFh shl shift)) or ((productversion shr shift and 0FFFFh)*10+char-'0') shl shift
      end if
     end repeat
    end virtual
    dq fileversion,productversion
    dd flagsmask,fileflags,fileos,filetype+0,filesubtype+0,0,0
    visize = $ - vivalue
    local sfi_data,sfi_size
    sfi_data dd sfi_size
    du 1,'StringFileInfo',0
    local str_data,str_size
    str_data dd str_size
    du 1,'040904E4',0
   forward
    local vs_data,vs_size,value_data,value_size
    align 4
    vs_data dw vs_size,value_size/2
    du 1,name,0
    align 4
    value_data du value,0
    value_size = $ - value_data
    vs_size = $ - vs_data
   common
    align 4
    str_size = $ - str_data
    sfi_size = $ - sfi_data
    local vfi_data,vfi_size,var_data,var_size
    vfi_data dd vfi_size
    du 1,'VarFileInfo',0,0
    var_data dw var_size,4
    du 0,'Translation',0,0
    dw lang,cp+0
    var_size = $ - var_data
    vfi_size = $ - vfi_data
    size = $ - data }
