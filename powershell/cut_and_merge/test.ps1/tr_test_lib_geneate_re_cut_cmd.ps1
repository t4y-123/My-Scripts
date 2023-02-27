
$DebugPreference = "Continue"

. ./lib_cut_merge_methods.ps1


if (Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList){
	#Write-Host "open txt "
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
}else{
	Write-Warning "Operation aborted."
	return 
}

$srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
if (!$srcTxtFile) {
	Write-Warning "No source text file found with prefix '${srcTextPrefix}' in directory '${working_dir}'."
	return
}
$preCutContent=@"
<

"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#   []`$(10).mp4
000100	000135


"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(1).mp3.mp4
000124	00050116

"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(11).mp4
00:01:02	00:01:30.135

"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(12) - 副本.mp4


"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(12).mp4
000002	00:01:10.135
000124	00050116

"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(12)-副本.mp4
000124	00050116

>

"@

Set-Content -LiteralPath $srcTxtFile.FullName $preCutContent
# Write-Host "`nvideo_types_list :$video_types_list"
if( !(Generate-CutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix -O))
{
	Write-Error "Generate-ReCutPowerShellFile"
	return
}


# 运行剪切powershell脚本，
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${cut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	Write-Host "run  $scriptFile "
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
    Write-Warning "No script file found with prefix '${cut_ps1_prefix}' in directory '${working_dir}'."
}

$newCutContent=@"
<
"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#   []`$(10).mp4
000100	000135

"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(1).mp3.mp4
000124	00050116
>
<
"Dir_2023-02-19_214648166"
:魔法少女まどか☆マギカ#`$(11).mp4

000124	00050116
"Dir_2023-02-"
:魔法少女まどか☆マギカ#`$(12) - 副本.mp4
000124	00050116

"Dir_2023-02-"
:魔法少女まどか☆マギカ#`$(12).mp4
000002	00:01:10.135

"Dir_2023-02-"
:魔法少女まどか☆マギカ#`$(12)-副本.mp4
00:01:02	00:01:10.135
000124	00020116

>
"@

Set-Content -LiteralPath $srcTxtFile.FullName $newCutContent

if ( !(Generate-ReCutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix ))
{
	Write-Error "Generate-ReCutPowerShellFile"
	return
}

Remove-ClipFilesFromCutPs1 $working_dir $cut_recut_ps1_prefix $video_types_list -PermanentDelete

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list){
	Write-Host "open ps1 "
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list
}else{
	Write-Warning "Operation aborted."
	return 
}


# 运行剪切powershell脚本，
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${cut_recut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	Write-Host "run  $scriptFile "
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
    Write-Warning "No script file found with prefix '${cut_recut_ps1_prefix}' in directory '${working_dir}'."
}

$DebugPreference = "SilentlyContinue"
