
$DebugPreference = "Continue"

. ./lib_cut_merge_methods.ps1


if(!(Remove-ByTypeAndPrefix $working_dir $video_types_list $concat_output_prefix_list))
{	
	Write-Warning "[ Remove-ByTypeAndPrefix $WorkingDir $video_types_list $concat_output_prefix_list ] fail."
	return
}

. ./tr_test_lib_geneate_re_cut_cmd.ps1

if (Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList){
	#Write-Host "open txt "
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
}else{
	Write-Warning "Operation aborted."
	return 
}

$srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
if (!$srcTxtFile) {
	Write-Warning "No source text file found with prefix '${srcTextPrefix}' in directory '${working_dir}'."
	return
}


 if (!(Generate-ConcatMergePowerShellFile $working_dir $video_types_list $srcTextPrefix -O))
 {
	return
 }
 

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $concat_merge_ps1_prefix_list){
	Write-Host "open ps1 "
	Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1Extention -IncludePrefix $concat_merge_ps1_prefix_list
}else{
	Write-Warning "Operation aborted."
	return 
}


# ‘À––ºÙ«–powershellΩ≈±æ£¨
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${concat_merge_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
    Write-Warning "No script file found with prefix '${cut_ps1_prefix}' in directory '${working_dir}'."
}

$DebugPreference = "SilentlyContinue"
