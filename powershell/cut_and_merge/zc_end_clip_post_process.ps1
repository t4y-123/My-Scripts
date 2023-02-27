####################
#在单纯剪切视频结束后，处理相关视频文件，将剪切文件移至对应目录并处理clip前缀。
####################

$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

#根据src源文件来处理clip剪切文件：
#将clip文件移动至最终剪切目录，并进行重命名
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo MoveTo

# 如果想彻底删除请使用下面这一行命令：
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo PermanentDelete

## 处理合并文件的命令， 只想剪切视频时用不到。
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir TsMergeVideo MoveTo
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir ConcatMergeVideo MoveTo

##处理源视频
. ./_deal_with_src_video.ps1

# 清除ts 合并中间文件，只想剪切视频时用不到。
# Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_tmp_ts_prefix_list 

#将所有剪切powershell脚本移动至powershell目录
Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $ps1ExtentionList 
#想删除就再取消下一行，移动后删除。
#Remove-ByTypeAndPrefix $end_src_dir $ps1ExtentionList
#或直接删除。
#Remove-ByTypeAndPrefix $working_dir $ps1ExtentionList

#永久删除合并中间文件，只想剪切视频时用不到。
# Remove-ByTypeAndPrefix $working_dir $txtExtentionList @($concat_target_file_prefix,$ts_target_txt_prefix) -PermanentDelete

#最后，将源src文本文件移动至最源目录。
Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list

#或直接永久删除。想删除至回收站请移除 -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $txtExtentionList $srcTxtPrefixList -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $video_types_list -PermanentDelete

#将可能的视频漏网之鱼也移动最源目录。
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list 


##重新命名合并后文件，将合并前缀移动至后部
# Rename-ByTypeAndRegex { param($fileName) Get-ClipOutputRename $fileName } -SourceDirectory $end_clip_dir -FileTypeList $video_types_list 

##重新命名合并后文件，只是删除合并前缀
Rename-ByTypeAndRegex { param($fileName) Remove-ClipOutputPrefix $fileName } -SourceDirectory $end_clip_dir -FileTypeList $video_types_list 

$DebugPreference = "SilentlyContinue"
