####
#对auto_merge目录中的视频进行转换成ts格式再进行合并。正常来说，用不上。
####

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

. ../lib_cut_merge_methods.ps1

#先删除自动合并目录里的合并脚本、合并目标txt文件，防止干扰新的合并文件生成
Remove-ByTypeAndPrefix $auto_merge_work_dir $auto_split_merge_remove_extention_list $auto_split_merge_remove_prefix_list 

# 删除之前存在的已合视频文件。
#Remove-ByTypeAndPrefix $auto_merge_work_dir $video_types_list $auto_merge_excludePrefix_list 

# Auto-SplitVideo  $auto_merge_work_dir $video_types_list -q

#Auto-MergeVideos $auto_merge_work_dir $video_types_list Concat -ExcludePrefix $auto_merge_excludePrefix_list
Auto-MergeVideos $auto_merge_work_dir $video_types_list Ts -ExcludePrefix $auto_merge_excludePrefix_list


#随便打开一个concat合并的视频
Invoke-FileByType  -LiteralPath $auto_merge_work_dir -IncludeExtensions $video_types_list -IncludePrefix $auto_ts_merge_output_prefix_list

$DebugPreference = "SilentlyContinue" 
