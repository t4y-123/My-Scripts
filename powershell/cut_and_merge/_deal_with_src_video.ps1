####################
#����ű����ھ�����δ���Դ��Ƶ�ļ���ͨ������Ҫ�ֶ����ã������������ű����á�
####################

$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

####################{

# ��Դ��Ƶ����ԴĿ¼
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo MoveTo
# ѡ��ɾ����
#Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo RemoveToRecycleBin
# ������ɾ��
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo PermanentDelete

####################}

$DebugPreference = "SilentlyContinue"
