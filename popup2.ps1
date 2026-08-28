Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$messages = @(
    "insert"
    "different"
    "messages"
    "or"
    "affirmations"
    "like"
    "this"
)

$message = Get-Random -InputObject $messages

$wshell = New-Object -ComObject WScript.Shell
$wshell.Popup($message, 0, "this is the title of the popup box :D", 48)