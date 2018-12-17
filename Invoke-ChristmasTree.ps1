function Invoke-ChristmasTree {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)]
        [validatescript({$_ -lt $host.ui.rawui.buffersize.width / 2})]
        [int]$TreeWidth
    )

    $tree = New-Object System.Collections.ArrayList
    $colors = 'red', 'blue', 'yellow'
    $colorTwinkle = 31, 34, 33
    $ornaments = New-Object System.Collections.ArrayList
    $E = [char]27
    "${E}[?25l"

    if ($TreeWidth % 2 -eq 0) { 
        $trueWidth = $TreeWidth + 1
    }
    else {
        $trueWidth = $TreeWidth
    }

    $starPosition = [math]::round($trueWidth / 2)
    $null = $tree.Add(' ' * ($starPosition - 1) + ' @')

    for ($i = 1; $i -lt [math]::round($trueWidth / 2); $i++) {        
        $row = ' ' * ([math]::round($trueWidth / 2) - $i)
        $row += '*' * $i * 2 + '*'
        $null = $tree.Add($row)
    }

    $null = $tree.Add(@"
$(' ' * ($starPosition - 1))%%%
$(' ' * ($starPosition - 1))%%%
$(' ' * ($starPosition - 1))%%%
"@)

    $r = 1
    $c = 0
    clear-host
    "${E}[s"
    foreach ($row in $tree) {
        $r++
        $c = 0
        $rowArray = $row.ToCharArray()
        foreach ($char in $rowArray) {
            $c++
            if (-not [string]::IsNullOrWhiteSpace($char)) {
                if ($char -eq '@') {$color = 'yellow'}
                elseif ($char -eq '%') {$color = 'darkred'}
                else {
                    $color = 'darkgreen'
                    if ($(Get-Random -Minimum 1 -Maximum 11) -eq 10) {
                        $null = $ornaments.Add("$c,$r")
                        $color = Get-Random -InputObject $colors
                    }
                }
                Write-Host $char -ForegroundColor $color -BackgroundColor black -NoNewline
            }
            else {
                Write-Host $char -NoNewline
            }
        }
        Write-Host
    }

    "${E}[u"
    while ($true) {
        foreach ($ornament in (Get-Random -InputObject $ornaments -Count 4)) {
            $newColor = Get-Random -InputObject $colorTwinkle
            $c,$r = $ornament.Split(',')
            "${E}[${c}G${E}[${r}d${E}[40m${E}[${newColor}m*"
        }
        Start-Sleep -Milliseconds 150
    }
}
