####################
#������ǰ������Ƶ��������Ƶ���м���������ȡ��һ�������е���Ƶ��
####################

$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

####################{
#���������ļ������κδ���������
# ����Դ��Ƶ
. ./_deal_with_src_video.ps1
####################}

#��Դsrc�ı��ļ��ƶ�����ԴĿ¼��
# Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList
#���ƶ�ֱ������ɾ������ɾ��������վ���Ƴ� -PermanentDelete
Remove-ByTypeAndPrefix $working_dir $txtExtentionList $srcTxtPrefixList -PermanentDelete

#����ɾ��֮ǰ������powershell �ű��ļ���target�ı�
Remove-ByTypeAndPrefix $working_dir @($ps1Extention,$txtExtention) -PermanentDelete

# ���������Ƶ�ļ���
Remove-ByTypeAndPrefix $working_dir $video_types_list 


# Remove-ByTypeAndPrefix $working_dir $video_types_list -PermanentDelete

./xa_get_a_video_from_wait.ps1

$DebugPreference = "SilentlyContinue"
