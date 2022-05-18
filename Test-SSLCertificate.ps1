function test-sslcertificate {
<#
	.SYNOPSIS
		Test validity of a certificate at a specified URL. Report if valid or expired and return validity in days.
		If only the FQDN is specified, https:// will be prepended to the URL. http:// will be converted to https://.
		Backslashes will be converted to forward slashes.
	.PARAMETER url
		Mandatory String. URL to test.
	.PARAMETER expiring
		Int. If validity in days is less than expiring, certificate status will be reported as expiring. Default is 60.
	.PARAMETER port
		Int. Port to test. Defaults to 443. Ignored if port specified in the URL.
	.EXAMPLE
        	test-sslcertificate "www.testurl.com"
		Test certificate at https://www.testurl.com
	.EXAMPLE
        	test-sslcertificate "http://www.testurl.com/mypage -port 4433
		Test certificate at https://www.testurl.com:4433
	.EXAMPLE
        	test-sslcertificate "http:\\www.testurl.com:8080" -port 4433
		Test certificate at https://www.testurl.com:8080
#>
	param (
		[Parameter(Mandatory=$true)]
		[string]$url,
		[Parameter(Mandatory=$false)]
		[int32]$expiring=60,
		[Parameter(Mandatory=$false)]
		[int32]$port=443
	)
	# Convert any backslashes to forward slashes and convert to lower case. Strip protocol type and any trailing part of the URL, just leaving the FQDN. 
	$url=$url.tolower()
	$url=$url.replace("\","/")
	if ($url -like "*://*") {
		$url=($url -split '://',2)[1]
	}
	$url=($url -split '/',2)[0]
	# Remove any remaining forward slashes
	$url=$url.replace("/","")
	# If the URL doesn't contain a port, append the port parameter
	if (-not ($url -like "*:*")) {
		$url=$url+":"+$port.tostring()
	}
	#Prepend the URL with HTTPS:// protocol
	$url="https://"+$url
	# Test if we can make a web request to the URL
	try {
		$ErrorActionPreference="Stop"	
		$req = [Net.HttpWebRequest]::Create($url)
	} catch {
		$ErrorActionPreference="Continue"
		write-warning "Unable to get certificate details for $url"
		return
	}
	# Get details from the certificate
	$date=get-date
	$req.AllowAutoRedirect = $false
	try {
		$req.GetResponse() | Out-Null
		$sdate=$req.ServicePoint.Certificate.GetEffectiveDateString()
		$edate=$req.ServicePoint.Certificate.GetExpirationDateString()
		$Issuer=$req.ServicePoint.Certificate.Issuer
		$Subject=$req.ServicePoint.Certificate.Subject
		$tp=$req.ServicePoint.Certificate.GetCertHashString()
		$serial=$req.ServicePoint.Certificate.GetSerialNumberString()
		$Cert = [Security.Cryptography.X509Certificates.X509Certificate2]$Req.ServicePoint.Certificate.Handle
		try {
			$SAN = ($Cert.Extensions | Where-Object {$_.Oid.Value -eq "2.5.29.17"}).Format(0)
		} catch {
			$SAN = $null
		}
		$span=new-timespan -start $date -end $edate
		$days=$span.days
		if ($days -lt $expiring) {
			$status="Expiring"
		} else {
			$status="OK"
		}
		write-output "Url		: $URL"
		write-output "Subject		: $subject"
		write-output "SANs		: $SAN"
		write-output "Issuer		: $Issuer"
		write-output "Serial		: $serial"
		write-output "Thumbprint	: $tp"
		write-output "Valid From	: $sdate"
		write-output "Valid To	: $edate"
		write-output "Validity (Days)	: $days"
		write-output "Validity Status	: $status"
	} catch {
		write-warning "Unable to get certificate details for $url"
	}
}