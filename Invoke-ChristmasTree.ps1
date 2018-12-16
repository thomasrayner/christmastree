function Invoke-ChristmasTree {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)]
        [validatescript({$_ -lt $host.ui.rawui.buffersize.width / 2})]
        [int]$TreeWidth
    )

    $tree = New-Object System.Collections.ArrayList
    $colors = 'red', 'blue', 'yellow'

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

    foreach ($row in $tree) {
        $rowArray = $row.ToCharArray()
        foreach ($char in $rowArray) {
            if (-not [string]::IsNullOrEmpty($char)) {
                if ($char -eq '@') {$color = 'yellow'}
                elseif ($char -eq '%') {$color = 'darkred'}
                else {
                    $color = 'darkgreen'
                    if ($(Get-Random -Minimum 1 -Maximum 11) -eq 10) {
                        $color = Get-Random -InputObject $colors
                    }
                }
                Write-Host $char -ForegroundColor $color -NoNewline
            }
            else {
                Write-Host $char -NoNewline
            }
        }
        Write-Host
    }
}
