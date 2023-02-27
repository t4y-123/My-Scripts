####################
# 功能函数脚本
####################

$wait_in_dir='.\wait_in'
$working_dir='.\working'
$wait_in_dir_name='wait_in'

$auto_split_work_dir = '.\auto_split'
$auto_split_tmp_merge_dir = '.\auto_split_tmp_merge'
$auto_merge_work_dir = '.\auto_merge'
$end_auto_clip_dir='.\end_clip'
$end_auto_merge_dir='.\end_auto_merge'
$end_auto_src_dir='.\end_src'



$end_clip_dir='.\end_clip'
$end_merge_dir='.\end_merge'
$end_src_dir='.\end_src'

$end_x_ps1_dir = '.\end_exec_powershell'

$video_types_list = @("avi", "mp4", "mkv", "flv", "mov", "wmv", "mts", "ts", "vob", "webm", "mpeg", "mpg", "rmvb")

$txtExtention="txt"
$txtExtentionList=@($txtExtention)

$srcTextPrefix="src_"
$srcTxtPrefixList=@($srcTextPrefix)

$videoClipPrefix="clip_"
$videoClipPrefixList=@($videoClipPrefix)
$videoMergedPrefix="merged_"
$videoMergedPrefixList=@($videoMergedPrefix)
$videoIngonrePrefix=@($videoClipPrefix, $videoMergedPrefix);

$cut_ps1_prefix="x_cut_"
$cut_ps1_prefix_list=@($cut_ps1_Prefix)
$cut_pre_ps1_prefix="x_pre_cut_"
$cut_pre_ps1_prefix_list=@($cut_pre_ps1_prefix)
$cut_recut_ps1_prefix="x_recut_"
$cut_recut_ps1_prefix_list=@($cut_recut_ps1_prefix)

$concat_merge_ps1_prefix="x_concat_merge_"
$concat_merge_ps1_prefix_list=@($concat_merge_ps1_prefix)
$concat_target_text_prefix= "concat_target_"
$concat_target_file_prefix_list = @($concat_target_text_prefix)

$concat_output_prefix= "concat_merge_"
$concat_output_prefix_list = @($concat_output_prefix)


$ts_merge_ps1_prefix="x_ts_merge_"
$ts_merge_ps1_prefix_list=@($ts_merge_ps1_prefix)

$ts_target_txt_prefix= "ts_tmp_target_"
$ts_target_txt_prefix_list = @($ts_tmp_ts_prefix)



$ts_merge_output_prefix= "ts_merge_"
$ts_merge_output_prefix_list = @($ts_merge_output_prefix)
$ts_tmp_ts_prefix= "ts_tmp_"
$ts_tmp_ts_prefix_list = @($ts_tmp_ts_prefix)
$ts_remove_prefix_list = @($ts_merge_output_prefix,$ts_tmp_ts_prefix)
$tsExtention="ts"
$tsExtentionList=@($tsExtention)

$ps1Extention="ps1"
$ps1ExtentionList=@($ps1Extention)


$src_exclude_prefix_list = @( $videoClipPrefix,$videoMergedPrefix,$concat_output_prefix,$ts_merge_output_prefix,$ts_tmp_ts_prefix )

$fileLineRegex = '^:[\s\t]*(?<FileName>.+\.(?<Extension>[a-z0-9]+))[\s\t]*$'
$spaceLineRegex = "^[ `t]*$"
$timeLineRegex = "^[\s\t]*(?<StartTime>\d{6,9}|\d{2}[:：]\d{2}[:：]\d{2}(\.\d{1,3})?)[\s\t]+(?<EndTime>\d{6,9}|\d{2}[:：]\d{2}[:：]\d{2}(\.\d{1,3})?)[\s\t]*$"
$cutPs1IgnoreMergeChar = '^["<>/\|]'
$mergePs1IgnoreMergeChar = '^["/\|]'
$postProcessIgnoreMergeChar = '^[/\|]'
$mergeStartLine = '^<'
$mergeEndLine = '^>'
$mergeStartChar = '<'
$mergeEndChar = '>'
$directoryNameLine = '"(.*)"'

$cutCmdTemplate = "ffmpeg -copyts -ss {0} -to {1} -accurate_seek -i '{2}' -vcodec copy -acodec copy '{3}' -y"
$concatMergeCmdTemplate = "ffmpeg -f concat -safe 0 -i '{0}' -c copy '{1}' -y"
$tsCopyCmdTemplate = "ffmpeg -i '{0}' -c copy -bsf:v h264_mp4toannexb -f mpegts '{1}' -y"
$tsMergeCmdTemplate = "ffmpeg  -f concat -safe 0 -i '{0}' -c copy -bsf:a aac_adtstoasc -movflags +faststart '{1}' -y"
$concatTargetFileTemplat = "file '{0}'"

$auto_concat_merge_ps1_prefix="x_auto_concat_merge_"
$auto_concat_merge_ps1_prefix_list=@($auto_concat_merge_ps1_prefix)
$auto_concat_target_text_prefix= "auto_concat_target_"
$auto_concat_target_file_prefix_list = @($auto_concat_target_text_prefix)

$auto_concat_output_prefix= "auto_concat_output_"
$auto_concat_output_prefix_list = @($auto_concat_output_prefix)

$auto_ts_merge_ps1_prefix="x_auto_ts_merge_"
$auto_ts_merge_ps1_prefix_list=@($auto_ts_merge_ps1_prefix)

$auto_ts_tmp_target_txt_prefix= "ts_tmp_target_"
$auto_ts_tmp_target_txt_prefix_list = @($ts_tmp_ts_prefix)
$auto_ts_merge_output_prefix= "auto_ts_merge_output_"
$auto_ts_merge_output_prefix_list = @($auto_ts_merge_output_prefix)
$auto_ts_tmp_ts_prefix= "auto_ts_copy_output_"
$auto_ts_tmp_ts_prefix_list = @($auto_ts_tmp_ts_prefix)
$auto_ts_remove_prefix_list = @($auto_ts_tmp_ts_prefix,$auto_ts_tmp_ts_prefix)


$auto_merge_excludePrefix_list = @($auto_concat_output_prefix,$auto_ts_merge_output_prefix,$auto_ts_tmp_ts_prefix)
$auto_split_merge_remove_prefix_list = @($auto_concat_target_text_prefix,`
										$auto_ts_merge_ps1_prefix,`
										$auto_concat_merge_ps1_prefix,`
										$auto_ts_merge_ps1_prefix,`
										$auto_ts_tmp_target_txt_prefix)
$auto_split_merge_remove_extention_list = @($ps1Extention,$txtExtention)

# For use Windows Recycle Bin
Add-Type -AssemblyName Microsoft.VisualBasic

#更易读的输出方式 Output the files with their full path, size in MB, and size in GB
function Format-VedioFileInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.IO.FileInfo[]]$VideoFiles 
    )
    $VideoFiles | Select-Object FullName, @{Name="Size (MB)";  Expression={"{0:N2}" -f ($_.Length / 1MB)}} , @{Name="Size (GB)";  Expression={"{0:N2}" -f ($_.Length / 1GB)}} | Format-Table -AutoSize
}

#总是需要获取指定类型文件

function Get-CertainFilesInDir {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$LiteralPath,

        [Parameter(Mandatory=$true)]
        [string[]]$TypeList,
        [Parameter()]
        [string[]]$IncludePrefix,
        [Parameter()]
        [string[]]$ExcludePrefix,
        [Parameter()]
        [switch]$NotRecurse
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

    # Check if TypeList is empty
    if ($TypeList.Count -eq 0) {
        Write-Warning "TypeList is empty. Exiting."
        return $null
    }
	# Get all video files in the "From" directory and its subdirectories, sorted by FullName
    # $videoFiles = Get-ChildItem $FromDir -Recurse -File |
        # Where-Object { $VideoTypeList -contains $_.Extension.ToLower() } |
        # Sort-Object -Property FullName
		# above can't work, use below :
    # Get all video files in the directory (optionally recursing into subdirectories), sorted by FullName
    if ($NotRecurse) {
        $files = Get-ChildItem -LiteralPath $LiteralPath -File |
            Where-Object { [System.IO.Path]::GetExtension($_.Name).TrimStart('.').ToLower()  -in $TypeList } | 
            Sort-Object -Property FullName
    } else {
        $files = Get-ChildItem -LiteralPath $LiteralPath -Recurse -File |
            Where-Object { [System.IO.Path]::GetExtension($_.Name).TrimStart('.').ToLower() -in $TypeList } | 
            Sort-Object -Property FullName
    }
	#Write-Debug "files： $files"
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

# delete to windows Recycle Bin , 删除至Window回收站。
function Remove-Item-ToRecycleBin-LiteralPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$Path
    )
    process {
        try {
            $item = Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue
            if ($item -eq $null) {
                Write-Error("'{0}' not found" -f $Path)
                return $false
            }
            else {
                $fullpath=$item.FullName
                Write-Verbose ("Moving '{0}' to the Recycle Bin" -f $fullpath)
                if (Test-Path -LiteralPath $fullpath -PathType Container) {
                    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($fullpath,'OnlyErrorDialogs','SendToRecycleBin')
                }
                else {
                    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($fullpath,'OnlyErrorDialogs','SendToRecycleBin')
                }
				Write-Host "Delete item to RecycleBin: `n $item.FullName"
                return $true
            }
        }
        catch {
            Write-Error $_
            return $false
        }
    }
}

