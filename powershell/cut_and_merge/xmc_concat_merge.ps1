####################
#����src�ı��ļ���clip��Ƶ����ֱ�Ӻϲ���
####################

$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1




##����ɾ��֮ǰȫ���ϳ��ļ�������վ
# ��Ҫ����ɾ����ʹ�ã�   Remove-ByTypeAndPrefix $working_dir $video_types_list $concat_output_prefix_list -PermanentDelete
if(!(Remove-ByTypeAndPrefix $working_dir $video_types_list $concat_output_prefix_list))
{	
	Write-Error "[ Remove-ByTypeAndPrefix $WorkingDir $video_types_list $concat_output_prefix_list ] fail."
	return
}

if ((Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList)){
	Write-Host "��ʼ�ϲ�����"
}else{
	Write-Error "�����ڻ���ڶ��src�ı��ļ�������Ŀ¼��$working_dir,��Ҫ����һ��src�ı��ļ������ܼ��кϲ���Ƶ"
	return 
}

$srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
if (!$srcTxtFile) {
	Write-Error "δ����Ŀ¼${working_dir}�ҵ�'${srcTextPrefix}'�ı��ļ�.���˳�"
	return
}


#-O �Զ�����ԭȫ��powershell �ű�
 if (!(Generate-ConcatMergePowerShellFile $working_dir $video_types_list $srcTextPrefix -O))
 {
	Write-Error "���ɺϲ��ű����ִ������˹����Ŀ¼ $working_dir"
	return
 }
 
 # ���м���powershell�ű���
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${concat_merge_ps1_prefix}*.ps1" | Select-Object -First 1

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $concat_merge_ps1_prefix_list){
	Write-Host "��ʼִ�кϲ��ű� $scriptFile "
}else{
	Write-Error "�����ڻ���ڶ��$concat_merge_ps1_prefix_list�ϲ��ű�������Ŀ¼��$working_dir,��ֻ֤��һ����"
	return 
}

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
     Write-Error "δ����Ŀ¼'${working_dir}'�ҵ��ű�'${concat_merge_ps1_prefix_list}',���˹����."
}

#��һ��$concat_output_prefix= "concat_merge_"ǰ׺����Ƶ�ļ���
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $concat_output_prefix_list

$DebugPreference = "SilentlyContinue"
