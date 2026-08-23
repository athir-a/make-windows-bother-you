# Make Windows Bother You with PowerShell and Task Scheduler

A small Windows automation project that lets you throw custom popup messages onto your desktop using **PowerShell** and **Task Scheduler**.

Set a message, pick when you want it to show up. You can use it for reminders, alarms, motivational messages, break reminders, random nonsense, or just harmless little prank to freak a friend out.

No extra apps, no complicated setup, just some PowerShell and tools that are already built into Windows.

## What It Looks Like in Action

<img width="1614" height="912" alt="Screenshot 2026-08-23 150608" src="https://github.com/user-attachments/assets/3d40e804-d0c6-455b-9935-fcedf73b7bc3" />

---
# 🛠️ Setting Up Your Popup

This project uses two things that already come with Windows:

* **PowerShell** — runs the script that creates the popup
* **Task Scheduler** — decides when the script should run

You don't need to install anything.

The basic idea is:

```text
Task Scheduler
      ↓
runs your PowerShell script
      ↓
PowerShell tells Windows to show a popup
```

---

# 1. Create Your PowerShell Script

Before opening Task Scheduler, create the file that Windows is actually going to run.

Open **Notepad** and paste the code from the repository's `popup.ps1` file.

For a simple one-message popup, it looks like this:

```powershell
$message = "Your message goes here"

$wshell = New-Object -ComObject WScript.Shell
$wshell.Popup($message, 0, "Your title here", 48)
```

Save the file as:

```text
popup.ps1
```

Make sure it actually ends in `.ps1` and **not** `.ps1.txt`. [Set file type as All Files]

The address should look something like this:

```text
C:\Users\YourName\Desktop\Popup\popup.ps1
```

You can put it anywhere you want, but **don't move it after setting up the task** unless you update the path in Task Scheduler.

---

# 2. Understanding the Code

Before setting up the schedule, here's what the code is actually doing.

### The message

```powershell
$message = "Your message goes here"
```

This is simply the text that will appear in the popup.
Change it to whatever you want:

```powershell
$message = "Go drink some water."
```

or:

```powershell
$message = "You've been studying for 2 hours. Take a break."
```

---

### Creating the popup

```powershell
$wshell = New-Object -ComObject WScript.Shell
```

This gives PowerShell access to the Windows Script Host functionality that we're using to create the popup.
You don't need to change this line.

---

### Showing the popup

```powershell
$wshell.Popup($message, 0, "Your title here", 48)
```

The parameters are:

```text
Popup(message, timeout, title, icon)
```

### `message`

```powershell
$message
```

The text displayed inside the popup.

### `timeout`

```powershell
0
```

How long the popup stays open, in seconds.

| Value | What happens                  |
| ----: | ----------------------------- |
|   `0` | Stays open until you click OK |
|   `5` | Closes after 5 seconds        |
|  `15` | Closes after 15 seconds       |
|  `30` | Closes after 30 seconds       |

For something you actually need to read, `0` is probably the move.

### `title`

```powershell
"Your title here"
```

The text shown in the popup's title bar.

For example:

```powershell
"GOOD MORNING!"
```

### `icon`

The final number controls the icon shown in the popup.

| Value | Icon              |
| ----: | ----------------- |
|   `0` | No icon           |
|  `16` | ❌ Critical / Stop |
|  `32` | ❓ Question        |
|  `48` | ⚠️ Warning        |
|  `64` | ℹ️ Information    |

For normal reminders, `64` is a good choice.

For something unnecessarily dramatic:

```powershell
$wshell.Popup($message, 0, "IMPORTANT", 48)
```

is always an option. 😭

---

# 3. Open Task Scheduler

Now we need to tell Windows **when** to run the script.

Press:

```text
Win + R
```

Type:

```text
taskschd.msc
```

and press **Enter**.

This opens **Task Scheduler**.

---

# 4. Create a Task

On the right-hand side, click:

**Create Task...**

---

# 5. General Tab

You'll start in the **General** tab.

Give your task a name and add a description if you want.

### Security Options

Make sure **Run only when user is logged on** is selected.

This is important.

Your PowerShell script creates a visible popup, so Windows needs to run it in your normal desktop session.

---

# 6. Triggers

Now go to the **Triggers** tab

Click:

**New...**

This is where you decide **when your popup should appear**.

There are a bunch of options, but here are the useful ones for this project.

---

## ⏰ Option 1: Show the popup at a specific time

Set:

**Begin the task:**

```text
On a schedule
```

Then choose:

```text
Daily
```

Set the time you want.

For example:

```text
8:00 AM
```

You can also choose:

* Once
* Daily
* Weekly
* Monthly

### Example

If you want a motivational popup every weekday at 8 AM:

```text
Begin the task: On a schedule
Settings: Weekly
Days: Monday, Tuesday, Wednesday, Thursday, Friday
Time: 8:00 AM
```

---

# 💤 Option 2: Show the popup when your computer is idle

This one's pretty fun for reminders.

Set:

**Begin the task:**

```text
On idle
```

Windows will run the task when your computer becomes idle.

You can control what counts as idle in the task's **Conditions** tab.

For example, you could tell Windows:

> If I haven't touched my computer for 15 minutes, show me a reminder.

This is useful for things like:

```text
"Are you actually working or did you just stare at the same tab for 20 minutes?"
```

A silly gag you could setup on your PC or a friend's PC to freak them out ( •̀ ω •́ )✧.

---

# 🔑 Option 3: Show the popup when you log in

Set:

**Begin the task:**

```text
At log on
```

This makes the popup appear when you sign into Windows.

---

# 🖥️ Option 4: Show the popup when Windows starts

You can also use:

```text
At startup
```

This runs the task when Windows starts.

Keep in mind that **At startup** happens before or around the time Windows finishes loading, so if you want something specifically when *you* start using your computer, **At log on** is usually more useful.

---

# ⚙️ Trigger Settings

Depending on the trigger you choose, you'll see additional settings.

For example, you may see:

### Delay task for

Adds a delay before the task actually runs. This can be useful if you don't want the popup appearing immediately while Windows is still loading everything.

---

### Repeat task every

Allows you to repeat the task. This could make your computer repeatedly remind you about something.

Use responsibly. You *can* make Windows bother you every 10 minutes. You probably shouldn't.

---

### Enabled

Make sure **Enabled** is checked. Otherwise your configured task will just sit there doing absolutely nothing. 💀

---

# 7. Actions

Now go to:

**Actions → New...**

This tells Task Scheduler **what to actually run**.

Set:

**Action:**

```text
Start a program
```

---

## Program/script

Enter:

```text
powershell.exe
```

This tells Windows to use PowerShell.

---

## Add arguments

This is where you tell PowerShell which script to run.

Enter:

```text
-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\PATH\TO\YOUR\popup.ps1"
```

Replace the path with the actual location of your file.

For example, if your file is:

```text
C:\Users\seagull\Desktop\Popup\popup.ps1
```

you would use:

```text
-NoProfile -ExecutionPolicy Bypass -File "C:\Users\seagull\Desktop\Popup\popup.ps1"
```

**Keep the quotation marks**, especially if your path contains spaces.

For example:

```text
"C:\Users\Your Name\Desktop\My Popup\popup.ps1"
```

---

# 8. Conditions

Now go to:

**Conditions**

This section controls **whether Windows is allowed to run the task under certain circumstances**.

What you choose here depends on your trigger.

---

## If you're using a scheduled time

For a normal scheduled popup, you generally don't need special conditions. Leave the unnecessary conditions unchecked.

In particular, watch out for:

### "Start the task only if the computer is idle"

If you aren't intentionally using an idle-based setup, **don't enable this** or your popup could never appear.

---

## If you're using an idle trigger

You can configure things like:

```text
Start the task only if the computer is idle for:
15 minutes
```

This means Windows waits until you've been inactive for that amount of time before running the task.

You can also configure:

**Stop if the computer ceases to be idle**

If you don't want your popup disappearing just because you moved your mouse, you may want to leave this disabled.

---

## Power settings

You may also see options related to power:

* Start the task only if the computer is on AC power
* Stop if the computer switches to battery power
* Wake the computer to run this task

For a simple desktop popup, you usually don't need these. [Deselect them]

---

# 9. Settings

Finally, check the **Settings** tab.

A useful option is:

**Allow task to be run on demand**

Keep this enabled. It means you can test your task manually from Task Scheduler.

---

# 🧪 10. Test Everything

Once you've configured everything:

Click **OK** to save the task.

Find your task in the Task Scheduler list.

Right-click it and select:

**Run**

If everything is configured correctly, your popup should appear immediately.

If it works manually but doesn't appear at the scheduled time, check your **Trigger** and **Conditions** first.

---

And that's literally it.

No additional software.

No packages.

No libraries to install.

Just **PowerShell + Task Scheduler**, both already sitting on your Windows PC waiting to be mildly annoying.