# delete to windows Recycle Bin , 删除至Window回收站。
function Remove-Item-ToRecycleBin($Path) {
    $item = Get-Item -Path $Path -ErrorAction SilentlyContinue
    if ($item -eq $null)
    {
        Write-Error("'{0}' not found" -f $Path)
		return $false
    }
    else
    {
        $fullpath=$item.FullName
        Write-Verbose ("Moving '{0}' to the Recycle Bin" -f $fullpath)
        if ( (Test-Path -Path $fullpath -PathType Container) )
        {
           [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($fullpath,'OnlyErrorDialogs','SendToRecycleBin')
        }
        else
        {
		[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($fullpath,'OnlyErrorDialogs','SendToRecycleBin')
        }
		return $true
    }
}


# 从指定目录获取一个文件，并生成操作文本文件
function Move-One-VideoFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FromDir,

        [Parameter(Mandatory = $true)]
        [string]$ToDir,

        [Parameter(Mandatory = $true)]
        [string[]]$VideoTypeList,

        [Parameter()]
        [bool]$GenerateTxt = $false
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
    # Ensure that the "From" directory exists
    if (!(Test-Path  -LiteralPath $FromDir -IsValid -PathType Container)) {
        Write-Warning "The [ $FromDir ] path is not a directory. Operation aborted."
        return $false
    }

    # Ensure that the "To" directory exists, or create it if it doesn't
    if (!(Test-Path  -LiteralPath $ToDir -PathType Container)) {
		if (!(Test-Path -Path $ToDir -IsValid)) {
			Write-Warning "The to:[ $ToDir ]  path is not a valid path. Operation aborted."
			return $false
		}
        $createDir = Read-Host "The 'To' [ $ToDir ] directory path does not exist. Create it? (Y/N) case insensitive."
        if ($createDir.ToLower() -eq "y") {
            New-Item  -Path -ItemType Directory -Path $ToDir | Out-Null
        } else {
            Write-Host "The 'to': [ $ToDir ] path not be created. Operation aborted."
            return $false
        }
    }

    # Ensure that the video type list is not empty
    if (!$VideoTypeList -or !$VideoTypeList.Length) {
          Write-Warning "The VideoTypeList list is not provided or is empty. Operation aborted."
        return $false
    }

	Write-Host "VideoTypeList:[ $VideoTypeList ] "
	$videoFiles = Get-CertainFilesInDir $FromDir $VideoTypeList
	

	# return
    if ($videoFiles) {
		Write-Host "videoFiles :"	
		Format-VedioFileInfo $videoFiles
	
		# Get the first video file from the sorted list
		$selectedFile = $videoFiles[0]

		# Check if the destination file already exists
		$newPath = Join-Path $ToDir $selectedFile.Name
		Write-Host "newPath : $newPath"	
		if (Test-Path  -LiteralPath $newPath ) {
			$overwrite = Read-Host "The destination file [$newPath] already exists. Overwrite? (Y/N) case insensitive."
			if ($overwrite.ToLower() -eq "y") {
				Write-Host "The file was not moved. Exiting. Operation aborted."
				return $false
			}
		}
		
        if ($GenerateTxt) {			
            # Generate the text file
            $txtPath = Join-Path $ToDir "src_$($selectedFile.BaseName).txt"
			if (Test-Path -LiteralPath $txtPath) {
				$overwrite = Read-Host "The file '$txtPath' already exists. Overwrite (O) or Append (A)? (O/A) case insensitive."
				if ($overwrite.ToLower() -eq "o") {
					Remove-Item-ToRecycleBin-LiteralPath $txtPath
				} elseif ($overwrite.ToLower() -ne "a") {
					Write-Warning "Invalid choice. Operation aborted."
					return $false
				}
			}
			#$relPath = [IO.Path]::GetRelativePath( $FromDir, $selectedFile.FullName ) #error
			$parentDir = Split-Path $selectedFile.FullName -Parent
			$dirName = Split-Path $parentDir -Leaf
            $txtContent = @"
<

"$($dirName)"
:$($selectedFile.Name)




>

"@

			if (!(Test-Path -LiteralPath $txtPath)) {
				New-Item -Path $txtPath -ItemType File -Force
			}
			if ($overwrite -and $overwrite.ToLower() -eq "a") {
				Add-Content -LiteralPath $txtPath $txtContent 
			} else {
				Set-Content -LiteralPath $txtPath $txtContent 
			}
        }

        # Move the selected file to the "To" directory
        $newPath = Join-Path $ToDir $selectedFile.Name
        Move-Item  -LiteralPath $selectedFile.FullName $newPath -Force
		return $true
    } else {
        Write-Warning "No video files with the specified extensions were found in the 'From':[$FromDir] directory."
		return $false
    }
}

# create src file in the working dir. 为目录里的所有视频生成一个有共同前缀的源文本文件。
function Create-VediosSrcTextInDir {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LiteralPath,
        [Parameter(Mandatory = $true)]
        [string[]]$VideoTypeList
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
    $FullPath = Join-Path $PWD $LiteralPath

    # check if the specified path is valid and exists
    if (!(Test-Path -LiteralPath $FullPath -PathType Container)) {
        Write-Warning "The specified path '$FullPath' is not a valid directory. Operation aborted."
        return $false
    }

    # get all the video files in the directory and filter them based on the specified video types

	Write-Host "VideoTypeList:[ $VideoTypeList ] "
	$videoFiles = Get-CertainFilesInDir $LiteralPath $VideoTypeList
	
    if ($videoFiles.Count -eq 0) {
        Write-Warning "No video files with the specified extensions were found in the directory. Operation aborted."
        return $false
    }else{
		Write-Host "videoFiles :"	
		Format-VedioFileInfo $videoFiles
	}
    # get the extension of the first video file and check if it matches with the other video files in the directory
    $firstVideoFileExtension = $videoFiles[0].Extension.ToLower()

    foreach ($videoFile in $videoFiles) {
        if ($videoFile.Extension.ToLower() -ne $firstVideoFileExtension) {
            Write-Warning "All video files in the directory must have the same extension. Operation aborted."
            return $false
        }
    }

	# Get the common prefix of the video file names
	$commonPrefix = ""

	foreach ($charIndex in 0..($videoFiles[0].BaseName.Length - 1)) {
		$char = $videoFiles[0].BaseName[$charIndex]
		$match = $true

		foreach ($videoFile in $videoFiles) {
			if ($videoFile.BaseName.Length -le $charIndex -or $videoFile.BaseName[$charIndex] -ne $char) {
				$match = $false
				break
			}
		}

		if (!$match) {
			break
		}

		$commonPrefix += $char
	}

	Write-Host "Common prefix: $commonPrefix"

    # Create the text file and write the video information to it
    $txtPath = Join-Path $FullPath "src_${commonPrefix}.txt"
    
	if (Test-Path -LiteralPath $txtPath) {
		$overwrite = Read-Host "The file '$txtPath' already exists. Overwrite (O) or Append (A)? (O/A) case insensitive."
		if ($overwrite.ToLower() -eq "o") {
			Remove-Item-ToRecycleBin-LiteralPath $txtPath
		} elseif ($overwrite.ToLower() -ne "a") {
			Write-Warning "Invalid choice. Operation aborted."
			return $false
		}
	}	
	
	$timeStamp = Get-Date -Format "yyyy-MM-dd_HHmmssfff"
	$videoInfo = 
	        @"
<

"@
	foreach ($videoFile in $videoFiles) {
    $videoInfo += @"
"Dir_$timeStamp"
:$($videoFile.Name)



"@
}
	$videoInfo += 
	        @'


>

'@
	
	if (!(Test-Path -LiteralPath $txtPath)) {
		New-Item -Path $txtPath -ItemType File -Force
	}
	if ($overwrite -and $overwrite.ToLower() -eq "a") {
		Add-Content -LiteralPath $txtPath $videoInfo 
	} else {
		Set-Content -LiteralPath $txtPath $videoInfo 
	}
	return $true
}
# Define StartsWithAny() extension method
function StartsWithAny {
    param(
        [string]$String,
        [string[]]$Prefixes
    )
	Write-Debug "String : $String"
	Write-Debug "Prefixes: "$Prefixes
    foreach ($prefix in $Prefixes) {
        if ($String.StartsWith($prefix)) {
            return $true
        }
    }

    return $false
}

#为scr_*.txt文件准备，检查只有一个指定类型文件在目录中
function Check-SingleFileInDirByType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$LiteralPath,
        [Parameter(Mandatory=$true)]
        [string[]]$TypeList,
		[string[]]$IncludePrefix,
		[Switch]$NoMoreThan
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
	
    $files = Get-CertainFilesInDir $LiteralPath $TypeList
	Write-Debug "files:""$files"
	
	# Filter files by include prefix
    if ($IncludePrefix -and $IncludePrefix.Count -gt 0) {
		Write-Debug "2nd: get all files in IncludePrefix: ""^($($IncludePrefix -join '|'))" 
        $files = $files | Where-Object { $_.Name -match "^($($IncludePrefix -join '|'))" }
		Write-Debug "files:""$files"
    }

    $count = $files.Count
	Write-Debug "count: $count"
    if ($count -eq 0) {
        Write-Warning "No files with the specified types were found in the directory '$LiteralPath'"
		if($NoMoreThan){
			return $true
		}else{
			return $false
		}
    } elseif ($count -gt 1) {
        Write-Warning "Multiple files with the specified types were found in the directory '$LiteralPath'"
        return $false
    } else {
		if($NoMoreThan){
			return $false
		}else{
			return $true
		}
    }
}

