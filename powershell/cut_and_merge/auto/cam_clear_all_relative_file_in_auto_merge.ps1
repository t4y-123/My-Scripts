####
#����ɾ��auto_mergeĿ¼�е������ļ���
####


$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


## ����ϲ��˵��ļ���

#��powershell�ű�ɾ��
Remove-ByTypeAndPrefix $auto_merge_work_dir $ps1ExtentionList -IncludePrefix $auto_concat_merge_ps1_prefix_list 
#ɾ���ϲ��ļ�Ŀ���ı��ļ�
Remove-ByTypeAndPrefix $auto_merge_work_dir $txtExtentionList -IncludePrefix $auto_concat_target_file_prefix_list 



Remove-ByTypeAndPrefix $auto_merge_work_dir $ps1ExtentionList -IncludePrefix $auto_ts_merge_ps1_prefix_list 
#ɾ��ts�ϲ��ļ�Ŀ���ı��ļ�
Remove-ByTypeAndPrefix $auto_merge_work_dir $txtExtentionList -IncludePrefix $auto_ts_merge_output_prefix_list 

#������Ƶ�ļ�ɾ��
Remove-ByTypeAndPrefix $auto_merge_work_dir $video_types_list 

$DebugPreference = "SilentlyContinue"
