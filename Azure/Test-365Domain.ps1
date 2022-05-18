function test-365domain {
<#
	.SYNOPSIS
		Test if a domain is already in use in an Azure tenant. Return tenant ID if it is.
	.EXAMPLE
        	test-365domain -domain "mydomain.com.au"
		Return tenant ID for the domain "mydomain.com.au" if it is already in use in an Azure tenancy.
#>
	Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[string]$domain
	)

	try {
		$openIdInfo = Invoke-RestMethod "https://login.windows.net/$($domain)/.well-known/openid-configuration" -Method GET
		"Domain $domain is in use. Tenant ID is:"
		return $openIdInfo.userinfo_endpoint.Split("/")[3]
	} catch {
		"Domain $domain is not used in any tenant"
	}
}