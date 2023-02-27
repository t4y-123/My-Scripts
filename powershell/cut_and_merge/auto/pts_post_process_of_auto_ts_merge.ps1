####
#��ts�ϲ���ĺϲ��ļ����д����ƶ�������Ŀ¼���������ļ�����ǰ׺��
####


$DebugPreference = "Continue"

#ע���������ڵ��ԡ�
$DebugPreference = "SilentlyContinue"

. ../lib_cut_merge_methods.ps1


## ����ϲ��˵��ļ�������ts�ϲ��ƶ���һ���ϲ����Ŀ¼�С�


#�����м���powershell�ű��ƶ���powershellĿ¼
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $ps1ExtentionList -IncludePrefix $auto_ts_merge_ps1_prefix_list 
#�ϲ��ļ���ҪĿ���ı��ļ����뱣���ű���ҪҲһ���ƶ���
Move-ByTypeAndPrefix $auto_merge_work_dir $end_x_ps1_dir $txtExtentionList -IncludePrefix $auto_ts_tmp_target_txt_prefix_list 

#�ϲ�����ļ��ƶ�������Ŀ¼����������֡�
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

##���������ϲ����ļ���ֻ��ɾ���ϲ�ǰ׺
Rename-ByTypeAndRegex { param($fileName) Get-AutoTsMergeRename $fileName } -SourceDirectory $end_auto_merge_dir -FileTypeList $video_types_list 

$DebugPreference = "SilentlyContinue"