# 打开指定特征的文件 "Open files with specific characteristics"
function Invoke-FileByType {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path -LiteralPath $_ -PathType Container } )]
        [string]$LiteralPath,
        [Parameter(Mandatory = $true)]
        [string[]]$IncludeExtensions,
        [string[]]$IncludePrefix,
        [string[]]$ExcludePrefix
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    # Get all files in the directory and its subdirectories with the included extensions

	$files = Get-CertainFilesInDir $LiteralPath $IncludeExtensions
	# Check if there are any files
    if ($files.Count -eq 0) {
        Write-Warning "No files found in directory '$LiteralPath' with specified extensions and prefixes. Exiting."
        return $false
    }
	Write-Host "files :"	
	Format-VedioFileInfo $files
	
	# Filter files by include prefix
    if ($IncludePrefix -and $IncludePrefix.Count -gt 0) {
		Write-Debug "IncludePrefix : ^($($IncludePrefix -join '|'))" 
		$files = $files | Where-Object { $_.Name -match "^($($IncludePrefix -join '|'))" }
		Write-Debug "files:""$files"
    }
	
    # Filter files by exclude prefix
    if ($ExcludePrefix -and $ExcludePrefix.Count -gt 0) {
		Write-Debug "ExcludePrefix : ""^($($ExcludePrefix -join '|'))" 
        $files = $files | Where-Object { -not ($_.Name -match "^($($ExcludePrefix -join '|'))") }
		Write-Debug "files:""$files"
    }
	
	# Check if there are any files
    if ($files.Count -eq 0) {
        Write-Warning "No files found in directory '$LiteralPath' with specified extensions and prefixes. Exiting."
        return $false
    }
	# Open file with default program
	Invoke-Item -LiteralPath  $files[0].FullName
}



function ConvertToTimeFormat($timeString) {
    if ($timeString -match '^\d{2}[:：]\d{2}[:：]\d{2}(\.\d{1,3})?$') {
        # Time is already in the correct format
        $timeString = $timeString.Replace('：', ':')
		if ($timeString.Length -eq 8){
			$timeString += ".000"
		}else{
			$timeString = $timeString.PadLeft(12, '0')
		}
    } elseif ($timeString -match '^\d{6,9}$') {
        $timeString = $timeString.PadRight(9, '0')
        # Convert 6-9 digit time to HH:mm:ss.000 or HH:mm:ss.fff format
		$timeString = ("{0}:{1}:{2}.{3}" -f $timeString.Substring(0, 2),$timeString.Substring(2, 2),$timeString.Substring(4,2),
		$timeString.Substring(6, 3))
    } else {
        Write-Error "Invalid time format: $timeString"
        return $null
    }
    return $timeString
}


function Get-SourceTextFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string]$TxtPrefix
    )

    $srcTxtFile = Get-ChildItem -LiteralPath $WorkingDir -Filter "${TxtPrefix}*.txt" | Select-Object -First 1
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $null
    }
    return $srcTxtFile
}

function Check-FileOverideOrAppend {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
		[Alias("o")]
		[switch]$Overwrite,
		[Alias("a")]
        [switch]$Append
    )
    if (!$FilePath -or -not (Test-Path -LiteralPath $FilePath -IsValid)) {
        Write-Error "FilePath not valid :$FilePath."
        return $false 
    }
    if (Test-Path -LiteralPath $FilePath) {
         if ($Overwrite) {
            Remove-Item -LiteralPath $FilePath -Force -Confirm:$false
			New-Item -Path $FilePath;
        }
        elseif ($Append) {
            Write-Host "Appending to existing file: $FilePath"
        }
        else {
            $overwriteAsked = Read-Host "The file '$($FilePath)' already exists, overwrite or append (o/a)? case insensitive."
            if ($overwriteAsked.ToLower() -eq "o") {
                Remove-Item -LiteralPath $FilePath
				New-Item -Path $FilePath;
            } elseif ($overwriteAsked.ToLower() -ne "a") {
                continue
            }
        }
    }
    else {
        New-Item -Path $FilePath;
        Write-Debug "FilePath: $FilePath"
    }
	return $true
}

function Get-FilePathBaseSrcText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string]$SrcPrefix,
        [Parameter(Mandatory=$true)]
        [string]$DesPrefix,
        [Parameter(Mandatory=$true)]
        [System.IO.FileInfo]$SrcTxtFile,
        [string]$DesExtention = "ps1"
    )
    $srcTextFileNameWithoutPrefix = $SrcTxtFile.BaseName.Replace($TxtPrefix, "")
    Write-Debug "srcTextFileNameWithoutPrefix: $srcTextFileNameWithoutPrefix"
    $desFilePath = Join-Path $WorkingDir ($DesPrefix + $srcTextFileNameWithoutPrefix + "." + $DesExtention)
    return $desFilePath
}

function Get-CutCommand {
    param(
		[Parameter(Mandatory=$true)]
        [int]$count,
        [Parameter(Mandatory=$true)]
        [string]$line,
        [Parameter(Mandatory=$true)]
        [string]$currentVideoFile
    )
    
    # Define regular expressions to match start and end times
    if ($line -match $timeLineRegex) {
        # Parse the start and end times
		$startTimeStr = $matches['StartTime']
		$endTimeStr = $matches['EndTime']
		Write-Debug "# startTimeStr: $startTimeStr  |   EndTime: $endTimeStr "

		$startTime = ConvertToTimeFormat $startTimeStr
		$endTime = ConvertToTimeFormat $endTimeStr
		Write-Debug "# startTime: $startTime  |   endTime: $endTime "
		
		# Check if the end time is later than the start time
		Write-Host "Time $count : [$startTime]`t[$endTime]"
		$endTicks = [DateTime]::ParseExact($endTime, "HH:mm:ss.fff", $null).Ticks
		$startTicks = [DateTime]::ParseExact($startTime, "HH:mm:ss.fff", $null).Ticks
		if ( $endTicks -le $startTicks) {
			Write-Error "In line count:[$count], End time [$endTimeStr] is not later than start time [$startTimeStr]"
			return $null
		}
		
		# Generate the cut command for the current video file
		$outputFileName = '{0}{1}_{2}' -f $videoClipPrefix, ("{0:d3}" -f $count), $currentVideoFile
		# $cutCmdTemplate = "ffmpeg -copyts -ss {0} -to {1} -accurate_seek -i '{2}' -vcodec copy -acodec copy '{3}' -y"
		$cutCmd = $cutCmdTemplate -f $startTime, $endTime, $currentVideoFile, $outputFileName
		Write-Debug "# cutCmd: $cutCmd "
        return $cutCmd
    }
}


function Generate-CutPowerShellFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypeList,
        [Parameter(Mandatory=$true)]
        [string]$TxtPrefix,
		[Alias("o")]
		[switch]$Overwrite,
		[Alias("a")]
        [switch]$Append
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
    $srcTxtFile = Get-SourceTextFile $WorkingDir $TxtPrefix
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $false
    }
	# Check if the cut powershell file already exists
    $cutPs1FilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $cut_ps1_prefix $srcTxtFile 
    if (!$cutPs1FilePath -or !(Test-Path -LiteralPath $cutPs1FilePath -IsValid)) {
        Write-Warning "cutPs1FilePath not valid :$cutPs1FilePath."
        return $false
    }
	Check-FileOverideOrAppend -FilePath $cutPs1FilePath -Overwrite:$Overwrite -Append:$Append
    # Read the source text file content
    $srcContent = Get-Content -LiteralPath $srcTxtFile.FullName 
	Write-Debug "srcContent: $srcContent"

    # Get the file names to generate cut commands
    $currentVideoFile = $null
    $videoFiles = New-Object System.Collections.ArrayList

	$count = 1
    foreach ($line in $srcContent) {
		Write-Debug "line:`n$line"

        if ($line -match $cutPs1IgnoreMergeChar) {						
			Write-Debug "# Ignore lines that start with: $ignoreMergeChar"
            continue
        } elseif ($line -match $spaceLineRegex){
			Write-Debug "# Ignore lines that empty"
			continue
		}elseif ($line -match $fileLineRegex) {
            # Check if the file name is in the video type list
            $extension = $matches['Extension']
			Write-Debug "# extension: $extension"
            if ($VideoTypeList -notcontains $extension.ToLower()) {
                Write-Error "Error in file '${matches['FileName']}' with extension '${extension}' 
				not in the video type list."
                return $false
            }
            # Update the current video file
            # $currentVideoFile = $line.Trim().Substring(1)
			$currentVideoFile =$line.Trim().Substring(1)
			
			Write-Debug "# currentVideoFile: $currentVideoFile"
        } elseif ($line -match $timeLineRegex) {
			Write-Debug "line:$line "
			if (!$currentVideoFile){
				Write-Warning "Has time put fornt all vedio file. "
			}
			$cutCmd = Get-CutCommand $count $line $currentVideoFile
			if (!$cutCmd){
				Write-Error "Get-CutCommand faild in  : $count $line $currentVideoFile.  $cutCmd"
				return $false
			}
			# Append the cut command to the cut powershell file
			Add-Content -LiteralPath $cutPs1FilePath -Value $cutCmd
			
			$count++
        }else{
			Write-Error "There have illegal line in $line"
			return $false
		}
    }
	return $true
} 

# 用来删除clip_,或其它文件。
function Remove-ByTypeAndPrefix {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -LiteralPath $_ -PathType 'Container'})]
        [string]$DirectoryPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$FileTypeList,

        [Parameter()]
        [array]$IncludePrefix,
		
		[Parameter()]
        [Switch]$PermanentDelete
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

	$files = Get-CertainFilesInDir $DirectoryPath $FileTypeList $IncludePrefix 

    # Delete all files
    if ($files.Count -gt 0) {
		Write-Host "|Files to delete: "
		Format-VedioFileInfo $files

		foreach ($file in $files) {
			if ($PermanentDelete) {
                Remove-Item -LiteralPath $file.FullName -Force
            } else {
                Remove-Item-ToRecycleBin-LiteralPath -Path $file.FullName
            }
		}
        Write-Host "Deleted $($files.Count) files from directory '$DirectoryPath'."
    } else {
        Write-Host "No files to delete in directory '$DirectoryPath'."
    }
	return $true
}

