function get-immutableid {
<#
	.SYNOPSIS
		Get Azure immutable ID from supplied AD Object GUID 
	.EXAMPLE
        	get-immutableid -objectguid "b016ccba-4e4e-4b5c-ba74-d2246a381a6f"
		Converts object guid "b016ccba-4e4e-4b5c-ba74-d2246a381a6f" to "uswWsE5OXEu6dNIkajgabw==" to 
#>
	param(
		[Parameter(Mandatory=$true,position=0,ValueFromPipeline=$true)]
        	[string]$objectguid
	)

	[Convert]::ToBase64String([guid]::New($objectguid).ToByteArray())
}