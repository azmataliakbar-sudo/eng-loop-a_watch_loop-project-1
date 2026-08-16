$IntervalSeconds = 60
$MaxBeats = 10
$doneFile = "task-done.txt"

$baseline = 0
if (Test-Path $doneFile) {
    $baseline = (Get-Content $doneFile | Where-Object { $_ -match '^DONE-' }).Count
}

$startedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$job = Start-Process powershell -ArgumentList "-NoProfile", "-File", "long-task.ps1" -PassThru -WindowStyle Hidden

$finished = $false
$signalLine = ""
for ($i = 1; $i -le $MaxBeats; $i++) {
    $count = 0
    if (Test-Path $doneFile) {
        $count = (Get-Content $doneFile | Where-Object { $_ -match '^DONE-' }).Count
    }
    if ($count -gt $baseline) {
        $signalLine = (Get-Content $doneFile | Where-Object { $_ -match '^DONE-' } | Select-Object -Last 1)
        $finished = $true
        break
    }
    if ($i -lt $MaxBeats) {
        Start-Sleep -Seconds $IntervalSeconds
    }
}

$finishedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$existingSummaries = Get-ChildItem -Filter "SUMMARY*.md" -ErrorAction SilentlyContinue
$nextSummary = $existingSummaries.Count + 1
$summaryFile = "SUMMARY$nextSummary.md"

if ($finished) {
    $result = "SUCCESS"
    Write-Output "TASK FINISHED: $signalLine"
} else {
    $result = "TIMEOUT"
    Write-Output "TIMEOUT: task did not finish within $MaxBeats beats"
    $signalLine = "none"
}

$content = @(
    "Run: $nextSummary"
    "Started: $startedAt"
    "Finished: $finishedAt"
    "Result: $result"
    "Signal: $signalLine"
)

Set-Content -Path $summaryFile -Value $content
