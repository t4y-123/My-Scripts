
$DebugPreference = "Continue"


. ./lib_cut_merge_methods.ps1

Remove-ByTypeAndPrefix $auto_split_work_dir $auto_split_merge_remove_extention_list $auto_split_merge_remove_prefix_list 
Remove-ByTypeAndPrefix $auto_split_work_dir $video_types_list $auto_merge_excludePrefix_list 

# Auto-SplitVideo  $auto_split_work_dir $video_types_list -q

#Auto-MergeVideos $auto_split_work_dir $video_types_list Concat -ExcludePrefix $auto_merge_excludePrefix_list
Auto-MergeVideos $auto_split_work_dir $video_types_list Ts -ExcludePrefix $auto_merge_excludePrefix_list

$DebugPreference = "SilentlyContinue" 
