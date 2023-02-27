####
#对合并后的合并文件进行处理，移动至最终目录，并处理文件件名前缀。。
####


$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


## 处理合并了的文件，仅将concat合并移动到一个合并结果目录中。
##############################################


# -Overwrite 强制覆盖
#将所有剪切powershell脚本移动至powershell目录
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $ps1ExtentionList `
					-IncludePrefix $auto_concat_merge_ps1_prefix_list  -Overwrite
#合并文件需要目标文本文件，想保留脚本需要也一起移动。
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $txtExtentionList `
					-IncludePrefix $auto_concat_target_file_prefix_list  -Overwrite

#合并后的文件移动至最终产出目录，方便改名字。
Move-ByTypeAndPrefix $auto_merge_work_dir $end_auto_merge_dir $video_types_list `
					-IncludePrefix $auto_concat_output_prefix_list  -Overwrite

##重新命名合并后文件，只是删除合并前缀
Rename-ByTypeAndRegex { param($fileName) Remove-AutoConcatMergePrefix $fileName } `
					-SourceDirectory $end_auto_merge_dir `
					-FileTypeList $video_types_list 


$DebugPreference = "SilentlyContinue"
