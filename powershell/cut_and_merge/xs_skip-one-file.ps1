####################
#跳过当前剪辑视频，不对视频进行剪辑，并获取下一个待剪切的视频。
####################

$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

####################{
#不想对这个文件进行任何处理的情况：
# 处理源视频
. ./_deal_with_src_video.ps1
####################}

#将源src文本文件移动至最源目录。
# Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList
#或不移动直接永久删除。想删除至回收站请移除 -PermanentDelete
Remove-ByTypeAndPrefix $working_dir $txtExtentionList $srcTxtPrefixList -PermanentDelete

#永久删除之前残留的powershell 脚本文件和target文本
Remove-ByTypeAndPrefix $working_dir @($ps1Extention,$txtExtention) -PermanentDelete

# 清除残留视频文件。
Remove-ByTypeAndPrefix $working_dir $video_types_list 


# Remove-ByTypeAndPrefix $working_dir $video_types_list -PermanentDelete

./xa_get_a_video_from_wait.ps1

$DebugPreference = "SilentlyContinue"
