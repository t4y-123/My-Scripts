
. ./lib_cut_merge_methods.ps1



# test:
Write-Host "Test executed $($MyInvocation.MyCommand.Name)"
Write-Host "wait_in_dir :$wait_in_dir"
Write-Host "working_dir :$working_dir"
Write-Host "txtPrefixList :$txtPrefixList"
Write-Host "txtExtentionList :$txtExtentionList"
Write-Host "videoSupportFormats :$videoSupportFormats"



if (Check-SingleFileInDirByType $working_dir $txtExtentionList ){
	Write-Host "open txt "
	Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $txtExtentionList 
}else{
	Write-Warning "Operation aborted."
	return 
}

Write-Host "`n`nvideoSupportFormats :$videoSupportFormats"
Invoke-FileByType  -LiteralPath $working_dir -IncludeExtensions $videoSupportFormats 