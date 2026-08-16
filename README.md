# A Watch Loop

Project 1 from the Loop Engineering crash course.

## Run

```powershell
powershell -NoProfile -File watch.ps1
```

## What happens

- `long-task.ps1` sleeps 90 seconds, then appends `DONE-N at <time>` to `task-done.txt`.
- `watch.ps1` checks every 60 seconds, then announces the finish once and writes `SUMMARYN.md`.
- Each run increases the number: `DONE-2`, `SUMMARY2.md`, and so on.

## Limits

- Max beats: 10 (about 10 minutes), then it reports `TIMEOUT`.
- Stop cleanly anytime with Ctrl-C.