enum CutCommandComparisonResult {
    AllSame
    DifferentOutputName
    NotSame
}
function Compare-CutCommands {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$CutCommand1,
        [Parameter(Mandatory=$true)]
        [string]$CutCommand2
    )
    #$cutCmdTemplate = "ffmpeg -copyts -ss {0} -to {1} -accurate_seek -i '{2}' -vcodec copy -acodec copy '{3}' -y"
	#https://lazywinadmin.com/2014/09/powershell-tip-escape-regex.html
    $regex = [regex]::Escape($cutCmdTemplate -f '', '', '', '') + "(.+?)" + [regex]::Escape(' -vcodec copy -acodec copy ''') + "(.+?)" + [regex]::Escape("'' -y")
    $CutCommand1Match = [regex]::Match($CutCommand1, $regex)
    $CutCommand2Match = [regex]::Match($CutCommand2, $regex)
    if ($CutCommand1Match.Success -and $CutCommand2Match.Success) {
        $CutCommand1StartTime = $CutCommand1Match.Groups[1].Value
        $CutCommand2StartTime = $CutCommand2Match.Groups[1].Value
        if ($CutCommand1StartTime -ne $CutCommand2StartTime) {
            return [CutCommandComparisonResult]::NotSame
        }
        $CutCommand1EndTime = $CutCommand1Match.Groups[2].Value
        $CutCommand2EndTime = $CutCommand2Match.Groups[2].Value
        if ($CutCommand1EndTime -ne $CutCommand2EndTime) {
            return [CutCommandComparisonResult]::NotSame
        }
        $CutCommand1InputFile = $CutCommand1Match.Groups[3].Value
        $CutCommand2InputFile = $CutCommand2Match.Groups[3].Value
        if ($CutCommand1InputFile -ne $CutCommand2InputFile) {
            return [CutCommandComparisonResult]::NotSame
        }
        $CutCommand1OutputFile = $CutCommand1Match.Groups[4].Value
        $CutCommand2OutputFile = $CutCommand2Match.Groups[4].Value
        if ($CutCommand1OutputFile -eq $CutCommand2OutputFile) {
            return [CutCommandComparisonResult]::AllSame
        }
        else {
            return [CutCommandComparisonResult]::DifferentOutputName
        }
    }
    else {
        throw "One or both cut commands are not in the correct format"
    }
}

function Get-ContentOnlyInFirstFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FirstFilePath,
        [Parameter(Mandatory=$true)]
        [string]$SecondFilePath
    )

    # Read the content of the two files
    $firstFileContent = Get-Content -LiteralPath $FirstFilePath
    $secondFileContent = Get-Content -LiteralPath $SecondFilePath

    # Find the lines that are in $firstFileContent but not in $secondFileContent
    $firstOnly = Compare-Object $firstFileContent $secondFileContent -PassThru | Where-Object { $_ -notin $secondFileContent }

    return $firstOnly
}


function Generate-ReCutPowerShellFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypeList,
        [Parameter(Mandatory=$true)]
        [string]$TxtPrefix,
		[Alias("o")]
		[switch]$Overwrite,
		[Alias("a")]
        [switch]$Append
    )
	$srcTxtFile = Get-SourceTextFile $WorkingDir $TxtPrefix
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $false
    }
	# Check if the cut powershell file already exists
    $cutPs1FilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $cut_ps1_prefix $srcTxtFile
    if (!$cutPs1FilePath -or -not (Test-Path -LiteralPath $cutPs1FilePath)){
        Write-Warning "Cannot find cut PowerShell file with prefix '$cut_ps1_prefix' in '$WorkingDir'."
        return $false
    }
	
	$cutPrePs1FilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $cut_pre_ps1_prefix $srcTxtFile
	if (!$cutPrePs1FilePath -or -not (Test-Path -LiteralPath $cutPrePs1FilePath -IsValid)) {
		Write-Warning "cutPrePs1FilePath not valid :$cutPrePs1FilePath."
		return $false
	}elseif ( Test-Path -LiteralPath $cutPrePs1FilePath ) {
		Remove-Item -LiteralPath $cutPrePs1FilePath
	}

	$reCutPs1FilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $cut_recut_ps1_prefix $srcTxtFile
	if (!$reCutPs1FilePath -or -not (Test-Path -LiteralPath $reCutPs1FilePath -IsValid)) {
        Write-Warning "reCutPs1FilePath not valid :$reCutPs1FilePath."
        return $false
    }
	
	# Rename-Item -LiteralPath $cutPrePs1FilePath -NewName ??, is not very great
    Move-Item -LiteralPath $cutPs1FilePath -Destination $cutPrePs1FilePath
	if(Test-Path -LiteralPath $cutPs1FilePath){
		Write-Error "Rename-Item fail :$cutPs1FilePath. $cutPrePs1FilePath"
        return $false
	}
	
	Generate-CutPowerShellFile -WorkingDir $WorkingDir -VideoTypeList $VideoTypeList -TxtPrefix $TxtPrefix -Overwrite:$Overwrite -Append:$Append

	$differences = Get-ContentOnlyInFirstFile -FirstFilePath $cutPs1FilePath -SecondFilePath $cutPrePs1FilePath
	if (!$differences) {
		Write-Warning "not addition, don't need to recut"
	}
	Write-Debug "differences:$differences" 
	
	Check-FileOverideOrAppend -FilePath $reCutPs1FilePath -Overwrite
	Add-Content -LiteralPath $reCutPs1FilePath $differences 
	return $true
	# code need to complete
}


function Get-FirstClipFileName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -LiteralPath $_ -IsValid})]
        [string]$FilePath
    )

    if (!(Test-Path -LiteralPath $FilePath -PathType 'Leaf')) {
        Write-Error "Invalid file path: '$FilePath'."
        return $null
    }

    $fileContent = Get-Content -LiteralPath $FilePath -Raw
    if (!$fileContent) {
        Write-Error "File '$FilePath' is empty."
        return $null
    }

    $clipRegex = "($VideoClipPrefix\d{3}_[^']+)"

    $clipMatches = [regex]::Matches($fileContent, $clipRegex)
    if ($clipMatches.Count -eq 0) {
        Write-Error "No video clip files found in file '$FilePath'."
        return $null
    }else {
		Write-Debug $clipMatches
	}
    return $clipMatches[0]
}


function Remove-ClipFilesFromCutPs1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkingDir,
        [Parameter(Mandatory = $true)]
        [string]$CutPs1Prefix,
        [Parameter(Mandatory = $true)]
        [array]$VideoTypeList,
		[Parameter()]
        [Switch]$PermanentDelete
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    $cutPs1Files = Get-ChildItem -Path $WorkingDir -Filter "${CutPs1Prefix}*.ps1"
    if (!$cutPs1Files) {
        Write-Warning "No cut powershell files found with prefix '${CutPrefix}' in directory '${WorkingDir}'."
        return $false
    }
	
    foreach ($cutPs1File in $cutPs1Files) {
        $cutPs1Content = Get-Content -LiteralPath $cutPs1File.FullName

        foreach ($line in $cutPs1Content) {
            $match = [regex]::Match($line, "(${videoClipPrefix}\d{3}).*?\.($($VideoTypeList -join '|'))")
            if ($match.Success) {
                $clip_count_match = $match.Groups[1].Value
                $extension = $match.Groups[2].Value
                Remove-ByTypeAndPrefix $WorkingDir @($extension) @($clip_count_match) -PermanentDelete:$PermanentDelete
            }
        }
    }
	return $true
}


