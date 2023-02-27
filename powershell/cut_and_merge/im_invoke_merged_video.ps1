####################
#手动打开concat前缀的合并视频。
####################

$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1
#打开一个$concat_output_prefix= "concat_merge_"前缀的视频文件。
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $concat_output_prefix_list

$DebugPreference = "SilentlyContinue"
