;SpaceFn
getSelText()
{
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert} 
    ClipWait,0.1
    selText:=Clipboard
    Clipboard:=ClipboardOld
    return selText
}
getLineText()
{
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, {end}+{home}^{insert}
    ClipWait,0.1
    selText:=Clipboard
    Clipboard:=ClipboardOld
    return selText
}
GetObjJScript()
{
   if !FileExist(ComObjFile := A_ScriptDir "\JS.wsc")
      FileAppend,
         (LTrim
            <component>
            <public><method name='eval'/></public>
            <script language='JScript'></script>
            </component>
         ), % ComObjFile
   Return ComObjGet("script:" . ComObjFile)
}
getJSEval(text)
{
sc := GetObjJScript()


return sc.Eval(text)

}

#inputlevel,2
$Space::
    SetMouseDelay -1
    Send {Blind}{F24 DownR}
    KeyWait, Space
    Send {Blind}{F24 up}
    ; MsgBox, %A_ThisHotkey%-%A_TimeSinceThisHotkey%
    if(A_ThisHotkey="$Space" and A_TimeSinceThisHotkey<1000)
        Send {Blind}{Space DownR}
    return


#inputlevel,1
F24 & e::Up
F24 & d::Down
F24 & s::Left
F24 & f::Right
F24 & a::Home
F24 & z::End
F24 & n::PgUp
F24 & m::PgDn

F24 & 1::F1
F24 & 2::F2
F24 & 3::F3
F24 & 4::F4
F24 & 5::F5
F24 & 6::F6
F24 & 7::F7
F24 & 8::F8
F24 & 9::F9
F24 & 0::F10
F24 & -::F11
F24 & =::F12
F24 & tab::
    comObjError(0)
    selText:=getSelText()
    selText:=selText==""?getLineText():selText
    output:=Format("{}",getJSEval(selText))
    output:=output~="^\d+\.\d+$" ? RTrim(RTrim(output,"0"),".") : output

    Send {Blind}{Text}%output%
return
#inputlevel,0
*CapsLock::
	Send {Blind}{LControl down}
	Return
*CapsLock up::
	Send {Blind}{LControl Up}
	if (A_PriorKey=="CapsLock"){
		if (A_TimeSincePriorHotkey < 1000)
			Suspend On
			Send, {Blind}{Esc}
			Suspend Off
	}
	Return

;#-->Win
;!-->Alt
;^-->Ctrl
;+-->Shift
