$Content = Get-Content C:\users\Ryan2\Downloads\setupact.log

$ConvertFromString = {
    $Template = @"
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}       [{ErrorCode:0x0601d0}] {Component:IBS}    {Message:Build version is 10.0.14393.0 (rs1_release.160715-1616)}
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}       [{ErrorCode:0x064042}] {Component:IBSLIB} {Message:CreateSetupBlackboard:Creating new blackboard path is [C:\windows\Panther\SetupInfo] Setup phase is [4]}
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}                  {Component:IBS}    {Message:InstallWindows:No UI language from a previous boot was found on the blackboard. Using selected language [].}
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}                         {Message:[setup.exe] OrchestrateUpdateImageState: Updating image state from [IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE] --> [IMAGE_STATE_UNDEPLOYABLE]}
"@
    $Content | ConvertFrom-String -TemplateContent $Template
}

$TextParsing = {
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
}

$RegexParsing = {
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
}

Measure-CommandChart -ScriptBlocks @($ConvertFromString, $TextParsing, $RegexParsing) -ScriptBlockNames @('ConvertFromString','TextParsing','Regex') -Times 100
