function New-WordPassword {
<#
	.SYNOPSIS
		Generate a readable password from a word list. Default number of words is 4.
	.EXAMPLE
        	New-WordPassword -wordcount 6
		Generate a 6 word password.
#>

	Param(
		[int]$wordcount=4,
		[string]$wordfile="\\server\share\wordlist.txt"
	)
	
	$wordlist=Get-Content $wordfile
	$numwords=($wordlist.count)-1
	[string]$password=$null
	1..$wordcount|foreach-object {
		$random=get-random -maximum $numwords
		$password+=($wordlist[$random]+" ")
	}
	$password=$password.trim()
	$password
}
