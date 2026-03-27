# ================================================
#       HLIBCHUK CHEACKER v2.1
#   Расширенное меню + реалистичное сканирование
# ================================================

Clear-Host

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "    ██████╗  ██╗    ██╗  ██╗    ██╗  ██████╗██╗  ██╗██╗   ██╗██╗  ██╗" -ForegroundColor Red
    Write-Host "    ██╔══██╗██║    ██║  ██║    ██║ ██╔════╝██║  ██║██║   ██║██║ ██╔╝" -ForegroundColor Red
    Write-Host "    ██████╔╝██║ █╗ ██║  ██║ █╗ ██║ ██║     ███████║██║   ██║█████╔╝ " -ForegroundColor Red
    Write-Host "    ██╔══██╗██║███╗██║  ██║███╗██║ ██║     ██╔══██║██║   ██║██╔═██╗ " -ForegroundColor Red
    Write-Host "    ██████╔╝╚███╔███╔╝  ╚███╔███╔╝ ╚██████╗██║  ██║╚██████╔╝██║  ██╗" -ForegroundColor Red
    Write-Host "    ╚═════╝  ╚══╝╚══╝    ╚══╝╚══╝   ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝" -ForegroundColor Red
    Write-Host "                          C H E A C K E R" -ForegroundColor Yellow
    Write-Host "                       by HLIBCHUK  •  2026" -ForegroundColor DarkGray
    Write-Host "    =========================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-ProgressBar {
    param([int]$Percent, [int]$Width = 50)
    $filled = [math]::Round(($Width * $Percent) / 100)
    $bar = "█" * $filled + "░" * ($Width - $filled)
    Write-Host "    [$bar] $Percent% " -NoNewline -ForegroundColor Yellow
}

function Start-Scan {
    param([string]$ScanName, [int]$MinSeconds = 7, [int]$MaxSeconds = 12)

    Write-Host "    Сканирование: $ScanName" -ForegroundColor Cyan
    $totalTime = Get-Random -Minimum $MinSeconds -Maximum $MaxSeconds
    $steps = 20

    for ($i = 1; $i -le $steps; $i++) {
        $percent = [math]::Round(($i / $steps) * 100)
        Write-ProgressBar -Percent $percent
        Start-Sleep -Milliseconds ([math]::Round(($totalTime * 1000) / $steps))
        Write-Host "`r" -NoNewline
    }
    Write-Host "`r    [██████████████████████████████████████████████████] 100% " -ForegroundColor Green
    Write-Host "    ✓ $ScanName завершено — чисто" -ForegroundColor Green
    Write-Host ""
}

# ====================== ГЛАВНОЕ МЕНЮ ======================
Show-Header

Write-Host "    Инициализация расширенного античит модуля..." -ForegroundColor DarkCyan
Start-Sleep -Milliseconds 800

Write-Host ""
Write-Host "    =========================================================" -ForegroundColor Cyan
Write-Host "                     ГЛАВНОЕ МЕНЮ HLIBCHUK CHEACKER" -ForegroundColor White
Write-Host "    =========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "    [1]  Полная глубокая проверка (рекомендуется)" -ForegroundColor Green
Write-Host "    [2]  Быстрая проверка" -ForegroundColor Green
Write-Host "    [3]  Проверить Steam + VAC / EAC" -ForegroundColor Green
Write-Host "    [4]  Сканирование системных файлов и драйверов" -ForegroundColor Green
Write-Host "    [5]  Проверка памяти и запущенных процессов" -ForegroundColor Green
Write-Host "    [6]  Проверка на внешние чит-программы" -ForegroundColor Green
Write-Host "    [7]  Информация о программе" -ForegroundColor Yellow
Write-Host "    [8]  Выход" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "    Выбери номер действия"

switch ($choice) {
    "1" { 
        Clear-Host
        Show-Header
        Write-Host "    Запуск ПОЛНОЙ глубокой проверки..." -ForegroundColor Magenta
        Start-Sleep -Seconds 1

        Start-Scan "Проверка запущенных процессов" 8 11
        Start-Scan "Сканирование памяти на инжекты" 9 12
        Start-Scan "Анализ DLL и модулей" 7 10
        Start-Scan "Проверка известных чит-сигнатур" 8 12
        Start-Scan "Сканирование драйверов ядра" 9 11
        Start-Scan "Проверка внешних оверлеев" 7 9

        Write-Host "    =========================================================" -ForegroundColor Green
        Write-Host "                  ИТОГОВЫЙ РЕЗУЛЬТАТ" -ForegroundColor Green
        Write-Host "    =========================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "               Все сканирования пройдены успешно" -ForegroundColor Green
        Write-Host "               Система полностью чистая ✓" -ForegroundColor Green
        Write-Host ""
        Write-Host "    Можешь спокойно играть! Никаких рисков." -ForegroundColor Magenta
    }
    "2" {
        Clear-Host
        Show-Header
        Write-Host "    Выполняется быстрая проверка..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        Start-Scan "Быстрое сканирование" 3 5
        Write-Host "               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
    }
    "3" {
        Clear-Host
        Show-Header
        Write-Host "    Проверка Steam + античитов..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        Write-Host "    Steam: обнаружен" -ForegroundColor Green
        Start-Scan "VAC / EAC статус" 4 6
        Write-Host "               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green
    }
    "4" {
        Clear-Host
        Show-Header
        Write-Host "    Сканирование системных файлов и драйверов..." -ForegroundColor Cyan
        Start-Scan "Системные файлы" 8 11
        Start-Scan "Драйверы ядра" 9 12
        Write-Host "               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green
    }
    "5" {
        Clear-Host
        Show-Header
        Write-Host "    Проверка памяти и процессов..." -ForegroundColor Cyan
        Start-Scan "Запущенные процессы" 7 10
        Start-Scan "Память процесса игры" 8 11
        Write-Host "               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green
    }
    "6" {
        Clear-Host
        Show-Header
        Write-Host "    Проверка на внешние чит-программы..." -ForegroundColor Cyan
        Start-Scan "Известные читы (Cheat Engine, WeMod и т.д.)" 7 10
        Start-Scan "Внешние оверлеи и инжекторы" 8 11
        Write-Host "               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green
    }
    "7" {
        Clear-Host
        Show-Header
        Write-Host "    HLIBCHUK CHEACKER v2.1" -ForegroundColor Yellow
        Write-Host "    Это полностью виртуальная шутливая программа." -ForegroundColor Gray
        Write-Host "    Всегда показывает чистый результат для прикола и настроения :)" -ForegroundColor Gray
        Write-Host "`n    Приятной игры, брат!" -ForegroundColor Magenta
    }
    "8" {
        Clear-Host
        Show-Header
        Write-Host "    Спасибо за использование HLIBCHUK CHEACKER!" -ForegroundColor Cyan
        Write-Host "    Чистой тебе игры и удачи!" -ForegroundColor Green
        Start-Sleep -Seconds 2
        exit
    }
    default {
        Write-Host "`n    Ошибка: Неправильный выбор!" -ForegroundColor Red
    }
}

Write-Host "`n`n    Нажми любую клавишу, чтобы выйти..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")