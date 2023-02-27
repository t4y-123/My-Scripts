####
#清理删除auto_merge目录中的所有文件。
####


$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


## 处理合并了的文件，

#将powershell脚本删除
Remove-ByTypeAndPrefix $auto_merge_work_dir $ps1ExtentionList -IncludePrefix $auto_concat_merge_ps1_prefix_list 
#删除合并文件目标文本文件
Remove-ByTypeAndPrefix $auto_merge_work_dir $txtExtentionList -IncludePrefix $auto_concat_target_file_prefix_list 



Remove-ByTypeAndPrefix $auto_merge_work_dir $ps1ExtentionList -IncludePrefix $auto_ts_merge_ps1_prefix_list 
#删除ts合并文件目标文本文件
Remove-ByTypeAndPrefix $auto_merge_work_dir $txtExtentionList -IncludePrefix $auto_ts_merge_output_prefix_list 

#所有视频文件删除
Remove-ByTypeAndPrefix $auto_merge_work_dir $video_types_list 

$DebugPreference = "SilentlyContinue"
