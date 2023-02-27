
$DebugPreference = "Continue"

 . ./lib_cut_merge_methods.ps1


# if(!(Remove-ByTypeAndPrefix $working_dir $video_types_list $ts_remove_prefix_list -PermanentDelete))
# {	
	# Write-Warning "[ Remove-ByTypeAndPrefix $WorkingDir $video_types_list $concat_output_prefix_list ] fail."
	# return
# }

# . ./tr_test_lib_geneate_re_cut_cmd.ps1

# if (Check-SingleFileInDirByType $working_dir $txtExtentionList $srcTxtPrefixList){
	# #Write-Host "open txt "
	# #Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
# }else{
	# Write-Error "Src file not exist or more than one Operation aborted."
	# return 
# }

# $srcTxtFile = Get-SourceTextFile $working_dir $srcTextPrefix
# if (!$srcTxtFile) {
	# Write-Warning "No source text file found with prefix '${srcTextPrefix}' in directory '${working_dir}'."
	# return
# }


 if (!(Generate-TsMergePowerShellFile $working_dir $video_types_list $srcTextPrefix -O))
 {
	return
 }
 

if (Check-SingleFileInDirByType $working_dir $ps1ExtentionList  -IncludePrefix $ts_merge_ps1_prefix){
	Write-Host "open ps1 "
	#Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $ps1Extention -IncludePrefix $ts_merge_ps1_prefix
}else{
	Write-Warning "Operation aborted."
	return 
}


# 运行对应powershell脚本，
$scriptFile = Get-ChildItem -Path $working_dir -Filter "${ts_merge_ps1_prefix}*.ps1" | Select-Object -First 1

if ($scriptFile -ne $null) {
    # & $scriptFile.FullName
	cd $working_dir
	. $scriptFile.FullName
	cd ..
}
else {
    Write-Warning "No script file found with prefix '${ts_merge_ps1_prefix}' in directory '${working_dir}'."
}

$DebugPreference = "SilentlyContinue"
