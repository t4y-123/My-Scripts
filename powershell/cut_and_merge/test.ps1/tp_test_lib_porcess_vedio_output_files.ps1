
$DebugPreference = "Continue"


. ./lib_cut_merge_methods.ps1

#�Ӽ������Դ��ƵĿ¼ȡ��src*.txt�ļ�����Ƶ��
Move-ByTypeAndPrefix  $end_src_dir $working_dir $txtExtentionList
Move-ByTypeAndPrefix  $end_src_dir $working_dir $video_types_list

#�Ӽ������clip��ƵĿ¼ȡ��clip��Ƶ��
Move-ByTypeAndPrefix  $end_clip_dir $working_dir $video_types_list

#�Ӽ����ϲ����clip��ƵĿ¼ȡ��merge��Ƶ��
Move-ByTypeAndPrefix  $end_merge_dir $working_dir $video_types_list
Romove-BiggerClipCountBySrcTxt $working_dir $srcTextPrefix RemoveToRecycleBin

Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo MoveTo

Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_clip_dir CutClipVideo PermanentDelete


Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir TsMergeVideo MoveTo
Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_merge_dir ConcatMergeVideo MoveTo

Post-ProcessingBySrcTxt $working_dir $video_types_list $srcTextPrefix $end_src_dir OriginVideo MoveTo
 
Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_tmp_ts_prefix_list 

Move-ByTypeAndPrefix $working_dir $end_x_ps1_dir $ps1ExtentionList


Remove-ByTypeAndPrefix $working_dir $txtExtentionList @($concat_target_file_prefix,$ts_target_txt_prefix)

Move-ByTypeAndPrefix $working_dir $end_src_dir $txtExtentionList $srcTxtPrefixList
Move-ByTypeAndPrefix $working_dir $end_src_dir $video_types_list



$DebugPreference = "SilentlyContinue"
