####
#�ڼ��кϲ���Ƶ�����󣬴��������Ƶ�ļ���
#��Ϊֱ�ӽ���concat�ϲ���ts�ϲ��Ĵ������δ����ts�ϲ����������ظ澯��������ᡣ
####


$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ./lib_cut_merge_methods.ps1

#����srcԴ�ļ�������clip�����ļ���
#��Ȼ�Ǻϲ�������Ƶ����ôclip�ļ���������ɾ�������Ǵ���ɾ��������վ
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo RemoveToRecycleBin

# ����ɾ����Ҫ�����һ�� RemoveToRecycleBin Ϊ PermanentDelete��
# Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo PermanentDelete

## ����ϲ��˵��ļ���concat�ϲ���ts�ϲ������ƶ���һ���ϲ����Ŀ¼�С�
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir TsMergeVideo MoveTo
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir ConcatMergeVideo MoveTo

. ./_deal_with_src_video.ps1
# ��Դ��Ƶ����ԴĿ¼

#��Դsrc�ı��ļ��ƶ�����ԴĿ¼��
Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList 


#�����м���powershell�ű��ƶ���powershellĿ¼
Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $ps1ExtentionList -Overwrite
#�ϲ��ļ���ҪĿ���ı��ļ����뱣���ű���Ҳһ���ƶ���
Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $txtExtentionList `
					-IncludePrefix @($concat_target_file_prefix,$ts_target_txt_prefix) -Overwrite
#������src�ı��ļ��ڣ����ٴζ������������ɼ����ű����������ƶ���ѡ��ȫ��ɾ��������վ������ɾ����ע�͵�����
Remove-ByTypeAndPrefix $end_x_ps1_dir @($ps1Extention,$txtExtention)
#����ɾ����
# Remove-ByTypeAndPrefix $end_x_ps1_dir @($ps1Extention,$txtExtention) -PermanentDelete

#���ƶ�ֱ������ɾ������ɾ��������վ���Ƴ� -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $txtExtentionList $srcTxtPrefixList -PermanentDelete
# Remove-ByTypeAndPrefix $working_dir $video_types_list -PermanentDelete

# ���ts�ϲ��м��ļ���
Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_tmp_ts_prefix_list 

#�����ܵ���Ƶ©��֮��Ҳ�ƶ���ԴĿ¼��
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list


##���������ϲ����ļ������ϲ�ǰ׺�ƶ�����
# Rename-ByTypeAndRegex { param($fileName) Get-ConcatMergeRename $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 
# Rename-ByTypeAndRegex { param($fileName) Get-TsMergeOutputRename $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 

##���������ϲ����ļ���ֻ��ɾ���ϲ�ǰ׺
Rename-ByTypeAndRegex { param($fileName) Remove-ConcatMergePrefix $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 
Rename-ByTypeAndRegex { param($fileName) Remove-TsMergePrefix $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 


$DebugPreference = "SilentlyContinue"
