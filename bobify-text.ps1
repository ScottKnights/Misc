# A commenter on a forum I post to appears to randomly capitalize words in his posts for no discernable reason.
# I decided to try write a function to convert text to give the "Bob Experience".
# Hmmmm. According to ScriptAnalyzer "bobify is an unapproved verb".

# Usage - bobify-text "Some text you want Bobifying" -bobfactor (0 - 5, default 1)
# Usage - bobify-text $text -bobfactor (0 - 5, default 1) # $text is a string variable containing text to bobify

function bobify-text {
	param (
	[Parameter()]
	[string] $text="Some default text I want to Bobify",

	[Parameter()]
	[int] $bobfactor=1
)

	# Split the text into an array of seperate words
	$array = $text -split " "

	# Each word has a Bobfactor in 5 chance of being 'Bobbed'. 0 = No bobification, 5 = Max bobification (actually anything >4)
	$newArray = @()
	foreach ($word in $array) {
		$random = Get-Random 5
		if ($random -lt $bobfactor) {
			$word = $word.ToUpper()
		}
		$newArray += $word
	}

	# Rejoin and return the text array. Capitalise the first letter.
	$outtext = $newArray -join ' '
	$outtext = $outtext.substring(0,1).toupper()+$outtext.substring(1)
	return $outtext
}
