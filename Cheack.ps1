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
        Clear-Host
        Show-Header
        Write-Host "    Запуск проверки на читы в Minecraft..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        
        Start-MCScan "Проверка KillAura / Reach" 6
        Start-MCScan "Проверка AimAssist / TriggerBot" 5
        Start-MCScan "Проверка AutoClicker" 5
        Start-MCScan "Проверка X-Ray / ESP" 7
        Start-MCScan "Проверка Fly / Speed / Jesus" 6
        
        Write-Host "`n    =========================================================" -ForegroundColor Green
        Write-Host "                  РЕЗУЛЬТАТ ПРОВЕРКИ" -ForegroundColor Green
        Write-Host "    =========================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "               ЧИТЫ НЕ ОБНАРУЖЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "               Minecraft клиент чистый ✓" -ForegroundColor Green
    }
    "2" {
        Clear-Host
        Show-Header
        Write-Host "    Проверка Hitbox..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        Start-MCScan "Анализ хитбоксов игроков" 8
        Start-MCScan "Проверка расширения хитбокса" 6
        
        Write-Host "`n               Hitbox в норме — нарушений не найдено" -ForegroundColor Green
    }
    "3" {
        Clear-Host
        Show-Header
        Write-Host "    Запуск полной комплексной проверки Minecraft..." -ForegroundColor Magenta
        Start-Sleep -Seconds 1
        
        Start-MCScan "Проверка на читы" 7
        Start-MCScan "Проверка Hitbox" 6
        Start-MCScan "Проверка движения" 5
        Start-MCScan "Анализ пакетов" 8
        
        Write-Host "`n               ВСЁ ЧИСТО" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "               Клан может спокойно играть" -ForegroundColor Green
    }
    "4" {
        Clear-Host
        Show-Header
        Write-Host "    Проверка установленного программного обеспечения..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        Start-MCScan "Поиск подозрительных программ" 6
        Start-MCScan "Проверка инжекторов и оверлеев" 5
        Write-Host "`n               Подозрительное ПО не обнаружено" -ForegroundColor Green
    }
    "5" {
        Clear-Host
        Show-Header
        Write-Host "    Запуск расширенной проверки by X4KN..." -ForegroundColor Magenta
        Start-Sleep -Seconds 2
        
        Start-MCScan "Глубокий анализ клиента Minecraft" 9
        Start-MCScan "Проверка памяти JVM" 7
        Start-MCScan "Анализ модов и фордж/фабрик" 8
        
        Write-Host "`n    =========================================================" -ForegroundColor Green
        Write-Host "         ПРОВЕРКА ЗАВЕРШЕНА — ЧИСТО" -ForegroundColor Green
        Write-Host "    =========================================================" -ForegroundColor Green
        Write-Host "               ClanCheacker by X4KN — результат: ЧИСТО" -ForegroundColor Green
    }
    "6" {
        Clear-Host
        Show-Header
        Write-Host "    ClanCheacker" -ForegroundColor Cyan
        Write-Host "    Minecraft Anti-Cheat Scanner" -ForegroundColor Green
        Write-Host "    Разработано специально для кланов" -ForegroundColor Gray
        Write-Host "`n    Все проверки виртуальные и всегда показывают чистый результат." -ForegroundColor DarkGray
        Write-Host "    Сделано by X4KN" -ForegroundColor Yellow
    }
    "7" {
        Clear-Host
        Show-Header
        Write-Host "    До свидания!" -ForegroundColor Cyan
        Write-Host "    Чистой игры твоему клану!" -ForegroundColor Green
        Start-Sleep -Seconds 2
        exit
    }
    default {
        Write-Host "`n    Неправильный выбор! Попробуй снова." -ForegroundColor Red
    }
}

Write-Host "`n`n    Нажми любую клавишу для выхода..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
