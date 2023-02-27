####
#在剪切合并视频结束后，处理相关视频文件。
#因为直接进行concat合并和ts合并的处理，如果未进行ts合并，则会有相关告警，无需理会。
####


$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

#根据src源文件来处理clip剪切文件：
#既然是合并剪切视频，那么clip文件可以永久删除，但是此行删除至回收站
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo RemoveToRecycleBin

# 永久删除需要改最后一行 RemoveToRecycleBin 为 PermanentDelete：
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo PermanentDelete

## 处理合并了的文件，concat合并和ts合并，都移动到一个合并结果目录中。
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir TsMergeVideo MoveTo
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir ConcatMergeVideo MoveTo

. ./_deal_with_src_video.ps1
# 将源视频最终源目录

#将源src文本文件移动至最源目录。
Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList 


#将所有剪切powershell脚本移动至powershell目录
Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $ps1ExtentionList -Overwrite
#合并文件需要目标文本文件，想保留脚本就也一起移动。
Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $txtExtentionList `
					-IncludePrefix @($concat_target_file_prefix,$ts_target_txt_prefix) -Overwrite
#但是有src文本文件在，多少次都可以重新生成剪辑脚本，所以我移动后选择全部删除至回收站。不想删除请注释掉下行
Remove-ByTypeAndPrefix $end_x_ps1_dir @($ps1Extention,$txtExtention)
#永久删除：
# Remove-ByTypeAndPrefix $end_x_ps1_dir @($ps1Extention,$txtExtention) -PermanentDelete

#或不移动直接永久删除。想删除至回收站请移除 -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $txtExtentionList $srcTxtPrefixList -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $video_types_list -PermanentDelete

# 清除ts合并中间文件，
Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_tmp_ts_prefix_list 

#将可能的视频漏网之鱼也移动最源目录。
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list


##重新命名合并后文件，将合并前缀移动至后部
# Rename-ByTypeAndRegex { param($fileName) Get-ConcatMergeRename $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 
# Rename-ByTypeAndRegex { param($fileName) Get-TsMergeOutputRename $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 

##重新命名合并后文件，只是删除合并前缀
Rename-ByTypeAndRegex { param($fileName) Remove-ConcatMergePrefix $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 
Rename-ByTypeAndRegex { param($fileName) Remove-TsMergePrefix $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 


$DebugPreference = "SilentlyContinue"
