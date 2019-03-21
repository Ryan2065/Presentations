$Content = Get-Content C:\users\Ryan2\Downloads\setupact.log

$LogLine = $Content[100]
$regex = '(?<Date>\d{4}-\d{2}-\d{2})\s+(?<Time>(\d{2}:)+\d{2}),\s+(?<Type>\w+)\s{1,17}(\[(?<ErrorCode>\w*)\])?(?<Component>\s\w+)?\s+(?<Message>.*)'
$LogLine -match $regex

Class PantherRegexLogLine{
    [DateTime]$Time
    [String]$Level
    [String]$ErrorCode
    [String]$Component
    [String]$Message
    PantherRegexLogLine($LogLine){
        $regex = '(?<Date>\d{4}-\d{2}-\d{2})\s+(?<Time>(\d{2}:)+\d{2}),\s+(?<Type>\w+)\s{1,17}(\[(?<ErrorCode>\w*)\])?(?<Component>\s\w+)?\s+(?<Message>.*)'
        if($LogLine -match $regex){
            $this.Time = Get-Date "$($Matches["Date"]) $($Matches["Time"])"
            $this.Level = $Matches["Type"]
            $this.ErrorCode = $Matches["ErrorCode"]
            $this.Component = $Matches["Component"]
            $this.Message = $Matches["Message"]
        }
    }
}

Foreach($line in $Content){
    if(-not [string]::IsNullOrEmpty($line)){
        [PantherRegexLogLine]::new($line)
    }
}