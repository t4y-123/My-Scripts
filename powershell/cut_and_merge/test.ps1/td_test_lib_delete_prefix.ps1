
$DebugPreference = "Continue"

. ./lib_cut_merge_methods.ps1



Remove-ByTypeAndPrefix  $working_dir $video_types_list $videoClipPrefixList

Generate-CutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix
# 运行剪切powershell脚本，
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${cut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
    Write-Warning "No script file found with prefix '${cut_ps1_prefix}' in directory '${working_dir}'."
}

Remove-ByTypeAndPrefix  $working_dir $video_types_list $videoClipPrefixList -PermanentDelete

$DebugPreference = "SilentlyContinue"
