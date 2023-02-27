####################
#手动打开打开 clip_ 前缀剪切片段视频。
####################

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1

#打开一个clip前缀的视频文件。
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $videoClipPrefixList

$DebugPreference = "SilentlyContinue"
