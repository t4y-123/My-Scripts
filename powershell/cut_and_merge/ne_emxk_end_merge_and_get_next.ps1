####################
#�����Ѻϲ�����Ƶ����ȡ��һ����Ҫ��������Ƶ��
####################


$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

./zm_end_merge_post_process.ps1
./xa_get_a_video_from_wait.ps1

$DebugPreference = "SilentlyContinue"
