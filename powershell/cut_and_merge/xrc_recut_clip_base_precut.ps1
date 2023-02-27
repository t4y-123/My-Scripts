####################
#当需要重新剪切某些片段时，使用这个脚本。
#它可以只重新剪切需要剪切的部分clip，并从clip标号最小的重新剪切的视频处开始播放验证。
####################

$DebugPreference = "Continue"

#注释下行用于调试。
#$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1

if ((Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList)){
	Write-Host "开始剪切"
}else{
	Write-Error "不存在或存在多个src文本文件，请检查目录：$working_dir,需要生成一个src文本文件来才能剪切视频"
	return 
}


$srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
if (!$srcTxtFile) {
	Write-Error "未能在目录${working_dir}找到'${srcTextPrefix}'文本文件.，退出"
	return
}

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list){
	Write-Host "在前一次剪切基础上重新生成剪切文件"
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list
}else{
	Write-Error "未能在目录${working_dir}找到'${cut_ps1_prefix_list}'剪切文件.，退出"
}

#-o,自动进行覆盖
if ( !(Generate-ReCutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix -o))
{
	Write-Error "重新剪切出现错误"
	return
}

#永久删除多余的剪切文件
#Remove-ClipFilesFromCutPs1 $working_dir $cut_ps1_prefix $video_types_list -PermanentDelete

#删除至回收站
Remove-ClipFilesFromCutPs1 $working_dir $cut_recut_ps1_prefix $video_types_list 

# 删除多余的clip文件
Romove-BiggerClipCountBySrcTxt $working_dir $srcTextPrefix RemoveToRecycleBin

# 运行重新剪切的powershell脚本，
$reCutScriptFile = Get-ChildItem -LiteralPath $working_dir -Filter "${cut_recut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($reCutScriptFile -ne $null) {
    # & $reCutScriptFile.FullName
	Write-Host "run  $reCutScriptFile "
	cd $working_dir
	. $reCutScriptFile.FullName
	cd ..
	
	$recutContent = Get-Content -LiteralPath $reCutScriptFile.FullName
	if($recutContent -ne $null){
		#从第一个重新剪切的文件处打开clip视频
		$firstClipFileName = Get-FirstClipFileName $reCutScriptFile.FullName
		if ($firstClipFileName) {
			Write-Host "第一个重新剪切的视频为：$firstClipFileName"
			$firstRecutFilePath = Join-Path $reCutScriptFile.Directory.FullName $firstClipFileName
			Write-Debug "$firstRecutFilePath = Join-Path $($reCutScriptFile.Directory.FullName) $firstClipFileName"
			Invoke-Item -LiteralPath $firstRecutFilePath
		} else {
			Write-Warning "没能在 $reCutScriptFile 中匹配到重新剪切的文件。尝试随便打开一个clip文件。"
			return
		}
	}else{
		#一般而言，可能会有不想剪切某些片段了情况，不需要剪切更多，但是需要删除一些。
		Write-Warning "没有重新剪切的文件。尝试随便打开一个clip文件。"
		#打开一个clip前缀的视频文件。
		Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $videoClipPrefixList
	}

}
else {
    Write-Error "未能在目录'${working_dir}'生成重剪切脚本'${cut_recut_ps1_prefix}',请人工检查."
	return
}

$DebugPreference = "SilentlyContinue"
