####################
#�ֶ���concatǰ׺�ĺϲ���Ƶ��
####################

$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1
#��һ��$concat_output_prefix= "concat_merge_"ǰ׺����Ƶ�ļ���
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $concat_output_prefix_list

$DebugPreference = "SilentlyContinue"
