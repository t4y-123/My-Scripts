. ./lib_cut_merge_methods.ps1

$DebugPreference = "Continue"

# test:
Write-Host "wait_in_dir :$wait_in_dir"
Write-Host "working_dir :$working_dir"
Write-Host "videoSupportFormats :$videoSupportFormats"

Move-One-VideoFile -FromDir $wait_in_dir -ToDir $working_dir -VideoTypeList $videoSupportFormats -GenerateTxt $true
#Move-One-VideoFile -FromDir $working_dir -ToDir $wait_in_dir -VideoTypeList $videoSupportFormats
$DebugPreference = "SilentlyContinue" 