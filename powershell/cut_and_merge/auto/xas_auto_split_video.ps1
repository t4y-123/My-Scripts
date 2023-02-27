####
#对auto_split目录下的视频进行自动分割。
#需要注意的是，它会跳过所有文件名中带有-Scene-加数字标号的视频.
#如果想对这些视频进行分割，需要在分割之前先将它们重命名。
####


$DebugPreference = "Continue"


. ../lib_cut_merge_methods.ps1

Remove-ByTypeAndPrefix $auto_split_work_dir $auto_split_merge_remove_extention_list $auto_split_merge_remove_prefix_list 
Remove-ByTypeAndPrefix $auto_split_work_dir $video_types_list $auto_merge_excludePrefix_list 

Auto-SplitVideo $auto_split_work_dir $video_types_list -q

# #Auto-MergeVideos $auto_split_work_dir $video_types_list Concat -ExcludePrefix $auto_merge_excludePrefix_list
# Auto-MergeVideos $auto_split_work_dir $video_types_list Ts -ExcludePrefix $auto_merge_excludePrefix_list


# #随便打开一个视频
# Invoke-FileByType  -LiteralPath $auto_split_work_dir -IncludeExtensions $video_types_list

$DebugPreference = "SilentlyContinue" 
