####################
#��ȡ��һ����Ҫ��������Ƶ��
####################

. ./lib_cut_merge_methods.ps1


$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

Write-Host "wait_in_dir :$wait_in_dir"
Write-Host "working_dir :$working_dir"
Write-Host "video_types_list :$video_types_list"

if(!(Check-SingleFileInDirByType $working_dir $video_types_list -NoMoreThan)){
	Write-Error "��Ŀ¼[$working_dir]���Ѿ�������Ƶ�ļ����˽ű�ֻ������һ�δ���һ����Ƶ��"
	return $false
} 

#�ƶ�һ����Ƶ�ļ�
if( !(Move-One-VideoFile -FromDir $wait_in_dir -ToDir $working_dir -VideoTypeList $video_types_list -GenerateTxt $true))
{
	Write-Host "��Ŀ¼[$wait_in_dir]���Ѿ�������ָ�����͵���Ƶ�ļ���"
	return $false
}

#�����ɵ�src�ı��ļ�׼���༭����ʱ��
if (Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList){
	Write-Host "��src�ı������������ʱ��"
	Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
}else{
	Write-Error "�����ڻ���ڶ��src�ı��ļ�������Ŀ¼��$working_dir"
	return 
}

#����Ƶ׼���༭����ʱ��
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list 


$DebugPreference = "SilentlyContinue" 
