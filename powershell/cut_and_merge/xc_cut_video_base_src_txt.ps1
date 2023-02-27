####################
#根据src文本文件生成剪切脚本，对视频进行剪辑。
####################

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1


if ((Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList)){
	Write-Host "开始剪切"
}else{
	Write-Error "不存在或存在多个src文本文件，请检查目录：$working_dir,需要生成一个src文本文件来才能剪切视频"
	return 
}

#-o,自动进行覆盖
if (!(Generate-CutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix -O))
{
	Write-Error "Generate-CutPowerShellFile fail."
	return
}

#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1Extention -IncludePrefix $cut_ps1_prefix_list

# Get-FilesInDirByType $working_dir $ps1ExtentionList

# if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list){
	# Write-Host "open ps1 "
	# Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list
# }else{
	# Write-Warning "Operation aborted."
	# return 
# }
if (!(Check-SingleFileInDirByType $working_dir  $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list)){
	Write-Error "不存在或存在多个cut_ps1_prefix_list文本文件，请检查目录：$working_dir"
	return 
}
# 运行剪切powershell脚本，
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${cut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}else {
    Write-Warning "没能获取 '${cut_ps1_prefix}' in directory '${working_dir}'."
}
# 删除多余的clip文件
Romove-BiggerClipCountBySrcTxt $working_dir $srcTextPrefix RemoveToRecycleBin

#打开一个clip前缀的视频文件。
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $videoClipPrefixList

$DebugPreference = "SilentlyContinue"
