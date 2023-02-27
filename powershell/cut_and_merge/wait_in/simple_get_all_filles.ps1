# 简单地将脚本所在目录下的所有文件移动至当前目录。
# 可以直接复制扔在多个目录下使用，非常方便。
# 注意，这个脚本只是简单地移动文件，没有对文件进行复制或备份，也不处理重名冲突，
# 所以使用前请确定你清楚自己在做什么。



$files = Get-ChildItem -File -Recurse
#$files
$cur=Get-Location
foreach($file in $files)
{
	$srcPath=$file.fullname
	#$desPath=Join-Path 
	"src:"+$srcPath
	"des:"+$desPath
	Move-Item -LiteralPath $srcPath -Destination $cur
} 