function Generate-ConcatMergePowerShellFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypeList,
		[Parameter(Mandatory=$true)]
        [string]$TxtPrefix,
		[Alias("o")]
		[switch]$Overwrite,
		[Alias("a")]
        [switch]$Append
    )
	Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
    $srcTxtFile = Get-SourceTextFile $WorkingDir $TxtPrefix
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $false
    }
	# Check if the merge PowerShell file already exists
    $mergePs1FilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $concat_merge_ps1_prefix $srcTxtFile 
    if (!$mergePs1FilePath -or !(Test-Path -LiteralPath $mergePs1FilePath -IsValid)) {
        Write-Warning "mergePs1FilePath not valid :$mergePs1FilePath."
        return $false
    }
	Check-FileOverideOrAppend -FilePath $mergePs1FilePath -Overwrite:$Overwrite -Append:$Append


	# Read the source text file content
    $srcContent = Get-Content -LiteralPath $srcTxtFile.FullName 
	
    $clipCount = 1
    $concatTargetFile = $null
	$merging = $false
	#concat input file
	$concatCount = 1
	$concat_target_text_count_prefix = $null
	$concat_output_count_prefix = $null
	$extension = ""
	
    foreach ($line in $srcContent) {
			Write-Debug "line:`n$line"
        if ($line -match $mergePs1IgnoreMergeChar) {						
			Write-Debug "# Ignore lines that start with: $ignoreMergeChar"
            continue
        } elseif ($line -match $spaceLineRegex){
			Write-Debug "# Ignore lines that empty"
			continue

		} elseif ($line -match $mergeStartLine){
			if($merging){
				Write-Error "There are extra lines : $line"
				return $false 
			}
			$concat_target_text_count_prefix = "{0}{1}_" -f $concat_target_text_prefix, ("{0:d3}" -f $concatCount)			
			$concatTargeFilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $concat_target_text_count_prefix  $srcTxtFile  $txtExtention 
			if (!$concatTargeFilePath -or !(Test-Path -LiteralPath $mergePs1FilePath -IsValid)) {
				Write-Warning "concatTargeFilePath not valid :$concatTargeFilePath."
				return $false
			}
			Check-FileOverideOrAppend -FilePath $concatTargeFilePath -Overwrite
			Write-Debug "concatTargeFilePath $concatTargeFilePath"
			$merging =  $true
			
		} elseif ($line -match $mergeEndLine){
			if(!$merging){
				Write-Error "There are extra lines : $line"
				return $false 
			}
			# Append the cut command to the merge PowerShell file
			$concat_output_count_prefix =  "{0}{1}_" -f $concat_output_prefix, ("{0:d3}" -f $concatCount)
			
			# $concatMergeCmdTemplate = "ffmpeg -f concat -safe 0 -i '{1}' -c copy '{2}' -y"
			$concatMergedOutputName = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $concat_output_count_prefix  $srcTxtFile  $extension 
			$concatMergedOutputName = Split-Path $concatMergedOutputName  -Leaf
			
			$concatMergeCmd = $concatMergeCmdTemplate -f (Split-Path $concatTargeFilePath -Leaf),$concatMergedOutputName
			
			Add-Content -LiteralPath $mergePs1FilePath -Value $concatMergeCmd 

			$merging = $false
			$concatCount++

		} elseif ($line -match $fileLineRegex) {
            # Check if the file name is of the correct type
            $fileName = $matches['FileName']
			$extension = $matches['Extension']
			Write-Debug "# extension: $extension"
            if ($VideoTypeList -notcontains $extension.ToLower()) {
                Write-Error "Error in file '${matches['FileName']}' with extension '${extension}' 
				not in the video type list."
                return $false
            }
			# Update the current video file
            # $currentVideoFile = $line.Trim().Substring(1)
			$currentVideoFile =$line.Trim().Substring(1)
			
			Write-Debug "# currentVideoFile: $currentVideoFile"

        } elseif ($line -match $timeLineRegex) {
			# $outputFileName = "{0}{1}_{2}" -f $videoClipPrefix, ("{0:d3}" -f $count), $currentVideoFile
			$concatTarget = "{0}{1}_{2}" -f $videoClipPrefix, ("{0:d3}" -f $clipCount), $currentVideoFile
			
            # Append the output file name in the current concat target file
            Add-Content -LiteralPath $concatTargeFilePath -Value "file '$concatTarget'"

			$clipCount++
        }else{
			Write-Error "There have illegal line in $line"
			return $false
		}
    }
	return $true
}


function Merge-Videos {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$InputFiles,
        [Parameter(Mandatory=$true)]
        [string]$OutputFile
    )

    # Get the codec of the first file
    $firstFileCodec = (ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 $InputFiles[0]).Trim()

    # Check the codec of the remaining files
    foreach ($inputFile in $InputFiles[1..($InputFiles.Count - 1)]) {
        $inputFileCodec = (ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 $inputFile).Trim()
        if ($inputFileCodec -ne $firstFileCodec) {
            Write-Error "Video codec '$inputFileCodec' in file '$inputFile' is not compatible with codec '$firstFileCodec'."
            return
        }
    }

    # Merge the files
    $inputFilesList = ($InputFiles | ForEach-Object { "file '$($_)'" }) -join "`n"
    $tempListFile = New-TemporaryFile
    Set-Content -LiteralPath $tempListFile.FullName -Value $inputFilesList
    ffmpeg -f concat -safe 0 -i $tempListFile.FullName -c copy $OutputFile -y

    # Clean up
    Remove-Item -LiteralPath $tempListFile.FullName
}

function Generate-TsMergePowerShellFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypeList,
        [Parameter(Mandatory=$true)]
        [string]$TxtPrefix,
        [Alias("o")]
        [switch]$Overwrite,
        [Alias("a")]
        [switch]$Append
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    $srcTxtFile = Get-SourceTextFile $WorkingDir $TxtPrefix
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $false
    }
    # Check if the merge PowerShell file already exists
    $mergePs1FilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $ts_merge_ps1_prefix $srcTxtFile
    if (!$mergePs1FilePath -or !(Test-Path -LiteralPath $mergePs1FilePath -IsValid)) {
        Write-Warning "mergePs1FilePath not valid :$mergePs1FilePath."
        return $false
    }
    Check-FileOverideOrAppend -FilePath $mergePs1FilePath -Overwrite:$Overwrite -Append:$Append

    # Read the source text file content
    $srcContent = Get-Content -LiteralPath $srcTxtFile.FullName 

    $clipCount = 1

    $copyTargetFile = $null
    $tsTargetFile = $null
    $tsMergeFile = $null
    $copyCmd = $null
    $tsCmd = $null
    $merging = $false
	$ts_target_text_count_prefix = $null
	$ts_merge_output_count_prefix = $null
	$tsCount = 1
	$tsTargeFilePath  = $null
	
	foreach ($line in $srcContent) {
		Write-Debug "line:`n$line"
		if ($line -match $mergePs1IgnoreMergeChar) {						
			Write-Debug "# Ignore lines that start with: $ignoreMergeChar"
			continue
		} elseif ($line -match $spaceLineRegex){
			Write-Debug "# Ignore lines that are empty"
			continue
		} elseif ($line -match $mergeStartLine){
			# start of a ts merge group, create the list of input files
			if($merging){
				Write-Error "There are extra lines : $line"
				return $false 
			}
			$ts_target_text_count_prefix = "{0}{1}_" -f $ts_target_txt_prefix, ("{0:d3}" -f $tsCount)
			$tsTargeFilePath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $ts_target_text_count_prefix  $srcTxtFile  $txtExtention 
			Check-FileOverideOrAppend $tsTargeFilePath -o
			if (!$tsTargeFilePath -or !(Test-Path -LiteralPath $tsTargeFilePath -IsValid)) {
				Write-Warning "tsTargeFilePath not valid :$tsTargeFilePath."
				return $false
			}
			$tsTargetTxtFileName = Split-Path $tsTargeFilePath -Leaf
			$merging =  $true
			
		} elseif ($line -match $mergeEndLine){
			if(!$merging){
				Write-Error "There are extra lines : $line"
				return $false 
			}
			# end of a ts merge group, create the ts merge command

			$ts_merge_output_count_prefix = "{0}{1}_" -f $ts_merge_output_prefix, ("{0:d3}" -f $tsCount)			
			$tsMergeOutputPath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $ts_merge_output_count_prefix  $srcTxtFile $extension
			if (!$tsMergeOutputPath -or !(Test-Path -LiteralPath $tsMergeOutputPath -IsValid)) {
				Write-Warning "tsMergeOutputPath not valid :$tsMergeOutputPath."
				return $false
			}
			$tsMergedOutputName = Split-Path $tsMergeOutputPath -Leaf

			$tsMergeCmd = $tsMergeCmdTemplate -f $tsTargetTxtFileName,$tsMergedOutputName
			Add-Content -LiteralPath $mergePs1FilePath -Value $tsMergeCmd 

			$merging =  $false
			$tsCount++
			
		} elseif ($line -match $fileLineRegex) {
			# Check if the file name is of the correct type
			$fileName = $matches['FileName']
			$extension = $matches['Extension']
			Write-Debug "# extension: $extension"
			if ($VideoTypeList -notcontains $extension.ToLower()) {
				Write-Error "Error in file '${matches['FileName']}' with extension '${extension}' 
				not in the video type list."
				return $false
			}
			# Update the current video file
			$currentVideoFile =$line.Trim().Substring(1)
			Write-Debug "# currentVideoFile: $currentVideoFile"
		} elseif ($line -match $timeLineRegex) {
			# Append the input file to the ts merge list
			$tsInputCountFileName = "{0}{1}_{2}" -f $videoClipPrefix, ("{0:d3}" -f $clipCount), $currentVideoFile
			# $tsInputFilePath = Join-Path -Path $WorkingDir -ChildPath $tsInputCountFileName
			$ts_copy_count_output_prefix =  "{0}{1}_" -f $ts_tmp_ts_prefix, ("{0:d3}" -f $clipCount)
			$tsCopyOutputPath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $ts_copy_count_output_prefix $srcTxtFile $tsExtention
			if (!$tsCopyOutputPath -or !(Test-Path -LiteralPath $tsCopyOutputPath -IsValid)) {
				Write-Warning "tsCopyOutputPath not valid :$tsCopyOutputPath."
				return $false
			}
			$tsCopyOutputName = Split-Path $tsCopyOutputPath -Leaf
			
			$tsCopyCmd = $tsCopyCmdTemplate -f $tsInputCountFileName, $tsCopyOutputName
			
			Add-Content -LiteralPath $mergePs1FilePath -Value $tsCopyCmd 
			
			Write-Debug "  Add-Content -LiteralPath "
			Write-Debug "$tsTargetTxtFileName "
			Write-Debug "($concatTargetFileTemplat -f $tsCopyOutputName)"
            Add-Content -LiteralPath $tsTargeFilePath ($concatTargetFileTemplat -f $tsCopyOutputName)
			
			$clipCount++
		} else {
			Write-Error "There is an illegal line in the source text file: $line"
			return $false
		}
	}
	return $true
}


