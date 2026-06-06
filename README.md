# Get-EmotionalDamageAnalytics
*This script is for a lab environment and meant for learning purposes only*


## What does it do
- Reads a CSV of job applications and returns a brutally honest summary of your job hunt campaign:
- Total applications sent with full status breakdown (Hired / Denied / Responded / Uncertain / Ghosted)
- Days since campaign started
- Denial rate, response rate, ghosting rate, and uncertainty rate with color coded warnings
- Skill Leaderboard — parses the Skills column across all applications and shows the top 5 most demanded skills in the market based on your own data

## What does it solve
- Job hunting is a numbers game and the emotional toll is real. This turns the pain into data — because nothing softens rejection like a percentage breakdown. The skill leaderboard is an accidental market analysis tool — after enough applications, the data tells you exactly what skills to prioritize next.

## Who's it for
- Anyone brave enough to quantify their own disappointment.
- Sysadmins, IT professionals, and anyone sending applications into the void and wondering if anyone is home.
- Or someone who have patient in tracking their application journey

## Requirements
- PowerShell 5.1+
- A CSV of Disappointment with at least these required columns (marked with *):

`*Date, Company, Position, Platform, *Status, Notes, Odds, UserName, Password, Link, *AutomationStamp, *Skills`

- Valid Status values: `hired, denied, responded, ghosted, or anything else (counts as Uncertain)`
- Skills column should be comma-separated values per row:`powershell, active directory, azure`

## Usage
``` powershell
# Standard run
Import-Csv .\CsvOfDisappointment.csv | Get-EmotionalDamageAnalytics

# Pair with Ghost Detector for full pipeline
Invoke-GhostDetector
Import-Csv .\CsvOfDisappointment.csv | Get-EmotionalDamageAnalytics
```

## Warning

- Hired status triggers a celebration message — the script has no break yet so it will still finish the run. Fix coming in a future iteration 
- UserName and Password columns exist in the CSV format — do NOT store actual credentials in plaintext. Ever.
- `$ErrorActionPreference = 'Stop'` is set globally inside the function — errors that would normally be non-terminating will be caught by try/catch
- Script does not provide emotional support beyond color-coded percentages and skill gap analysis

## Limitations

- CampaignStartDate is pulled from the first row — keep the CSV sorted by date
- Skill leaderboard shows top 5 only — hardcoded, not currently a parameter
- Skill matching is exact string after trim and lowercase — "powershell" and "PowerShell scripting" count as different skills
- No visualization — just numbers, warnings, and a table
- Cannot prevent you from checking the CSV at 2am

## Notes
Started as a meme script for tracking job rejections. Accidentally became a legitimate market analysis tool when the Skills column leaderboard was added. Now tracks campaign health, ghosting rates, and skill demand simultaneously from a single CSV.
Pairs with Invoke-GhostDetector for automated ghosting detection and status updates. Together they form a job hunt toolkit.

## Example Output
```
PS C:\Logs> import-csv .\CsvOfDisappointment.csv | Get-EmotionalDamageAnalytics

CampaignStartDate : 2026-06-03
DaysSinceStart    : 4
TotalApplications : 16
Hired             : 0
Denied            : 0
Responded         : 2
Uncertain         : 12
Ghosted           : 2

WARNING: high uncertainty detected: 75%
Ghosting rate : 12.5%
Uncertain rate: 75%

--- MARKET ANALYSIS ON SKILLSETS ---

Skill                     Count
-----                     -----
data analist                  3
random skills                 2
can understand dino logic     1
dna sequence                  1
mktg                          1
```
