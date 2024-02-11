param ([string]$number="")
if ($number -eq "") {
	$number = Read-Host 'Input number to convert'
}

[bool]$IsNegative = $false
if ($number[0] -eq "-") {
    $IsNegative = $true
    [int]$end = $number.Length-1
    $number = $number.Substring(1, $end)
    #write-host $number
}

[bool]$IsCorrect = $true
for ([int]$i=0; $i -lt $number.Length; $i++){
    if (($number[$i] -ne "0") -and ($number[$i] -ne "1") -and ($number[$i] -ne ".")){
        $IsCorrect = $false
    }
}

if ($IsCorrect) {
    [int]$countInt = 0
    for ([int]$i=0; ($i -lt $number.Length) -and ($number[$i] -ne "."); $i++){
        $countInt = $countInt + 1
    }

    # дополнение целой части до триад
    while ($countInt % 3 -ne 0) {
        $number = "0" + $number
        $countInt = $countInt + 1
    }
    #write-host $number
    #write-host $countInt
    [string]$digit=""
    [string]$res=""

    $map = @{
        '000' = '0';
        '001' = '1';
        '010' = '2';
        '011' = '3';
        '100' = '4';
        '101' = '5';
        '110' = '6';
        '111' = '7';
    }

    # перевод целой части
    for ([int]$i=1; $i -le $countInt; $i++){
        $digit = $digit + $number[$i-1] 
        if ($i % 3 -eq 0){
            #write-host $digit
            $res = $res + $map[$digit]
            #write-host $map[$digit]
            $digit = ""
        }
    }

    # перевод дробной части, если она существует
    if ($countInt -ne $number.Length){
        $res += "."
        $digit = ""
        for ([int]$i = $countInt +2; $i -le $number.Length; $i++){
            $digit += $number[$i - 1]
            if (($i - $countInt - 1) % 3 -eq 0) {
                $res += $map[$digit]
                $digit = ""
            }
        }
        # дополнение дробной части до триад
        if ($digit.length % 3 -ne 0) {
            while ($digit.length % 3 -ne 0) {
                $digit += "0"
                $number += "0"
            }
            $res += $map[$digit]
        }

        if ($IsNegative) {
            $res = "-" + $res 
        }
        write-host "answer = " $res

    }
    
}
else {
    write-host "Number isn't correct"
}