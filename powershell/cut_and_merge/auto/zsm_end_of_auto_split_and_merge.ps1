####
#���մ�������Դ��Ƶ�ͺϲ���Ƶ����ɾ�����зָ��Ƭ����Ƶ��
####


$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
#$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


# ����ָ�ǰ�ļ�
$videoFiles = Get-NotSplitClipVideoFiles -Path $auto_split_work_dir -TypeList $video_types_list 
# �ƶ�Դ�ļ��������Դ�ļ�Ŀ¼��
#Remove-ByTypeAndPrefix $auto_split_work_dir $video_types_list $auto_merge_excludePrefix_list 
foreach ($file in $videoFiles){
	Write-Debug "Move-Item -LiteralPath $file.FullName -Destination $end_auto_src_dir -Force"
	Move-Item -LiteralPath $file.FullName -Destination $end_auto_src_dir -Force
}


#ɾ��ʣ���ļ�������վ

$items = Get-ChildItem -LiteralPath $auto_split_work_dir #-Recurse  ����ҪRecurese, ��Ϊ��ֱ��ɾ���ļ���
foreach ($item in $items){
	Remove-Item-ToRecycleBin-LiteralPath $item.FullName 
}

# #����ɾ��
# Get-ChildItem -LiteralPath $auto_split_work_dir -Recurse| Remove-Item -Recurse -Force

#�ϲ�����ļ��ƶ�������Ŀ¼����������֡�
Move-ByTypeAndPrefix $auto_split_tmp_merge_dir $end_auto_merge_dir $video_types_list `
					-IncludePrefix $auto_concat_output_prefix_list  -Overwrite

##���������ϲ����ļ���ֻ��ɾ���ϲ�ǰ׺
Rename-ByTypeAndRegex { param($fileName) Remove-AutoConcatMergePrefix $fileName } -SourceDirectory $end_auto_merge_dir -FileTypeList $video_types_list 

$DebugPreference = "SilentlyContinue"
