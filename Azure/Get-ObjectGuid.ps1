function get-objectguid {
<#
	.SYNOPSIS
		Get AD Object GUID from supplied Azure immutable ID 
	.EXAMPLE
        	get-objectguid -immutableid "uswWsE5OXEu6dNIkajgabw=="
		Converts immutable ID "uswWsE5OXEu6dNIkajgabw==" to "b016ccba-4e4e-4b5c-ba74-d2246a381a6f"
#>

	param(
		[Parameter(Mandatory=$true,position=0,ValueFromPipeline=$true)]
        	[string]$immutableid
	)
	[Guid]([Convert]::FromBase64String($immutableid))
}
