$SleepSeconds = 90
$doneFile = "task-done.txt"

Start-Sleep -Seconds $SleepSeconds

$existing = @()
if (Test-Path $doneFile) {
    $existing = Get-Content $doneFile | Where-Object { $_ -match '^DONE-' }
}
$nextNumber = $existing.Count + 1
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

"DONE-$nextNumber at $timestamp" | Add-Content -Path $doneFile
