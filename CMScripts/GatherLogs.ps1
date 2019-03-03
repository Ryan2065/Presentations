Param(
    [ValidateSet('True','False')]
    [string]$CMClientLogs = 'True',
    [ValidateSet('True', 'False')]
    [string]$PantherLogs = 'True',
    [ValidateSet('True', 'False')]
    [string]$WindowsUpdateLogs = 'True',
    [string]$Destination = "\\TPLabPS1\ClientLogs"
)
$ErrorActionPreference = 'Stop'
Add-Type -Assembly 'System.IO.Compression.FileSystem'
if($CMClientLogs -eq 'True'){
    $ClientLogZipPath = "$($env:Temp)\CMClientLogs.zip"
    $LogPath = (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\CCM\Logging\@global' -Name 'LogDirectory' -ErrorAction Stop).LogDirectory
    $null = New-Item -ItemType Directory -Path "$($env:Temp)\CMClientLogs" -Force
    $null = Copy-Item -Path $LogPath -Destination "$($env:Temp)\CMClientLogs" -Force -Recurse
    $null = [IO.Compression.ZipFile]::CreateFromDirectory("$($env:Temp)\CMClientLogs", $ClientLogZipPath)
    If(-not (Test-Path "$($Destination)\$($env:ComputerName)")) { $null = New-Item -ItemType Directory -Path "$($Destination)\$($env:ComputerName)" }
    $null = Copy-Item -Path $ClientLogZipPath -Destination "$($Destination)\$($env:ComputerName)\" -Force
    $null = Remove-Item -Path $ClientLogZipPath -Force
    $null = Remove-item -Path "$($env:Temp)\CMClientLogs" -Force -Recurse
}
if($PantherLogs -eq 'True'){
    $null = [IO.Compression.ZipFile]::CreateFromDirectory("$($env:windir)\Panther","$($env:Temp)\Panther.zip")
    $null = Copy-Item -Path "$($env:Temp)\Panther.zip" -Destination "$($Destination)\$($env:ComputerName)\" -Force
    $null = Remove-Item -Path "$($env:Temp)\Panther.zip" -Force
}
if($WindowsUpdateLogs -eq 'True'){
    $null = New-item -ItemType Directory -Path "$($env:Temp)\WinUpdateLog" -Force
    $null = Get-WindowsUpdateLog -LogPath "$($env:Temp)\WinUpdateLog\WindowsUpdate.log"
    $null = [IO.Compression.ZipFile]::CreateFromDirectory("$($env:Temp)\WinUpdateLog","$($env:Temp)\WindowsUpdate.zip")
    Copy-Item -Path "$($env:Temp)\WindowsUpdate.zip" -Destination "$($Destination)\$($env:ComputerName)\" -Force
    Remove-Item -Path "$($env:Temp)\WindowsUpdate.zip" -Force
    Remove-Item -Path "$($env:Temp)\WinUpdateLog" -Force -Recurse
}