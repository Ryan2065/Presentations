Param(
    $Action,
    $ServiceName
)

if($Action -eq 'Stop') {
   Stop-Service $ServiceName
}
elseif($Action -eq 'Start') {
    Start-Service $ServiceName
}