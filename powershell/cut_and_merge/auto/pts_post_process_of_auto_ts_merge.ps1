####
#对ts合并后的合并文件进行处理，移动至最终目录，并处理文件件名前缀。
####


$DebugPreference = "Continue"

#注释下行用于调试。
$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


## 处理合并了的文件，仅将ts合并移动到一个合并结果目录中。


#将所有剪切powershell脚本移动至powershell目录
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $ps1ExtentionList -IncludePrefix $auto_ts_merge_ps1_prefix_list 
#合并文件需要目标文本文件，想保留脚本需要也一起移动。
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $txtExtentionList -IncludePrefix $auto_ts_tmp_target_txt_prefix_list 

#合并后的文件移动至最终目录，方便改名字。
Move-ByTypeAndPrefix $auto_merge_work_dir $end_auto_merge_dir $video_types_list -IncludePrefix $auto_ts_merge_output_prefix_list 

function Get-AutoTsMergeRename([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${auto_ts_merge_output_prefix})(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[2].Value)$($match.Groups[3].Value)"
    }
    else {
        return $fileName
    }
}

##重新命名合并后文件，只是删除合并前缀
Rename-ByTypeAndRegex { param($fileName) Get-AutoTsMergeRename $fileName } -SourceDirectory $end_auto_merge_dir -FileTypeList $video_types_list 

$DebugPreference = "SilentlyContinue"
