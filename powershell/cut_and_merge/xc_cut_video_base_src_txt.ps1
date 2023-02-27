####################
#����src�ı��ļ����ɼ��нű�������Ƶ���м�����
####################

$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1


if ((Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList)){
	Write-Host "��ʼ����"
}else{
	Write-Error "�����ڻ���ڶ��src�ı��ļ�������Ŀ¼��$working_dir,��Ҫ����һ��src�ı��ļ������ܼ�����Ƶ"
	return 
}

#-o,�Զ����и���
if (!(Generate-CutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix -O))
{
	Write-Error "Generate-CutPowerShellFile fail."
	return
}

#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1Extention -IncludePrefix $cut_ps1_prefix_list

# Get-FilesInDirByType $working_dir $ps1ExtentionList

# if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list){
	# Write-Host "open ps1 "
	# Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list
# }else{
	# Write-Warning "Operation aborted."
	# return 
# }
if (!(Check-SingleFileInDirByType $working_dir  $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list)){
	Write-Error "�����ڻ���ڶ��cut_ps1_prefix_list�ı��ļ�������Ŀ¼��$working_dir"
	return 
}
# ���м���powershell�ű���
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${cut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}else {
    Write-Warning "û�ܻ�ȡ '${cut_ps1_prefix}' in directory '${working_dir}'."
}
# ɾ�������clip�ļ�
Romove-BiggerClipCountBySrcTxt $working_dir $srcTextPrefix RemoveToRecycleBin

#��һ��clipǰ׺����Ƶ�ļ���
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $videoClipPrefixList

$DebugPreference = "SilentlyContinue"
