
$DebugPreference = "Continue"

. ./lib_cut_merge_methods.ps1


# Define a function that takes another function as an argument
function CallWithArgument([scriptblock] $callback, $arg) {
    & $callback $arg
}

# Define a function that will be passed as an argument
function MyFunction($message) {
    Write-Host "MyFunction called with argument '$message'"
}

# Call CallWithArgument with MyFunction as the callback and a string argument
CallWithArgument ${function:MyFunction} "Hello, world!"

return

Get-ChildItem -LiteralPath $working_dir -Recurse -Include $video_types_list -Exclude $cut_ps1_prefix_list 

Write-Host "`n do nothing , for divide`n"


$videoIncluPrefix="src_"
$videoIncluPrefixList=@($videoIncluPrefix)


Get-ChildItem -Path $working_dir -Include ($videoIncluPrefixList + "*") -Exclude ($videoIngonrePrefix + "*") -File |
    Where-Object { $video_types_list -contains $_.Extension.TrimStart('.') }


test_trim_start="123.123.456.mp3.mp4"


$DebugPreference = "SilentlyContinue"
