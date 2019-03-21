$Content = Get-Content .\TextParsing\statmgr.box\1feu2201.SVF

$Content.ToCharArray() | ForEach-Object {
    "$($_) = $([int]$_)"
}

$SplitString = $Content.Split([char]1)
$SplitString[$SplitString.Count -1 ].ToCharArray() | ForEach-Object {
    "$($_) = $([int]$_)"
}

$SplitString[$SplitString.Count - 1].Split([char]0)