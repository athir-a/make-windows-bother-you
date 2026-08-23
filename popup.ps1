# The message you want to display
$message = "Your message goes here"

# Create a Windows popup
$wshell = New-Object -ComObject WScript.Shell

# Show the popup
$wshell.Popup($message, 0, "Your title here", 48)

# Icon options:
# 0  = No icon
# 16 = ❌ Critical / Stop
# 32 = ❓ Question
# 48 = ⚠️ Warning
# 64 = ℹ️ Information