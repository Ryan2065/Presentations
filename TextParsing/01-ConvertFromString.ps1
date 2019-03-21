arp -a

$arpOutput = arp -a

$arpOutput | ConvertFrom-String

$arpOutput[3..($arpOutput.count-1)]

$arpOutput[3..($arpOutput.count-1)] | ConvertFrom-String

$arpOutput[3..($arpOutput.count-1)].Trim() | ConvertFrom-String

$arpOutput[3..($arpOutput.count-1)].Trim() | ConvertFrom-String -PropertyNames 'IPAddress','MAC','Type'

