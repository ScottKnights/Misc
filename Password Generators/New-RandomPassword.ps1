function New-RandomPassword {
<#
	.SYNOPSIS
		Generate a random password. Default length is 26 characters. Maximum length is 128 characters.
	.EXAMPLE
        	New-RandomPassword -length 40
		Generate a 40 character long random password.
#>
	param(
		[Parameter(position=0,ValueFromPipeline=$true)]
		[int]$PasswordLength = 26
	)
	if ($passwordLength -gt 128) {
		write-host "Password Length set to maximum of 128."
		[int]$PasswordLength=128
	}
	Add-Type -AssemblyName 'System.Web'
	$password = [System.Web.Security.Membership]::GeneratePassword($passwordlength,1)
	$password
}