function Move-ByTypeAndPrefix {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -LiteralPath $_ -PathType 'Container'})]
        [string]$SourceDirectory,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -LiteralPath $_ -IsValid})]
        [string]$DestinationDirectory,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$FileTypeList,

        [Parameter()]
        [array]$IncludePrefix,

        [Parameter()]
        [array]$ExcludePrefix,
		[Alias("o")]
        [switch]$Overwrite
    )

    # Check if destination directory exists, create it if needed
    if (!(Test-Path -LiteralPath $DestinationDirectory) -or !(Test-Path -LiteralPath $DestinationDirectory -PathType 'Container')) {
        Write-Host "The destination directory '$DestinationDirectory' does not exist."
        $createDirectory = Read-Host "Do you want to create it? (y/n)"
        if ($createDirectory.ToLower() -eq "y") {
            New-Item -ItemType Directory -Path $DestinationDirectory 
        } else {
            Write-Host "Aborting operation."
            return $false
        }
    }

    # Get files to move
    $files = Get-CertainFilesInDir $SourceDirectory $FileTypeList $IncludePrefix $ExcludePrefix

    # Move files
    if ($files.Count -gt 0) {
        Write-Host "|Files to move: "
        Format-VedioFileInfo $files

        foreach ($file in $files) {
			$desPath = Join-Path $DestinationDirectory $file.Name
			if (!$Overwrite -and (Test-Path -LiteralPath $desPath)) {
				$confirmMessage = "The path '$desPath' already exists. Do you want to overwrite it?y/n, case insensitive."
				$overwrite = Read-Host -Prompt $confirmMessage
				if ($overwrite.ToLower() -eq "y") {
					Move-Item -LiteralPath $file.FullName -Destination $DestinationDirectory -Force
				} else {
					Write-Host "File not move."
					return $false
				}
			} else {
				Move-Item -LiteralPath $file.FullName -Destination $DestinationDirectory -Force:$Overwrite
			}
        }
        Write-Host "Moved $($files.Count) files from directory '$SourceDirectory' to directory '$DestinationDirectory'."
    } else {
        Write-Host "No files to move in directory '$SourceDirectory'."
    }
    return $true
}

enum OperationType {
    MoveTo
    PermanentDelete
    RemoveToRecycleBin
}

function Do-Operation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [Parameter(Mandatory=$true)]
        [OperationType]$OperationType,
        [string]$DesDirectory,
		[Alias("c")]
        [switch]$CreateDes
		
    )

    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
	if (!(Test-Path -LiteralPath $FilePath)){
		Write-Warning "The file '$FilePath' does not exist or has already been moved or removed."
		return $false
	}
    $file = Get-Item  -LiteralPath $FilePath
	Write-Debug "file : $file"
    $fileName = $file.Name

    switch ($OperationType) {
        ([OperationType]::MoveTo) {
			Write-Debug " Now in OperationType::MoveTo "
			if (!$DesDirectory ){
				Write-Error "The destination directory '$DesDirectory' does not passed."
				return $false
			}
			if ((Test-Path -LiteralPath $DesDirectory -IsValid)){
				if (!(Test-Path -LiteralPath $DesDirectory -PathType 'Container')){
					if ($Create) {
						Write-Warning "The destination directory '$DesDirectory' does not exist. Creating it now."
						New-Item -ItemType Directory -Path $DesDirectory 
					} else {
						$createDir = Read-Host "The destination directory '$DesDirectory' does not exist. Do you want to create it? [Y/n]"
						if ($createDir.ToLower() -eq "y") {
							New-Item -ItemType Directory -Path $DesDirectory 
						} else {
							return $false
						}
					}
				}
				Move-Item -LiteralPath $file.FullName -Destination $DesDirectory 
				Write-Debug "Move-Item -Path  $($file.FullName) -Destination $DesDirectory "
				return $true
				
			}else {
				Write-Error "$DesDirectory  is null or not valid" 
				return $false
			}

        }
        ([OperationType]::PermanentDelete) {
            Remove-Item -LiteralPath $file.FullName -Force
        }
        ([OperationType]::RemoveToRecycleBin) {
            Remove-Item-ToRecycleBin-LiteralPath -Path $file.FullName
        }
    }
    return $true
}

enum OperationTarget {
    CutClipVideo
    ConcatMergeVideo
    TsMergeVideo
    OriginVideo
}

function Post-ProcessingBySrcTxt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypeList,
        [Parameter(Mandatory=$true)]
        [string]$TxtPrefix,
        [Parameter(Mandatory=$true)]
        [string]$DesDirectory,
        [Parameter(Mandatory=$true)]
        [OperationTarget]$OpTarget,
        [Parameter(Mandatory=$true)]
        [OperationType]$OpType,
        [Alias("o")]
        [switch]$Overwrite,
		[Alias("c")]
        [switch]$Create,
        [Alias("a")]
        [switch]$Append
    )

    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    # Read the source text file content
    $srcTxtFile = Get-SourceTextFile $WorkingDir $TxtPrefix
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $false
    }
    $srcContent = Get-Content -LiteralPath $srcTxtFile.FullName 

    $currentDesDirectory = $null
    $clipCount = 1
    $merging = $false
	$mergeCount = 1
	$extension = $null
	$currentVideoFile = $null
		
    foreach ($line in $srcContent) {
			Write-Debug "line:`n$line"
		if ($line -match $postProcessIgnoreMergeChar) {						
			Write-Debug "# Ignore lines that start with: $postProcessIgnoreMergeChar"
			continue
		} elseif ($line -match $spaceLineRegex){
			Write-Debug "# Ignore lines that are empty"
			continue
		} elseif ($line -match $mergeStartLine){
			# start of a ts merge group, create the list of input files
			if($merging){
				Write-Error "There are extra lines : $line"
				return $false 
			}
			$merging =  $true
		} elseif ($line -match $mergeEndLine){
			if(!$merging){
				Write-Error "There are extra lines : $line"
				return $false 
			}
			if ( ($OpTarget -eq [OperationTarget]::TsMergeVideo ) -or ($OpTarget -eq [OperationTarget]::ConcatMergeVideo )) {
					switch ($OpTarget) {
					([OperationTarget]::TsMergeVideo) {
						$merge_output_count_prefix = "{0}{1}_" -f $ts_merge_output_prefix, ("{0:d3}" -f $mergeCount)			
						}
					([OperationTarget]::ConcatMergeVideo) {
						$merge_output_count_prefix =  "{0}{1}_" -f $concat_output_prefix, ("{0:d3}" -f $mergeCount)
					}		
				}
				$mergeOutputPath = Get-FilePathBaseSrcText $WorkingDir $TxtPrefix $merge_output_count_prefix  $srcTxtFile  $extension 					
				if (!$mergeOutputPath -or !(Test-Path -LiteralPath $mergeOutputPath -IsValid)) {
					Write-Warning "mergeOutputPath not valid :$mergeOutputPath."
					return $false
				}
				Do-Operation $mergeOutputPath $OpType $currentDesDirectory -c
			}

			# end of a ts merge group, create the ts merge command
			$merging =  $false
			$mergeCount++
			
		} elseif ($line -match $directoryNameLine) {
			if ($OpType -eq [OperationType]::MoveTo) {
				$quotedContent = $matches[1]
				if ($quotedContent -eq $wait_in_dir_name){
					$currentDesDirectory =  $DesDirectory
				}else{
					$currentDesDirectory = Join-Path -Path $DesDirectory -ChildPath $quotedContent
				}
				Write-Debug "currentDesDirectory $currentDesDirectory"
				if (!(Test-Path -LiteralPath $currentDesDirectory -IsValid)) 
				{
					Write-Error "The destination directory '$currentDesDirectory' is not exist valid."
					$currentDesDirectory = $null
					continue
				}
				Write-Debug "currentDesDirectory $currentDesDirectory"
				if (!(Test-Path -LiteralPath $currentDesDirectory)){
					if ($Create) {
						Write-Warning "The destination directory '$currentDesDirectory' does not exist. Creating it now."
						New-Item -ItemType Directory -Path $currentDesDirectory 
					} else {
						$createDir = Read-Host "The destination directory '$currentDesDirectory' does not exist. Do you want to create it? [Y/n]"
						if ($createDir.ToLower() -eq "y") {
							New-Item -ItemType Directory -Path $currentDesDirectory 
						} else {
							return $false
						}
					}
				}
			} else {
				Write-Debug "OpType skip [ $line  ]."
			}
        } elseif ($line -match $fileLineRegex) {
            # Check if the file name is of the correct type
			$fileName = $matches['FileName']
			$extension = $matches['Extension']
			$currentVideoFile =$line.Trim().Substring(1)
			Write-Debug "currentVideoFile :# fileName: $fileName  # extension: $extension"
			if ($VideoTypeList -notcontains $extension.ToLower()) {
				Write-Error "Error in file '${matches['FileName']}' with extension '${extension}' not in the video type list."
				return $false
			}
			
			if($OpTarget -eq [OperationTarget]::OriginVideo) {
				$srcVideoFilePath = Join-Path $WorkingDir $currentVideoFile
				if (Test-Path -LiteralPath $srcVideoFilePath){
					Write-Debug "# srcVideoFilePath: $srcVideoFilePath"
					Do-Operation $srcVideoFilePath $OpType $currentDesDirectory -c
				}else{
					Write-Host  "# srcVideoFilePath:[ $srcVideoFilePath] already move or removed."
				}

			}else {
				Write-Debug  "skip file line $line"
			}
        } elseif ($line -match $timeLineRegex) {
				# Check if the file name is of the correct type
				if($OpTarget -eq [OperationTarget]::CutClipVideo) {
					$ClipFileName = '{0}{1}_{2}' -f $videoClipPrefix, ("{0:d3}" -f $clipCount), $currentVideoFile
					$ClipVedioPath = Join-Path $WorkingDir $ClipFileName
					if (!$ClipVedioPath -or !(Test-Path -LiteralPath $ClipVedioPath -IsValid)) {
						Write-Warning "tsCopyOutputPath not valid :$tsCopyOutputPath."
                    return $false
					}
					Do-Operation $ClipVedioPath $OpType $currentDesDirectory -c
				}else {
					Write-Debug  "skip clip file line $line"
				}               
				$clipCount++
		} else {
			Write-Error "There is an illegal line in the source text file: $line"
			return $false
		}
	}
	return $true
}


