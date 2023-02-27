####################
#为working目录下的所有视频文件生成一个src文本文件，用于剪辑。
####################

. ./lib_cut_merge_methods.ps1

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

$working_dir='.\working'
# test:

Create-VediosSrcTextInDir -LiteralPath $working_dir -VideoTypeList $video_types_list 

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