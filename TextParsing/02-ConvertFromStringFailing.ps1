$Content = Get-Content C:\users\Ryan2\Downloads\setupact.log

$Content

$Content | ConvertFrom-String

$Content[0..20]

$Template = @"
{Time*:2019-02-26 02:07:16}, {Level:Info}       [{ErrorCode:0x0601d0}] {Component:IBS}    {Message:Build version is 10.0.14393.0 (rs1_release.160715-1616)}
{Time*:2019-02-26 02:07:16}, {Level:Info}       [{ErrorCode:0x064042}] {Component:IBSLIB} {Message:CreateSetupBlackboard:Creating new blackboard path is [C:\windows\Panther\SetupInfo] Setup phase is [4]}
{Time*:2019-02-26 02:07:16}, {Level:Info}                  {Component:IBS}    {Message:InstallWindows:No UI language from a previous boot was found on the blackboard. Using selected language [].}
{Time*:2019-02-26 02:07:16}, {Level:Info}                         {Message:[setup.exe] OrchestrateUpdateImageState: Updating image state from [IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE] --> [IMAGE_STATE_UNDEPLOYABLE]}
"@
$Content | ConvertFrom-String -TemplateContent $Template

$Template = @"
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}       [{ErrorCode:0x0601d0}] {Component:IBS}    {Message:Build version is 10.0.14393.0 (rs1_release.160715-1616)}
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}       [{ErrorCode:0x064042}] {Component:IBSLIB} {Message:CreateSetupBlackboard:Creating new blackboard path is [C:\windows\Panther\SetupInfo] Setup phase is [4]}
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}                  {Component:IBS}    {Message:InstallWindows:No UI language from a previous boot was found on the blackboard. Using selected language [].}
{[DateTime]Time*:2019-02-26 02:07:16}, {Level:Info}                         {Message:[setup.exe] OrchestrateUpdateImageState: Updating image state from [IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE] --> [IMAGE_STATE_UNDEPLOYABLE]}
"@
$Content | ConvertFrom-String -TemplateContent $Template