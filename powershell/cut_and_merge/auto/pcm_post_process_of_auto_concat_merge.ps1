####
#�Ժϲ���ĺϲ��ļ����д����ƶ�������Ŀ¼���������ļ�����ǰ׺����
####


$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


## ����ϲ��˵��ļ�������concat�ϲ��ƶ���һ���ϲ����Ŀ¼�С�
##############################################


# -Overwrite ǿ�Ƹ���
#�����м���powershell�ű��ƶ���powershellĿ¼
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $ps1ExtentionList `
					-IncludePrefix $auto_concat_merge_ps1_prefix_list  -Overwrite
#�ϲ��ļ���ҪĿ���ı��ļ����뱣���ű���ҪҲһ���ƶ���
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $txtExtentionList `
					-IncludePrefix $auto_concat_target_file_prefix_list  -Overwrite

#�ϲ�����ļ��ƶ������ղ���Ŀ¼����������֡�
Move-ByTypeAndPrefix $auto_merge_work_dir $end_auto_merge_dir $video_types_list `
					-IncludePrefix $auto_concat_output_prefix_list  -Overwrite

##���������ϲ����ļ���ֻ��ɾ���ϲ�ǰ׺
Rename-ByTypeAndRegex { param($fileName) Remove-AutoConcatMergePrefix $fileName } `
					-SourceDirectory $end_auto_merge_dir `
					-FileTypeList $video_types_list 


$DebugPreference = "SilentlyContinue"
