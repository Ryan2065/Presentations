Class PantherLogLine{
    [DateTime]$Time
    [String]$Level
    [String]$ErrorCode
    [String]$Component
    [String]$Message
    PantherLogLine($LogLine){
    }
}


$Content = Get-Content C:\users\Ryan2\Downloads\setupact.log
$ErrorActionPreference = 'Continue'

$ManualSB = {
    Foreach($line in $Content) {
        if(![String]::IsNullOrEmpty($line)){
            $LogLine = $line
            $strTime, $LogLine = $LogLine -Split ',',2

            #$Time = Get-Date $strTime
            
            $Level, $LogLine = $LogLine.Trim() -Split ' ',2
            
            $LogLine = $LogLine.Trim()
            
            If($LogLine.StartsWith('[0x')){
                $ErrorCode, $LogLine = $LogLine -Split ' ', 2
                $ErrorCode = $ErrorCode.TrimStart('[').TrimEnd(']')
            }
            
            $LogLine = $LogLine.Trim()
            
            $tempComponent, $tempLogLine = $LogLine -Split ' ', 2
            
            if($tempComponent -cmatch '^[A-Z]*$'){
                $Component = $tempComponent
                $LogLine = $tempLogLine
            }
            $Message = $LogLine.Trim()
        }
    }
}

$RegexSB = { 
    Foreach($line in $Content) {
        if(![String]::IsNullOrEmpty($line)){
            $regex = '(?<Date>\d{4}-\d{2}-\d{2})\s+(?<Time>(\d{2}:)+\d{2}),\s+(?<Type>\w+)\s{1,17}(\[(?<ErrorCode>\w*)\])?(?<Component>\s\w+)?\s+(?<Message>.*)'
            $line -match $regex
        }
    }
}

Measure-CommandChart -ScriptBlocks @($ManualSB, $RegexSB) -ScriptBlockNames @('Manual', 'Regex') -Times 5000