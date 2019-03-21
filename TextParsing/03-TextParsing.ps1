$Content = Get-Content C:\users\Ryan2\Downloads\setupact.log

$Content[100]

$LogLine = $Content[100]

$strTime, $LogLine = $LogLine -Split '^'

$strTime, $LogLine = $LogLine -Split ',',2

$LogLine

$Level, $LogLine = $LogLine.Trim() -Split ' ',2

$LogLine = $LogLine.Trim()

If($LogLine.StartsWith('[0x')){
    $ErrorCode, $LogLine = $LogLine -Split ' ', 2
    $LogLine = $LogLine.Trim()
}

$tempComponent, $tempLogLine = $LogLine -Split ' ', 2

if($tempComponent -cmatch '^[A-Z]*$'){
    $Component = $tempComponent
    $LogLine = $tempLogLine
}
$Message = $LogLine.Trim()

Class PantherLogLine{
    [DateTime]$Time
    [String]$Level
    [String]$ErrorCode
    [String]$Component
    [String]$Message
    PantherLogLine($LogLine){

        $strTime, $LogLine = $LogLine -Split ',',2
        $this.Time = Get-Date $strTime

        $this.Level, $LogLine = $LogLine.Trim() -Split ' ',2
        $LogLine = $LogLine.Trim()
    
        If($LogLine.StartsWith('[0x')){
            $this.ErrorCode, $LogLine = $LogLine -Split ' ', 2
            $LogLine = $LogLine.Trim()
        }
    
        $tempComponent, $tempLogLine = $LogLine -Split ' ', 2
        if($tempComponent -cmatch '^[A-Z]*$'){
            $this.Component = $tempComponent
            $LogLine = $tempLogLine
        }

        $this.Message = $LogLine.Trim()
    }
}

Foreach($line in $Content){
    if(-not [String]::IsNullOrEmpty($line)){
        [PantherLogLine]::new($line)
    }
}