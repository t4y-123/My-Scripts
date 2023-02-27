####
#帮助你批量重命名文件。
#你可以自定义重命名规则，比如使用正则表达式将文件名中的数字加上前导0，也可以对文件名中的空格进行处理。
###

$DebugPreference = "Continue"

#注释下行用于调试。
#$DebugPreference = "SilentlyContinue"


#一个用来重命名的脚本

#总是需要获取指定类型文件
#更易读的输出方式 Output the files with their full path, size in MB, and size in GB
function Format-VedioFileInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.IO.FileInfo[]]$VideoFiles 
    )
    $VideoFiles | Select-Object FullName, @{Name="Size (MB)";  Expression={"{0:N2}" -f ($_.Length / 1MB)}} , @{Name="Size (GB)";  Expression={"{0:N2}" -f ($_.Length / 1GB)}} | Format-Table -AutoSize
}

function Get-FilesInDir {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$LiteralPath,
        [Parameter()]
        [string[]]$TypeList,
		[string[]]$ExcludeTypeList,
        [Parameter()]
        [string[]]$IncludePrefix,
        [Parameter()]
        [string[]]$ExcludePrefix,
        [Parameter()]
        [switch]$NotRecurse,
		[Parameter()]
        [switch]$OnlyFile,
		[Parameter()]
        [switch]$OnlyDir
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
    # Check if directory exists
    if (-not (Test-Path -LiteralPath $LiteralPath -PathType Container)) {
        Write-Warning "Directory '$LiteralPath' does not exist. Exiting."
        return $null
    }
	
    if (-not $TypeList) {
		if ($NotRecurse) {
			$files = Get-ChildItem -LiteralPath $LiteralPath -File:$OnlyFile -Directory:$OnlyDir | 
				Sort-Object -Property FullName
		} else {
			$files = Get-ChildItem -LiteralPath $LiteralPath -Recurse -File:$OnlyFile -Directory:$OnlyDir |
				Sort-Object -Property FullName
		}
    } else {
		# Get all video files in the "From" directory and its subdirectories, sorted by FullName
		# $videoFiles = Get-ChildItem $FromDir -Recurse -File |
			# Where-Object { $VideoTypeList -contains $_.Extension.ToLower() } |
			# Sort-Object -Property FullName
			# above can't work, use below :
		# Get all video files in the directory (optionally recursing into subdirectories), sorted by FullName
		if ($NotRecurse) {
			$files = Get-ChildItem -LiteralPath $LiteralPath -File:$OnlyFile -Directory:$OnlyDir |
				Where-Object { [System.IO.Path]::GetExtension($_.Name).TrimStart('.').ToLower()  -in $TypeList } | 
				Sort-Object -Property FullName
		} else {
			$files = Get-ChildItem -LiteralPath $LiteralPath -Recurse  -File:$OnlyFile -Directory:$OnlyDir |
				Where-Object { [System.IO.Path]::GetExtension($_.Name).TrimStart('.').ToLower() -in $TypeList } | 
				Sort-Object -Property FullName
		}
	}
    if ($files.Count -gt 0) {
		Write-Debug "files： $files"
    }
	
	 if ($ExcludeTypeList -and $ExcludeTypeList.Count -gt 0){
		Write-Debug "$ExcludeTypeList"
		$files = $files | Where-Object { -not `
		([System.IO.Path]::GetExtension($_.Name).TrimStart('.').ToLower() -in $TypeList ) }
		
	 }
	
    # Filter files by include prefix
    if ($IncludePrefix -and $IncludePrefix.Count -gt 0) {
        $prefixPattern = "^(" + ($IncludePrefix -join "|") + ")"
        $files = $files | Where-Object { $_.Name -match $prefixPattern }
		Write-Debug "$IncludePrefix"
		# Write-Debug "$files"
    }

    # Filter files by exclude prefix
    if ($ExcludePrefix -and $ExcludePrefix.Count -gt 0) {
        $prefixPattern = "^(" + ($ExcludePrefix -join "|") + ")"
        $files = $files | Where-Object { -not ($_.Name -match $prefixPattern) }
		Write-Debug "$ExcludePrefix"
		# Write-Debug "$files"
    }
    # Check if there are any files
    if ($files.Count -eq 0) {
        Write-Warning "No files found in directory '$LiteralPath' with specified extensions and prefixes. Exiting."
        return $null
    }

    return $files
}

# # Rename all files in the current directory using the Get-ClipOutputRename function
# Rename-ByTypeAndRegex -RenameFunction { param($fileName) Get-ClipOutputRename $fileName }

# # Rename all mp4 files in the specified directory using the Get-ClipOutputRename function
# Rename-ByTypeAndRegex -SourceDirectory "C:\Path\To\Directory" -FileTypeList @("*.mp4") -RenameFunction { param($fileName) Get-ClipOutputRename $fileName }

function Rename-ByRegex {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$RenameFunction,
        [Parameter()]
        [ValidateScript({Test-Path -LiteralPath $_ -PathType 'Container'})]
        [string]$SourceDirectory = $PSScriptRoot,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [array]$FileTypeList,
		[ValidateNotNullOrEmpty()]
        [array]$ExcludeTypeList,
		[Parameter()]
        [string[]]$IncludePrefix,
        [Parameter()]
        [string[]]$ExcludePrefix,
        [Parameter()]
        [switch]$NotRecurse,
		[Parameter()]
        [switch]$OnlyFile,
		[Parameter()]
        [switch]$OnlyDir
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
	$items = Get-FilesInDir $SourceDirectory -TypeList $FileTypeList `
			-ExcludeTypeList $ExcludeTypeList `
			-IncludePrefix $IncludePrefix `
			-ExcludePrefix $ExcludePrefix `
			-NotRecurse:$NotRecurse `
			-OnlyFile:$OnlyFile -OnlyDir:$OnlyDir 

    if ($items.Count -gt 0) {
        Write-Host "Renaming $($items.Count) items in directory '$SourceDirectory'."
        foreach ($item in $items) {
            $newName = & $RenameFunction $item.Name
            if ($newName -eq $item.Name) {
                Write-Host "$item not match ${RenameFunction.Name}"
                continue
            }
			$parentPath =  Split-Path $item.FullName -Parent 
            $newFullName = Join-Path $parentPath $newName

            if (Test-Path $newFullName) {
                $overwrite = Read-Host "item '$newName' already exists. Do you want to overwrite it? (y/n)"
                if ($overwrite.ToLower() -eq 'y') {
					Write-Debug "Move-Item -LiteralPath $($item.FullName) -Destination $newFullName -Force"
                    Move-Item -LiteralPath $item.FullName -Destination $newFullName -Force
                }else{
					Write-Host " $item not move"
				}
            } else {
                Move-Item -LiteralPath $item.FullName -Destination $newFullName
				Write-Debug "Move-Item -LiteralPath $($item.FullName) -Destination $newFullName -Force"
            }
            Write-Host "Renamed item '$($item.FullName)' to '$newName'."
        }
    } else {
        Write-Host "No items to rename in directory '$SourceDirectory'."
    }
}

# 重命名模式
function Rename-Regex([string]$itemName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    # $match = [regex]::Match($itemName, "(^${ts_merge_output_prefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    # if ($match.Success) {
        # return "$($match.Groups[3].Value)$($match.Groups[4].Value)"
    # }
    # else {
        # return $itemName
    # }
	
	#The replace operator in PowerShell takes two arguments; 
	#string to find for in a string and replacement string for the found text.
	$newName=$itemName 
	#####
	
	$newName=$newName -replace ' ',' '
	#$newName = $newName -replace '\d(\d\d)', '$1'
	
	##windows 重命名文件(1) 改为 01 (9) ,09
	# $newName = $newName -replace '\s+',' '
	
	# if ($newName -match '\s*\((\d+)\)\s*\.[0-9a-zA-Z]+$') {
		# $num = ' {0}' -f $matches[1].PadLeft(2, '0') 
		# $newName = $newName -replace "\((\d+)\)", "${num}"
	# }
	
	$newName=$newName -replace '\s+',' '
	$newName=$newName -replace '_+','_'
	
	Write-Debug "newName : $newName"
	return $newName

}
###实际执行命令

$video_types_list = @("avi", "mp4", "mkv", "flv", "mov", "wmv", "mts", "ts", "vob", "webm", "mpeg", "mpg", "rmvb")

Rename-ByRegex { param($itemName) Rename-Regex $itemName } -SourceDirectory ./ -ExcludeTypeList @("ps1")

$DebugPreference = "SilentlyContinue"