function Remove-FilesWithPrefix {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string]$Prefix,
        [Parameter(Mandatory=$true)]
        [int]$TimelineCount
    )

    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    $clipCount = 1
    $foundFiles = $true

    while ($foundFiles) {
        $currentClipCount = "{0:d3}" -f $clipCount
        $currentPrefix = '{0}{1}_' -f $Prefix, $currentClipCount
        $filesToRemove = Get-ChildItem -LiteralPath $WorkingDir -Filter "$currentPrefix*"

        if ($filesToRemove) {
            foreach ($file in $filesToRemove) {
                $fileCount = [int]($file.Name -replace "^$currentPrefix(\d+).*$",'$1')
                if ($fileCount -gt $TimelineCount) {
                    if ($OpTarget -eq [OperationTarget]::PermanentDelete) {
                        Remove-Item -LiteralPath $file.FullName -Force -Confirm:$false
                    } else {
                        Move-Item -LiteralPath $file.FullName -Destination $RecycleBinPath -Force
                    }
                }
            }
            $clipCount++
        } else {
            $foundFiles = $false
        }
    }

    return $true
}

function Romove-BiggerClipCountBySrcTxt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkingDir,
        [Parameter(Mandatory=$true)]
        [string]$TxtPrefix,
        [Parameter(Mandatory=$true)]
        [OperationType]$OpType
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    # Read the source text file content
    $srcTxtFile = Get-SourceTextFile $WorkingDir $TxtPrefix
    if (!$srcTxtFile) {
        Write-Warning "No source text file found with prefix '${TxtPrefix}' in directory '${WorkingDir}'."
        return $false
    }
    $srcContent = Get-Content -LiteralPath $srcTxtFile.FullName 

    $clipCount = 0


    # Count the number of clips
    foreach ($line in $srcContent) {
        if ($line -match $timeLineRegex) {
            $clipCount++
        }
    }

    Write-Debug "Clip count: $clipCount"
    $fileCount = $clipCount
    # Remove files with the given prefix and count greater than the clip count
    do {
        $fileCount++
        $fileToRemove = '{0}{1}_*' -f $videoClipPrefix, ("{0:d3}" -f $fileCount), '*'
        $files = Get-ChildItem $WorkingDir -Filter $fileToRemove -File
        if ($files.Count -eq 1 -and $fileCount -gt $clipCount) {
            Write-Host "Removing $($files.Count) files: $($files.FullName)"
            foreach ($file in $files) {
                switch ($OpType) {
                    ([OperationType]::PermanentDelete) {
                        Remove-Item -LiteralPath $file.FullName -Force
                    }
                    ([OperationType]::RemoveToRecycleBin) {
                        Remove-Item-ToRecycleBin-LiteralPath -Path $file.FullName
                    }
                }
            }
        }
    } while ($files.Count -gt 0)

    return $true
}


function Auto-SplitVideo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SrcDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypes,
		[Alias("n")]
		[switch]$NotCopy,
		[Alias("q")]
		[switch]$Quiet,
		[Alias("s")]
		[switch]$SplitScene
    )
	
    # Check if Scenedetect is installed
    if (!(Get-Command scenedetect -ErrorAction SilentlyContinue)) {
        Write-Error "Scenedetect is not installed. Install Python and run 'pip install scenedetect' to install Scenedetect."
        return $false
    }
	
    Write-Host "Splitting videos in '$SrcDir' using scenedetect method"
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
	
    $videoFiles = Get-CertainFilesInDir $SrcDir $VideoTypes
	Write-Debug "Get-CertainFilesInDir $SrcDir $VideoTypes"
    if (!$videoFiles) {
        Write-Warning "No video files found in '$SrcDir'"
        return $false
    }
	
    foreach ($file in $videoFiles) {
		if($NotCopy) {
			$OpType = "NotCopy" 
		}else{
			$OpType = "Copy"
		}
		if(!$SplitScene){
			$fileName = $file.Name
			$match = [regex]::Match($fileName, "^(.*)(-Scene-\d{3})(\.[a-zA-Z0-9]+)`$")
			if ($match.Success) {
				Write-Debug "file:[$file] is a split video, skip"
				continue
			}
		}
		$outputDir = Join-Path $file.Directory.FullName ($file.Name + "_" + $OpType.ToString())
		$extension = $file.extension
        if (!(Test-Path -LiteralPath $outputDir -PathType Container)) {
            New-Item -ItemType Directory -Path $outputDir 
        }
		
		#$outputTemplate = Join-Path $outputDir "$($file.Name)_scene_%03d.${extension}"
		$scenedetectCommand = "scenedetect -i '$($file.FullName)' -o '$outputDir' detect-content split-video"
		if($Quiet) {
			$scenedetectCommand += " -q"
		}
		if(!$NotCopy) {
			$scenedetectCommand += " --copy"
		}
		Write-Debug "scenedetectCommand $scenedetectCommand"
		Invoke-Expression $scenedetectCommand  -ErrorAction Stop		
    }
}

function Get-MostCommonPrefix {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.IO.FileInfo[]]$FilePaths
    )

    # Find the shortest file name
	$commonPrefix = ""
	
	foreach ($charIndex in 0..($FilePaths[0].BaseName.Length - 1)) {
		$char = $FilePaths[0].BaseName[$charIndex]
		$match = $true

		foreach ($file in $FilePaths) {
			if ($file.BaseName.Length -le $charIndex -or $file.BaseName[$charIndex] -ne $char) {
				$match = $false
				break
			}
		}
		if (!$match) {
			break
		}

		$commonPrefix += $char
	}
    return $commonPrefix
}

enum MergeMethod {
	Concat
	TS
}

function Auto-MergeVideos {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SrcDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypes,
        [Parameter(Mandatory=$true)]
        [MergeMethod]$MergeMethod,
        [string[]]$IncludePrefix,
        [string[]]$ExcludePrefix
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    # Get the full path of SrcDir
    $srcDirPath = Get-Item -LiteralPath $SrcDir -ErrorAction SilentlyContinue 
    if (-not $srcDirPath) {
        Write-Warning "Could not find directory '$SrcDir'"
        return $false
    }

    # Get all subdirectories in the source directory and append the source directory itself to the list
    $dirs = Get-ChildItem -LiteralPath $srcDirPath -Directory -Recurse 
    $dirs += $srcDirPath
	Write-Debug "dirs $dirs"
    # Process each directory
    foreach ($dir in $dirs) {
        # Get all video files in the directory that match the specified types and prefixes
        $videoFiles = Get-CertainFilesInDir -LiteralPath $dir.FullName -TypeList $VideoTypes -IncludePrefix $IncludePrefix -ExcludePrefix $ExcludePrefix -NotRecurse
        if (-not $videoFiles) {
            Write-Verbose "No video files found in '$dir'"
            continue
        }
        # Call the appropriate merge method for the specified merge method type
        if ($MergeMethod -eq [MergeMethod]::Concat) {
            Auto-ConcatMerge -VideoFiles $videoFiles 
        }
        elseif ($MergeMethod -eq [MergeMethod]::TS) {
            Auto-TsMerge -VideoFiles $videoFiles 
        }
        else {
            Write-Error "Invalid merge method: $MergeMethod"
        }
    }

    return $true
}


function Get-SplitClipVideoFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path,
        [string[]]$TypeList,
        [string[]]$IncludePrefix,
        [string[]]$ExcludePrefix,
        [switch]$NotRecurse
    )

    $videoFiles = Get-CertainFilesInDir -LiteralPath $Path `
			-TypeList $TypeList `
			-IncludePrefix $IncludePrefix `
			-ExcludePrefix $ExcludePrefix `
			-NotRecurse:$NotRecurse
    # 过滤掉非split文件
    $videoFiles = $videoFiles | Where-Object { $_.Name -match '-Scene-\d{3}\.[a-zA-Z0-9]+$' }
    if (-not $videoFiles) {
        Write-Verbose "No video files found in '$Path'"
        return
    }
    return $videoFiles
}

function Get-NotSplitClipVideoFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path,
        [string[]]$TypeList,
        [string[]]$IncludePrefix,
        [string[]]$ExcludePrefix,
        [switch]$NotRecurse
    )

    $videoFiles = Get-CertainFilesInDir -LiteralPath $Path `
			-TypeList $TypeList `
			-IncludePrefix $IncludePrefix `
			-ExcludePrefix $ExcludePrefix `
			-NotRecurse:$NotRecurse
    # 过滤掉非split文件
    $videoFiles = $videoFiles | Where-Object { -not ($_.Name -match '-Scene-\d{3}\.[a-zA-Z0-9]+$') }
    if (-not $videoFiles) {
        Write-Verbose "No video files found in '$Path'"
        return
    }
    return $videoFiles
}


