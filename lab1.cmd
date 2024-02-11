@ECHO OFF
setlocal EnableDelayedExpansion

set number=%1
::echo number !number!
if not defined number goto :getNumber
goto :checkNumber

:getNumber
set /p number=enter a number: 
if not defined number goto :eof

:checkNumber
    set /A isPoint=0
    call :strLength %number% length
    ::echo length = !length!
    set /a len=!length!-1
    ::echo !len!
    set var=!number!
    if "!var:~0,1!" equ "-" set var=!var:~1!
    for /l %%i in (0, 1, !len!) do (
        if "!var:~%%i,1!" neq "0" if "!var:~%%i,1!" neq "1" if "!var:~%%i,1!" neq "." goto :incorrect else if %isPoint equ 0 set /A isPoint=1 else if %isPoint equ 1 goto :incorrect
    )

:convert2to8
    echo correct
    call :whileCountInt !number! countInt
    ::echo countInt = !countInt!

    set /a countFract=!length!-1-!countInt!
    ::echo countFract = !countFract!

    call :whileAddInt !number! countInt numberNew
    ::echo new number = !numberNew!

    call :convertInt numberNew !countInt! numberInt
    ::echo numberInt = !numberInt!

    if !countFract! leq 0 (
        echo answer = !numberInt!
        goto :eof
    )
    call :convertFract number numberInt !countFract! numberAns
    echo answer = !numberAns!

goto :eof
:convertFract
    set fract=!%1:~-%3!
    set /a fr=!fract!%%3
    ::echo frect !fract! fr  !fr!
    set /a lenFract=%3
    if !fr! equ 1 (
        set fract=!fract!00
        set /a lenFract=%3+2
    )
    if !fr! equ 2 (
        set fract=!fract!0
        set /a lenFract=%3+1
    )
    set ans=!%2!
    set ans=!ans!.
    set res=
    set digit=
    set /a i=0
    :whileConvertFract
        if !i! geq !lenFract! (
            set %4=!ans!!res!
            goto :eof
        )
        set digit=!digit!!fract:~0,1!
        set fract=!fract:~1!
        set /a i+=1
        set /a t=!i!%%3
        ::echo t !t!   i !i!
        if !t! equ 0 (
            call :ifConvertInt digit res
            set digit=
        )
        goto :whileConvertFract

goto :eof
:convertInt
    set res=
    set digit=
    set var=!%1!
    if "!var:~0,1!" equ "-" (
        set var=!var:~1!
        set %3=-
    )
    set /a i=0
    :whileCOnvertInt 
        ::echo digit !digit!
        ::echo !i!
        if !i! geq %2 (
            set %3=!%3!!res!
            goto :eof
        )
        set digit=!digit!!var:~0,1!
        set var=!var:~1!
        ::echo new var !var!
        set /a i+=1
        set /a t=!i!%%3
        ::echo t !t!
        if !t! equ 0 (
            call :ifConvertInt digit res
            set digit=
        )
        goto :whileCOnvertInt

goto :eof
:ifConvertInt
    set res=!%2!
    ::echo !res!
    if "!%1!" equ "000" set res=!res!0
    if "!%1!" equ "001" set res=!res!1
    if "!%1!" equ "010" set res=!res!2
    if "!%1!" equ "011" set res=!res!3
    if "!%1!" equ "100" set res=!res!4
    if "!%1!" equ "101" set res=!res!5
    if "!%1!" equ "110" set res=!res!6
    if "!%1!" equ "111" set res=!res!7
    set %2=!res!
    ::echo !res!
    goto :eof

goto :eof
:whileAddInt 
    set var=%1

    :whileAddInt_start
        set /a t=!%2!%%3
        ::echo !t!
        if !t! equ 0 goto :eof
        set /a %2+=1
        if "!var:~0,1!" equ "-" set var=-0!var:~1! 
        if "!var:~0,1!" neq "-" set var=0!var!
        ::echo !var!
        set %3=!var!
        goto :whileAddInt_start

goto :eof
:whileCountInt
    set var=%1
    if "!var:~0,1!" equ "-" set var=!var:~1!
    set /a i=0
    set /a %2=0
    
    :whileCountInt_start
        if not defined var goto :eof 
        if "!var:~0,1!" equ "." goto :eof
        set /a %2+=1
        set var=!var:~1!
        set /a i+=1
        goto :whileCountInt_start

:incorrect
    echo number is not correct

goto :eof

:strLength
    set /a %2=0
    set var=%~1
    ::echo var !var!
    if "!var:~0,1!" equ "-" set var=!var:~1!
    ::echo var !var!
    :startvarcount
        if not defined var goto :eof 
        set var=%var:~1%
        set /a %2+=1
        goto startvarcount
goto :eof