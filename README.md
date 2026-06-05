# Get-EmotionalDamageAnalytics
*This script is for a lab environment and meant for learning purposes only*

## What does it do
Reads a CSV of job applications and returns a brutally honest summary of your job hunt campaign:

Total applications sent
Hired / Denied / Responded / Uncertain counts
Days since campaign started
Denial rate percentage with a warning if it's looking rough
Uncertain outcome percentage for applications still in limbo

## What does it solve
Job hunting is a numbers game and the emotional toll is real. This turns the pain into data — because nothing softens rejection like a percentage breakdown. Tracks progress over time so you know if the campaign is gaining traction or if it's time to update the resume. Again.


## Who's it for
Anyone brave enough to quantify their own disappointment. Sysadmins, IT professionals, and anyone sending applications into the void and wondering if anyone is home.


## Requirements

PowerShell 5.1+
A CSV file of disappointments with at least these columns:

Date,Company,Position,Platform,Status,Notes,Odds,UserName,Password,Link

Valid Status values: hired, denied, responded, or anything else (counts as Uncertain)

## Warning
- hired status triggers a celebratory message and exits the emotional damage loop immediately - not yet implemented 
- Denial rate warning fires when denials outnumber responses — this is PowerShell's way of saying "maybe update the resume"
- **UserName and Password** columns are in the CSV format — do NOT store actual credentials in plaintext in a CSV. Ever. 😄
- Script does not provide emotional support beyond color-coded percentages

## Limitations
- CampaignStartDate is pulled from the first row of the CSV — make sure the CSV is sorted by date
- No visualization — just numbers and warnings
- Does not track interview stages — responded is just responded, no follow-up granularity yet
- Cannot prevent you from checking the CSV at 2am

## Notes
Work in progress — interview stage tracking, follow-up reminders, and a proper emotional damage score coming in a future iteration. Pairs well with coffee, a deep breath, and the knowledge that 1 out of 1000 is still a win.

## Sample Output
```
PS C:\Logs> import-csv .\CsvOfDisappointment.csv | Get-EmotionalDamageAnalytics

CampaignStartDate : 2026-06-01
DaysSinceStart    : 4
TotalApplications : 15
Hired             : 0
Denied            : 0
Responded         : 1
Uncertain         : 11
Ghosted           : 3

WARNING: high uncertainty detected: 73.33%
Ghosting rate : 20%
Uncertain rate: 73.33%
PS C:\Logs>
```
