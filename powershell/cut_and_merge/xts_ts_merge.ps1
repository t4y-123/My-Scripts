####################
#将视频转成ts视频后再剪辑。虽然可能有一些特殊情况需要使用，但一般用不上。
####################

$DebugPreference = "Continue"

#注释下行用于调试。
#$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1


##首先删除之前全部合成文件到回收站
# 需要彻底删除请使用：   Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_merge_output_prefix_list -PermanentDelete
if(!(Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_merge_output_prefix_list))
{	
	Write-Error "[ Remove-ByTypeAndPrefix $WorkingDir $video_types_list $ts_merge_output_prefix_list ] fail."
	return
}

if ((Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList)){
	Write-Host "开始合并剪切"
}else{
	Write-Error "不存在或存在多个src文本文件，请检查目录：$working_dir,需要生成一个src文本文件来才能剪切合并视频"
	return 
}

$srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
if (!$srcTxtFile) {
	Write-Error "未能在目录${working_dir}找到'${srcTextPrefix}'文本文件.，退出"
	return
}


#-O 自动覆盖原全并powershell 脚本
 if (!(Generate-TsMergePowerShellFile $working_dir $video_types_list $srcTextPrefix -O))
 {
	Write-Error "生成合并脚本出现错误。请人工检查目录 $working_dir"
	return
 }
 
 # 运行剪切powershell脚本，
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${ts_merge_ps1_prefix}*.ps1" | Select-Object -First 1

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $ts_merge_ps1_prefix_list){
	Write-Host "开始执行合并脚本 $scriptFile "
}else{
	Write-Error "不存在或存在多个$ts_merge_ps1_prefix_list合并脚本，请检查目录：$working_dir,保证只有一个。"
	return 
}

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
     Write-Error "未能在目录'${working_dir}'找到脚本'${ts_merge_ps1_prefix_list}',请人工检查."
}

Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $ts_merge_output_prefix_list

$DebugPreference = "SilentlyContinue"
