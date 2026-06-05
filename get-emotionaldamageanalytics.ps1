<#
Emotional devastator v-1.0

Import-csv .\CsvOfDissapointment.csv

CSV Format
Date	Company	Position	Platform	Status	Notes	Odds	UserName	Password	Link

#>

function Get-EmotionalDamageAnalytics {

  [cmdletbinding()]
  param (
    [parameter(ValueFromPipelineByPropertyName = $true)]
    [string[]]$Date,
    [parameter(ValueFromPipelineByPropertyName = $true)]
    [string[]]$Status
  )

  BEGIN {
    # declaring variables
    $FirstDate = $null
    $HiredCount = 0
    $DeniedCount = 0
    $ResponseCount = 0
    $UncertainCount = 0
    $GhostedCount = 0
  }

  PROCESS {

    if ($null -eq $FirstDate -and $Date) {
      # selecting just the first string value passed into the pipe
      $FirstDate = [DateTime]($Date -join '') 
    }


    # ======================================== #
    #              DATA GATHERING              #
    # ======================================== #
    
    foreach ($Stats in $Status) {

      if ($stats -eq 'hired') {
        Write-Host "Boom! Hired! No emonotional damage here!" -ForegroundColor Green
        $HiredCount += 1
      }
      elseif ($Stats -eq 'denied') {
        $DeniedCount += 1
      }
      elseif ($Stats -eq 'responded') {
        $ResponseCount += 1
      }
      elseif ($Stats -eq 'ghosted') {
        $GhostedCount += 1
      }
      else {
        $UncertainCount += 1
      }

    } # foreach

  } # PROCESS

  END {

    # accumulated totals
    $total = $HiredCount + $DeniedCount + $ResponseCount + $UncertainCount + $GhostedCount

    # get the days since the first application
    $DaysPast = "Unknown"
    if ($FirstDate) {
      # the math is mathing - calculating the total days since the first application was sent
      $DaysPast = [math]::Round(((Get-Date) - $FirstDate).TotalDays, 0)
    }
    
    # ======================================== #
    #                   DISPLAY                #
    # ======================================== #
    
    [PSCustomObject]@{
      # the object that will be outputted to the pipeline with all the analytics
      CampaignStartDate = $FirstDate.ToString("yyyy-MM-dd")
      DaysSinceStart    = $DaysPast
      TotalApplications = $total
      Hired             = $HiredCount
      Denied            = $DeniedCount
      Responded         = $ResponseCount
      Uncertain         = $UncertainCount
      Ghosted           = $GhostedCount
    }

    # ======================================== #
    #             MAIN LOGIC                   #
    # ======================================== #
    # the main logic for analyzing the emotional damage based on the response rates and uncertainty
    # i should have used switch cases but this is more fun to write "says no one ever", the real reson is just it keeps on expanding, it's started with only two logic branches and then i kept on adding more and more as i thought of more scenarios to analyze, so it ended up like thisq
    $ValidResponses = $DeniedCount + $ResponseCount
    if ($ValidResponses -gt 0) {
      if ($uncertaincount -gt ($DeniedCount + $ResponseCount)) {
        write-warning "high uncertainty detected: $([math]::round(($UncertainCount / $total * 100), 2))%"
      }
      elseif ($HiredCount -gt 0) {
        write-host "Congratulations! You got hired in $DaysPast days with a response rate of $([math]::round(($ResponseCount / $total * 100), 2))%!" -ForegroundColor Green
      }
      elseif ($DeniedCount -gt $ResponseCount) {
        write-warning "high denial rate detected: $([math]::round(($DeniedCount / ($DeniedCount + $ResponseCount) * 100), 2))%"
      }
      elseif ($ResponseCount -gt $DeniedCount) {
        write-host "Application status looks good: $([math]::round(($ResponseCount / ($DeniedCount + $ResponseCount) * 100), 2))% responded" -ForegroundColor Green
      }
    }


    # ======================================== #
    #               FIX COUNTER                #
    # ======================================== #

    # fix analization for ghosting and uncertain rates
    if ($GhostedCount -gt 0 -and $total -gt 0) {
      Write-Host "Ghosting rate : $([math]::round(($GhostedCount / $total * 100), 2))%" -ForegroundColor Yellow
    }
    if ($total -gt 0) {
      Write-Host "Uncertain rate: $([math]::round(($UncertainCount / $total * 100), 2))%" -ForegroundColor Yellow
    }

  } # END

} # function
