
$DebugPreference = "Continue"

. ./lib_cut_merge_methods.ps1


if (Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList){
	#Write-Host "open txt "
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
}else{
	Write-Warning "Operation aborted."
	return 
}

# Write-Host "`nvideo_types_list :$video_types_list"

if (!(Generate-CutPowerShellFile -WorkingDir $working_dir -VideoTypeList $video_types_list -TxtPrefix $srcTextPrefix -O))
{
	Write-Error "Generate-CutPowerShellFile fail."
	return
}

#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1Extention -IncludePrefix $cut_ps1_prefix_list
#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList 

# Get-FilesInDirByType $working_dir $ps1ExtentionList

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list){
	Write-Host "open ps1 "
	Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1ExtentionList  -IncludePrefix $cut_ps1_prefix_list
}else{
	Write-Warning "Operation aborted."
	return 
}


# ‘À––ºÙ«–powershellΩ≈±æ£¨
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${cut_ps1_prefix}*.ps1" | Select-Object -First 1

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
