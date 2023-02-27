####################
#这个脚本用于决定如何处理源视频文件，通常不需要手动调用，而是由其他脚本调用。
####################

$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

####################{

# 将源视频最终源目录
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo MoveTo
# 选择删除。
#Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo RemoveToRecycleBin
# 或永久删除
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo PermanentDelete

####################}

$DebugPreference = "SilentlyContinue"
