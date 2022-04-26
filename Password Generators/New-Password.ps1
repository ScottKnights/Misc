function New-Password {
<#
	.SYNOPSIS
		Generate password from a word list. Pick random words (default 2) and add a random number up to 999 and a random symbol.
		EG RefreshEvolution580$
	.EXAMPLE
        	New-Password
#>

	Param(
		[int]$wordcount=2,
		[string]$wordfile="\\server\share\wordlist.txt"
	)
	
	$wordlist=Get-Content $wordfile
	$numwords=($wordlist.count)-1
	[string]$password=$null
	1..$wordcount|foreach-object {
		$random=get-random -maximum $numwords
		$word=$wordlist[$random]
		$word = $word.substring(0,1).toupper()+$word.substring(1)
		$password+=($word)
	}
	$random=('{0:d3}' -f (get-random -maximum 999))
	$password=$password+$random
	$symbols="[]{}()!@#$%*"
	$password=$password+$symbols[(get-random -Maximum ($symbols.length-1))]
	$password	
}
