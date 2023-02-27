####################
#处理已合并的视频并获取下一个需要剪辑的视频。
####################


$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

./zm_end_merge_post_process.ps1
./xa_get_a_video_from_wait.ps1

$DebugPreference = "SilentlyContinue"
