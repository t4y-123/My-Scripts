
#简单的重命名，方便将自动剪切的一些片段移到后面合并。

function Rename-Files {
    param(
        [string]$char
    )

    $files = Get-ChildItem -File
    $cur = Get-Location

    foreach ($file in $files) {
        $newName = $file.name -replace '(Scene-)\d(\d\d)', "`${1}${char}`${2}"
		#$newName = $file.name -replace '(Scene-)\d(\d\d)', "${1}${char}${2}"#not work
    # $newName=$file.name -replace '(Scene-)\d(\d\d)', '${1}2$2'
    # $newName=$file.name -replace '(Scene-)\d(\d\d)', '${1}3$2'
    # $newName=$file.name -replace '(Scene-)\d(\d\d)', '${1}9$2'
    # $newName=$file.name -replace '(Scene-)\d(\d\d)', '${1}a$2'
    # $newName=$file.name -replace '(Scene-)\d(\d\d)', '${1}b$2'
    # $newName=$file.name -replace '(Scene-)\d(\d\d)', '${1}c$2'

        if ("X$newName" -ne "X" + $file.Name) {
            $srcPath = Join-Path $cur $file.Name
            $desPath = Join-Path $cur $newName
            "src:" + $srcPath
            "des:" + $desPath + "$n$n"
            Rename-Item -LiteralPath $srcPath -NewName $desPath
        }
    }
}

$char = Read-Host "Enter a character to use in the file renaming:"

while ($char -eq "") {
    $char = Read-Host "Please enter a character to use in the file renaming:"
}

Rename-Files -char $char

