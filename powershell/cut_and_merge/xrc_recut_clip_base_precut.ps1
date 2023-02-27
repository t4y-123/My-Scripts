####################
#����Ҫ���¼���ĳЩƬ��ʱ��ʹ������ű���
#������ֻ���¼�����Ҫ���еĲ���clip������clip�����С�����¼��е���Ƶ����ʼ������֤��
####################

$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
#$DebugPreference = "SilentlyContinue" 

. ./lib_cut_merge_methods.ps1

if ((Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList)){
	Write-Host "��ʼ����"
}else{
	Write-Error "�����ڻ���ڶ��src�ı��ļ�������Ŀ¼��$working_dir,��Ҫ����һ��src�ı��ļ������ܼ�����Ƶ"
	return 
}


$srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
if (!$srcTxtFile) {
	Write-Error "δ����Ŀ¼${working_dir}�ҵ�'${srcTextPrefix}'�ı��ļ�.���˳�"
	return
}

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list){
	Write-Host "��ǰһ�μ��л������������ɼ����ļ�"
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list
}else{
	Write-Error "δ����Ŀ¼${working_dir}�ҵ�'${cut_ps1_prefix_list}'�����ļ�.���˳�"
}

#-o,�Զ����и���
if ( !(Generate-ReCutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix -o))
{
	Write-Error "���¼��г��ִ���"
	return
}

#����ɾ������ļ����ļ�
#Remove-ClipFilesFromCutPs1 $working_dir $cut_ps1_prefix $video_types_list -PermanentDelete

#ɾ��������վ
Remove-ClipFilesFromCutPs1 $working_dir $cut_recut_ps1_prefix $video_types_list 

# ɾ�������clip�ļ�
Romove-BiggerClipCountBySrcTxt $working_dir $srcTextPrefix RemoveToRecycleBin

# �������¼��е�powershell�ű���
$reCutScriptFile = Get-ChildItem -LiteralPath $working_dir -Filter "${cut_recut_ps1_prefix}*.ps1" | Select-Object -First 1

if ($reCutScriptFile -ne $null) {
    # & $reCutScriptFile.FullName
	Write-Host "run  $reCutScriptFile "
	cd $working_dir
	. $reCutScriptFile.FullName
	cd ..
	
	$recutContent = Get-Content -LiteralPath $reCutScriptFile.FullName
	if($recutContent -ne $null){
		#�ӵ�һ�����¼��е��ļ�����clip��Ƶ
		$firstClipFileName = Get-FirstClipFileName $reCutScriptFile.FullName
		if ($firstClipFileName) {
			Write-Host "��һ�����¼��е���ƵΪ��$firstClipFileName"
			$firstRecutFilePath = Join-Path $reCutScriptFile.Directory.FullName $firstClipFileName
			Write-Debug "$firstRecutFilePath = Join-Path $($reCutScriptFile.Directory.FullName) $firstClipFileName"
			Invoke-Item -LiteralPath $firstRecutFilePath
		} else {
			Write-Warning "û���� $reCutScriptFile ��ƥ�䵽���¼��е��ļ�����������һ��clip�ļ���"
			return
		}
	}else{
		#һ����ԣ����ܻ��в������ĳЩƬ�������������Ҫ���и��࣬������Ҫɾ��һЩ��
		Write-Warning "û�����¼��е��ļ�����������һ��clip�ļ���"
		#��һ��clipǰ׺����Ƶ�ļ���
		Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $video_types_list  -IncludePrefix $videoClipPrefixList
	}

}
else {
    Write-Error "δ����Ŀ¼'${working_dir}'�����ؼ��нű�'${cut_recut_ps1_prefix}',���˹����."
	return
}

$DebugPreference = "SilentlyContinue"
