
$DebugPreference = "Continue"


. ./lib_cut_merge_methods.ps1


function ReSet-ClipOutputRename([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^.*)(_)(clip_\d{3})(\.+[a-zA-Z0-9]+)$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[2].Value)$($match.Groups[1].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}


#Rename-ByTypeAndRegex  { param($fileName) ReSet-ClipOutputRename $fileName }-SourceDirectory $end_clip_dir -FileTypeList $video_types_list 
Rename-ByTypeAndRegex { param($fileName) Get-ClipOutputRename $fileName } -SourceDirectory $end_clip_dir -FileTypeList $video_types_list 
																		  
Rename-ByTypeAndRegex { param($fileName) Get-ConcatMergeRename $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 

Rename-ByTypeAndRegex { param($fileName) Get-TsMergeOutputRename $fileName } -SourceDirectory $end_merge_dir -FileTypeList $video_types_list 


$DebugPreference = "SilentlyContinue" 
