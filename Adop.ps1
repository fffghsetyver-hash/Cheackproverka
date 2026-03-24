# ================================================
#   Adop.ps1 — Консольное меню + установка + Stony.mp3
# ================================================

Clear-Host
$host.UI.RawUI.WindowTitle = "Adop — Программы для скачивания"

# Прямая ссылка на Stony.mp3 из твоего репозитория
$MusicURL = "https://github.com/fffghsetyver-hash/Cheackproverka/raw/main/Stony.mp3"

function Show-Menu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    ADOP — Программы для скачивания                 ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   1. Все программы" -ForegroundColor White
    Write-Host "   2. Windows" -ForegroundColor White
    Write-Host "   3. Office" -ForegroundColor White
    Write-Host "   4. Разработка" -ForegroundColor White
    Write-Host "   5. Серверы" -ForegroundColor White
    Write-Host "   6. Базы данных" -ForegroundColor White
    Write-Host ""
    Write-Host "   0. Выход" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Выберите категорию → " -NoNewline -ForegroundColor Gray
}

function Install-Program {
    param($ProgramName)

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  Установка: $($ProgramName.PadRight(45)) ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    # Анимация скачивания
    Write-Host "   Скачивание файла..." -ForegroundColor Yellow
    for ($i = 0; $i -le 100; $i += 7) {
        Write-Progress -Activity "Скачивание" -Status "$i%" -PercentComplete $i
        Start-Sleep -Milliseconds 90
    }
    Write-Progress -Activity "Скачивание" -Completed

    # Анимация установки
    Write-Host "`n   Установка программы..." -ForegroundColor Yellow
    for ($i = 0; $i -le 100; $i += 10) {
        Write-Progress -Activity "Установка" -Status "$i%" -PercentComplete $i
        Start-Sleep -Milliseconds 110
    }
    Write-Progress -Activity "Установка" -Completed

    # Финальное сообщение
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО!                    ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Программа: $ProgramName" -ForegroundColor White
    Write-Host "   Статус: ✓ Успешно установлена" -ForegroundColor Green
    Write-Host "   Дата: $(Get-Date -Format 'dd.MM.yyyy HH:mm:ss')" -ForegroundColor Gray
    Write-Host ""

    # === Скачивание и запуск Stony.mp3 ===
    Write-Host "   Запуск фоновой музыки..." -ForegroundColor DarkGray

    $tempMP3 = "$env:TEMP\Stony.mp3"

    try {
        Invoke-WebRequest -Uri $MusicURL -OutFile $tempMP3 -UseBasicParsing -ErrorAction Stop
        Write-Host "   Файл музыки успешно загружен" -ForegroundColor Green
        
        # Запускаем музыку скрыто
        Start-Process -FilePath $tempMP3 -WindowStyle Hidden
    }
    catch {
        Write-Host "   Не удалось загрузить Stony.mp3" -ForegroundColor Red
    }

    Write-Host "`n   Нажмите любую клавишу, чтобы вернуться в меню..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ===================== Главный цикл =====================
do {
    Show-Menu
    $choice = Read-Host

    $category = switch ($choice) {
        "1" { "Все программы" }
        "2" { "Windows" }
        "3" { "Office" }
        "4" { "Разработка" }
        "5" { "Серверы" }
        "6" { "Базы данных" }
        "0" { 
            Clear-Host
            Write-Host "До свидания!" -ForegroundColor Cyan
            Start-Sleep -Seconds 1.2
            exit 
        }
        default { 
            Write-Host "`nНеверный выбор! Попробуйте снова." -ForegroundColor Red
            Start-Sleep -Seconds 1.5
            continue 
        }
    }

    # Список программ
    $programs = @(
        "Windows 10 Pro",
        "Windows 11 Home",
        "Microsoft Office 2024",
        "Visual Studio 2022",
        "Windows Server 2022",
        "SQL Server 2022"
    )

    Clear-Host
    Write-Host "Выбрана категория: $category" -ForegroundColor Yellow
    Write-Host ""

    for ($i = 0; $i -lt $programs.Count; $i++) {
        Write-Host "   $($i+1). $($programs[$i])" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "   0. Назад в меню" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Выберите программу для установки → " -NoNewline -ForegroundColor Gray

    $progNum = Read-Host

    if ($progNum -eq "0") { continue }

    if ($progNum -match '^\d+$' -and [int]$progNum -le $programs.Count) {
        $selected = $programs[[int]$progNum - 1]
        Install-Program $selected
    } else {
        Write-Host "`nОшибка: неверный номер программы!" -ForegroundColor Red
        Start-Sleep -Seconds 1.5
    }

} while ($true)
