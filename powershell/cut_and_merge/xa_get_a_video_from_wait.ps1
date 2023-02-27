####################
#获取下一个需要剪辑的视频。
####################

. ./lib_cut_merge_methods.ps1


$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

Write-Host "wait_in_dir :$wait_in_dir"
Write-Host "working_dir :$working_dir"
Write-Host "video_types_list :$video_types_list"

if(!(Check-SingleFileInDirByType $working_dir $video_types_list -NoMoreThan)){
	Write-Error "在目录[$working_dir]中已经存在视频文件，此脚本只适用于一次处理一个视频。"
	return $false
} 

#移动一个视频文件
if( !(Move-One-VideoFile -FromDir $wait_in_dir -ToDir $working_dir -VideoTypeList $video_types_list -GenerateTxt $true))
{
	Write-Host "在目录[$wait_in_dir]中已经不存在指定类型的视频文件。"
	return $false
}

#打开生成的src文本文件准备编辑剪辑时间
if (Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList){
	Write-Host "打开src文本方便输入剪切时间"
	Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
}else{
	Write-Error "不存在或存在多个src文本文件，请检查目录：$working_dir"
	return 
}

#打开视频准备编辑剪辑时间
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list 


$DebugPreference = "SilentlyContinue" 