function Auto-MergeSplitVideos {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SrcDir,
        [Parameter(Mandatory=$true)]
        [string[]]$VideoTypes,
        [Parameter(Mandatory=$true)]
        [MergeMethod]$MergeMethod,
        [string[]]$IncludePrefix,
        [string[]]$ExcludePrefix
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    # Get the full path of SrcDir
    $srcDirPath = Get-Item -LiteralPath $SrcDir -ErrorAction SilentlyContinue 
    if (-not $srcDirPath) {
        Write-Warning "Could not find directory '$SrcDir'"
        return $false
    }

    # Get all subdirectories in the source directory and append the source directory itself to the list
    $dirs = Get-ChildItem -LiteralPath $srcDirPath -Directory -Recurse 
    $dirs += $srcDirPath
	Write-Debug "dirs $dirs"
    # Process each directory
    foreach ($dir in $dirs) {
        # Get all video files in the directory that match the specified types and prefixes
		$videoFiles = Get-SplitClipVideoFiles -Path $dir.FullName `
					-TypeList $VideoTypes `
					-IncludePrefix $IncludePrefix `
					-ExcludePrefix $ExcludePrefix `
					-NotRecurse
        # Call the appropriate merge method for the specified merge method type
		if($videoFiles.Count -gt 0){
			if ($MergeMethod -eq [MergeMethod]::Concat) {
				Auto-ConcatMerge -VideoFiles $videoFiles 
			}
			elseif ($MergeMethod -eq [MergeMethod]::TS) {
				Auto-TsMerge -VideoFiles $videoFiles 
			}
			else {
				Write-Error "Invalid merge method: $MergeMethod"
			}
		}else{
			Write-Host "The directory [$dir] does not have directly split videos to merge."
		}

    }

    return $true
}

function Auto-ConcatMerge {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.IO.FileInfo[]]$VideoFiles
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    # Check if there are at least 2 video files
    if ($VideoFiles.Count -lt 2) {
        Write-Warning "Less than 2 video files to merge. Exiting."
        return $false
    }

    # Get the most common prefix of the video files
    $commonPrefix = Get-MostCommonPrefix -FilePaths ($VideoFiles.FullName)

    # Get the directory of the video files
    $dir = Split-Path -Path $VideoFiles[0].FullName

    # Get the extension of the first video file
    $extension = [System.IO.Path]::GetExtension($VideoFiles[0].FullName)

    # Check if all video files have the same extension
    foreach ($file in $VideoFiles) {
        if ([System.IO.Path]::GetExtension($file.FullName) -ne $extension) {
            Write-Error "All video files must have the same extension. Exiting.Error in $file"
			Write-Error "$VideoFiles"
            return $false
        }
    }
    # Generate the output file name
    $outputFile = Join-Path $dir "$auto_concat_output_prefix$commonPrefix$extension"

    # Generate the file that will be read by ffmpeg concat merge
    $targetFile = Join-Path $dir "$auto_concat_target_text_prefix$commonPrefix.txt"
	Check-FileOverideOrAppend $targetFile -o
    
	# Generate the powershell file that will be used to merge the videos
    $ps1File = Join-Path $dir "$auto_concat_merge_ps1_prefix$commonPrefix.ps1"
	Check-FileOverideOrAppend $ps1File -o
    
	# Output each video file path to a text file
    #$VideoFiles.FullName | ForEach-Object { "file '{0}'" -f $_ } | Out-File -LiteralPath $targetFile #will be error with encoding.
	$VideoFiles.FullName | ForEach-Object { "file '{0}'" -f $_ } | Add-Content -LiteralPath $targetFile

    # Generate the ffmpeg concat merge command
    $cmd = $concatMergeCmdTemplate -f $targetFile, $outputFile

    # Write the ffmpeg command to a powershell file
    $cmd | Add-Content -LiteralPath $ps1File

    # Check if the powershell file exists, and execute it
    if (Test-Path -LiteralPath $ps1File) {
        & $ps1File
    } else {
        Write-Error "PowerShell merge file '$ps1File' does not exist."
        return $false
    }

    return $true
}

function Auto-TsMerge {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.IO.FileInfo[]]$VideoFiles
    )

    # Check if there are at least 2 video files
    if ($VideoFiles.Count -lt 2) {
        Write-Warning "Less than 2 video files to merge. Exiting."
        return $false
    }

    # Get the extension of the first video file
    $extension = [System.IO.Path]::GetExtension($VideoFiles[0].FullName)

    # Check if all video files have the same extension
    foreach ($file in $VideoFiles) {
        if ([System.IO.Path]::GetExtension($file.FullName) -ne $extension) {
            Write-Error "All video files must have the same extension. Exiting.Error in $file"
			Write-Error "$VideoFiles"
            return $false
        }
    }

    # Get the most common prefix of the video files
    $commonPrefix = Get-MostCommonPrefix -FilePaths $VideoFiles.FullName

    # Get the directory of the video files
    $dir = Split-Path -Path $VideoFiles[0].FullName
	
    # Generate the file that will be read by ffmpeg concat merge
    $targetFile = Join-Path $dir "$auto_ts_merge_output_prefix$commonPrefix.txt"
	Check-FileOverideOrAppend $targetFile -o
    
    # Generate the output file name
    $outputFile = Join-Path $dir "$auto_ts_merge_output_prefix$commonPrefix.${extension}"
	
    # Generate the powershell file that will be used to merge the videos
    $ps1File = Join-Path $dir "$auto_ts_merge_ps1_prefix$commonPrefix.ps1"
	Check-FileOverideOrAppend $ps1File -o
    # Generate the output directory for the temporary ts files
    $tmpTsOutputDir = Join-Path $dir "ts_temp"
    if (!(Test-Path -LiteralPath $tmpTsOutputDir)) {
        New-Item -ItemType Directory -Path $tmpTsOutputDir | Out-Null
    }

    # Copy each video file to a temporary ts file
    $tsFiles = @()
    foreach ($file in $VideoFiles) {
        $tsFile = Join-Path $tmpTsOutputDir "$auto_ts_tmp_ts_prefix$($file.Name).${tsExtention}"

        $tsFiles += $tsFile
        $tsCmd = $tsCopyCmdTemplate -f $file.FullName, $tsFile
        Write-Debug "tsCmd: $tsCmd"
		$tsCmd | Add-Content -LiteralPath $ps1File
		Add-Content -LiteralPath $targetFile ($concatTargetFileTemplat -f $file.FullName)
    }
	
    # Generate the ffmpeg concat merge command
    $cmd = $tsMergeCmdTemplate -f $targetFile ,$outputFile

    # Write the ffmpeg command to a powershell file
    $cmd | Add-Content -LiteralPath $ps1File

    # Check if the powershell file exists, and execute it
    if (Test-Path -LiteralPath $ps1File) {
        & $ps1File
    } else {
        Write-Error "PowerShell merge file '$ps1File' does not exist."
        return $false
    }

    # Remove temporary ts files
    Remove-Item -LiteralPath $tmpTsOutputDir -Recurse

    return $true
}

function Get-ClipOutputRename([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${videoClipPrefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[2].Value)$($match.Groups[1].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}

function Remove-ClipOutputPrefix([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${videoClipPrefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}

function Get-ConcatMergeRename([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${concat_output_prefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[2].Value)$($match.Groups[1].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}

function Get-TsMergeOutputRename([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${ts_merge_output_prefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[2].Value)$($match.Groups[1].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}

function Remove-ConcatMergePrefix([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${concat_output_prefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}

function Remove-TsMergePrefix([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${ts_merge_output_prefix}\d{3})(_)(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[3].Value)$($match.Groups[4].Value)"
    }
    else {
        return $fileName
    }
}

function Remove-AutoConcatMergePrefix([string]$fileName) {
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }
    $match = [regex]::Match($fileName, "(^${auto_concat_output_prefix})(.*)(\.[a-zA-Z0-9]+)`$")
    if ($match.Success) {
        return "$($match.Groups[2].Value)$($match.Groups[3].Value)"
    }
    else {
        return $fileName
    }
}

# # Rename all files in the current directory using the Get-ClipOutputRename function
# Rename-ByTypeAndRegex -RenameFunction { param($fileName) Get-ClipOutputRename $fileName }

# # Rename all mp4 files in the specified directory using the Get-ClipOutputRename function
# Rename-ByTypeAndRegex -SourceDirectory "C:\Path\To\Directory" -FileTypeList @("*.mp4") -RenameFunction { param($fileName) Get-ClipOutputRename $fileName }

function Rename-ByTypeAndRegex {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$RenameFunction,
        [Parameter()]
        [ValidateScript({Test-Path -LiteralPath $_ -PathType 'Container'})]
        [string]$SourceDirectory = $PSScriptRoot,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [array]$FileTypeList
    )
    Write-Host "$($MyInvocation.MyCommand.Name) "
    Write-Debug "Parameters:"
    foreach ($key in $PSBoundParameters.Keys) {
        Write-Debug "$key : $($PSBoundParameters[$key])"
    }

    if (-not $FileTypeList) {
        $files = Get-ChildItem $SourceDirectory -Recurse
    }
    else {
        $files = Get-CertainFilesInDir $SourceDirectory $FileTypeList
    }

    if ($files.Count -gt 0) {
        Write-Host "Renaming $($files.Count) files in directory '$SourceDirectory'."
        foreach ($file in $files) {
            $newName = & $RenameFunction $file.Name
            if ($newName -eq $file.Name) {
                Write-Host "$file not match ${RenameFunction.Name}"
                continue
            }
		
            $newFullName = Join-Path $file.DirectoryName $newName

            if (Test-Path $newFullName) {
                $overwrite = Read-Host "File '$newName' already exists. Do you want to overwrite it? (y/n)"
                if ($overwrite.ToLower() -eq 'y') {
					Write-Debug "Move-Item -LiteralPath $($file.FullName) -Destination $newFullName -Force"
                    Move-Item -LiteralPath $file.FullName -Destination $newFullName -Force
                }else{
					Write-Host " $file not move"
				}
            } else {
                Move-Item -LiteralPath $file.FullName -Destination $newFullName
				Write-Debug "Move-Item -LiteralPath $($file.FullName) -Destination $newFullName -Force"
            }
            Write-Host "Renamed file '$($file.FullName)' to '$newName'."
        }
    } else {
        Write-Host "No files to rename in directory '$SourceDirectory'."
    }
}


