####################
#�ڵ���������Ƶ�����󣬴��������Ƶ�ļ����������ļ�������ӦĿ¼������clipǰ׺��
####################

$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

#����srcԴ�ļ�������clip�����ļ���
#��clip�ļ��ƶ������ռ���Ŀ¼��������������
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo MoveTo

# ����볹��ɾ����ʹ��������һ�����
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo PermanentDelete

## ����ϲ��ļ������ ֻ�������Ƶʱ�ò�����
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir TsMergeVideo MoveTo
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir ConcatMergeVideo MoveTo

##����Դ��Ƶ
. ./_deal_with_src_video.ps1

# ���ts �ϲ��м��ļ���ֻ�������Ƶʱ�ò�����
# Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_tmp_ts_prefix_list 

#�����м���powershell�ű��ƶ���powershellĿ¼
Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $ps1ExtentionList 
#��ɾ������ȡ����һ�У��ƶ���ɾ����
#Remove-ByTypeAndPrefix $end_src_dir $ps1ExtentionList
#��ֱ��ɾ����
#Remove-ByTypeAndPrefix $working_dir $ps1ExtentionList

#����ɾ���ϲ��м��ļ���ֻ�������Ƶʱ�ò�����
# Remove-ByTypeAndPrefix $working_dir $txtExtentionList @($concat_target_file_prefix,$ts_target_txt_prefix) -PermanentDelete

#��󣬽�Դsrc�ı��ļ��ƶ�����ԴĿ¼��
Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list

#��ֱ������ɾ������ɾ��������վ���Ƴ� -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $txtExtentionList $srcTxtPrefixList -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $video_types_list -PermanentDelete

#�����ܵ���Ƶ©��֮��Ҳ�ƶ���ԴĿ¼��
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list 


##���������ϲ����ļ������ϲ�ǰ׺�ƶ�����
# Rename-ByTypeAndRegex { param($fileName) Get-ClipOutputRename $fileName } -SourceDirectory $end_clip_dir -FileTypeList $video_types_list 

##���������ϲ����ļ���ֻ��ɾ���ϲ�ǰ׺
Rename-ByTypeAndRegex { param($fileName) Remove-ClipOutputPrefix $fileName } -SourceDirectory $end_clip_dir -FileTypeList $video_types_list 

$DebugPreference = "SilentlyContinue"
