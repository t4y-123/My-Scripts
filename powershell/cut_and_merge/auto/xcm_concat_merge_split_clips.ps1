####
#删除不需要的片段后，对自动分割的视频进行合并。
####


$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

. ../lib_cut_merge_methods.ps1

#先删除自动合并目录里的合并脚本、合并目标txt文件，防止干扰新的合并文件生成
Remove-ByTypeAndPrefix $auto_split_work_dir $auto_split_merge_remove_extention_list $auto_split_merge_remove_prefix_list 

Auto-MergeSplitVideos  $auto_split_work_dir $video_types_list Concat -ExcludePrefix $auto_merge_excludePrefix_list
#Auto-MergeVideos $auto_split_work_dir $video_types_list Ts -ExcludePrefix $auto_merge_excludePrefix_list

#合并后的文件移动至tmp目录，方便查看。
Move-ByTypeAndPrefix $auto_split_work_dir $auto_split_tmp_merge_dir $video_types_list `
					-IncludePrefix $auto_concat_output_prefix_list -Overwrite

#随便打开一个concat合并的视频
Invoke-FileByType  -LiteralPath $auto_split_tmp_merge_dir -IncludeExtensions $video_types_list -IncludePrefix $auto_concat_output_prefix_list


$DebugPreference = "SilentlyContinue" 
