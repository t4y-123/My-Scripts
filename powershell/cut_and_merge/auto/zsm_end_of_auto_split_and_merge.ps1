####
#最终处理，清理源视频和合并视频，并删除所有分割的片段视频。
####


$DebugPreference = "Continue"

#注释下行用于调试。
#$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


# 处理分割前文件
$videoFiles = Get-NotSplitClipVideoFiles -Path $auto_split_work_dir -TypeList $video_types_list 
# 移动源文件至已完成源文件目录。
#Remove-ByTypeAndPrefix $auto_split_work_dir $video_types_list $auto_merge_excludePrefix_list 
foreach ($file in $videoFiles){
	Write-Debug "Move-Item -LiteralPath $file.FullName -Destination $end_auto_src_dir -Force"
	Move-Item -LiteralPath $file.FullName -Destination $end_auto_src_dir -Force
}


#删除剩余文件至回收站

$items = Get-ChildItem -LiteralPath $auto_split_work_dir #-Recurse  不需要Recurese, 因为会直接删除文件夹
foreach ($item in $items){
	Remove-Item-ToRecycleBin-LiteralPath $item.FullName 
}

# #彻底删除
# Get-ChildItem -LiteralPath $auto_split_work_dir -Recurse| Remove-Item -Recurse -Force

#合并后的文件移动至最终目录，方便改名字。
Move-ByTypeAndPrefix $auto_split_tmp_merge_dir $end_auto_merge_dir $video_types_list `
					-IncludePrefix $auto_concat_output_prefix_list  -Overwrite

##重新命名合并后文件，只是删除合并前缀
Rename-ByTypeAndRegex { param($fileName) Remove-AutoConcatMergePrefix $fileName } -SourceDirectory $end_auto_merge_dir -FileTypeList $video_types_list 

$DebugPreference = "SilentlyContinue"
