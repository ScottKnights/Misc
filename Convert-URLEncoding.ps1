function convert-urlencoding {
<#
	.SYNOPSIS
		Converts a URL to percent encoded and vice-versa. Conversion will depend on whether the URL contains a % sign.
	.EXAMPLE
        	.\convert-urlencoding -url "http://www.testurl.com/index.html"
		Converts "http://www.testurl.com/index.html" to "http%3a%2f%2fwww.testurl.com%2findex.html".

	.EXAMPLE
        	.\convert-urlencoding -url "http%3a%2f%2fwww.testurl.com%2findex.html"
		Converts "http%3a%2f%2fwww.testurl.com%2findex.html" TO "http://www.testurl.com/index.html".

#>
	param( 
		[Parameter(Mandatory=$true,position=0,ValueFromPipeline=$true)]
		[string]$url
	)
	Add-Type -AssemblyName System.Web
	if ($url -like "*%*") {
		[System.Web.HTTPUtility]::UrlDecode($url)
	} else {
		[System.Web.HTTPUtility]::UrlEncode($url)
	}
}