####################
#手动打开打开ts_merge前缀的合并视频。
####################

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1


$src_exclude_prefix_list =
#打开一个clip前缀的视频文件。
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -ExcludePrefix $src_exclude_prefix_list

$DebugPreference = "SilentlyContinue"
