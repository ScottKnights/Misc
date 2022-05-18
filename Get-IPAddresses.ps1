function get-ipaddresses {
<#
	.SYNOPSIS
		Get all unique IP addresses from a specified file.
	.PARAMETER path
		Mandatory String. Path to log file.
	.PARAMETER ipv4only
		Switch. Only return IPV4 addresses
	.PARAMETER ipv6only
		Switch. Only return IPV6 addresses
	.EXAMPLE
        	get-ipaddresses -file ".\myipaddresses.log"
		Show all unique IP addresses in text file ".\myipaddresses.log"
	.EXAMPLE
        	get-ipaddresses -file ".\myipaddresses.log" -ipv4only
		Show all unique IPV4 addresses in text file ".\myipaddresses.log"
	.EXAMPLE
        	get-ipaddresses -file ".\myipaddresses.log" -ipv6only
		Show all unique IPV6 addresses in text file ".\myipaddresses.log"
#>
	Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[string]$file,
		[switch]$ipv4only,
		[switch]$ipv6only
	)
	[regex]$ipv4="\d{1,3}(\.\d{1,3}){3}"
	[regex]$ipv6="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$|^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$|^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?$"

	$ips=@()
	if (-not($ipv6only)) {
		$ips+=(get-content $file  |  Select-String -Pattern "$ipv4" -AllMatches).Matches.Value|select-object -unique|sort
	}
	if (-not($ipv4only)) {
		$ips+=(get-content $file  |  Select-String -Pattern "$ipv6" -AllMatches).Matches.Value|select-object -unique|sort
	}
	$ips=$ips.replace(" ","")
	return $ips
}