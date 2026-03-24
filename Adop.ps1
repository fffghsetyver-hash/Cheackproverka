# ================================================
#   Adop.ps1 — Консольное меню + загрузка + музыка
# ================================================

Clear-Host
$host.UI.RawUI.WindowTitle = "Adop — Программы для скачивания"

# Прямая ссылка на Stony.mp3 (если файла нет в репозитории — замени на свою)
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

function Download-And-Install {
    param($ProgramName)

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                     Установка $($ProgramName)                       ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    # Прогресс-бар скачивания
    Write-Host "   Скачивание файла..." -ForegroundColor Yellow
    for ($i = 0; $i -le 100; $i += 8) {
        Write-Progress -Activity "Скачивание" -Status "$i% выполнено" -PercentComplete $i
        Start-Sleep -Milliseconds 120
    }
    Write-Progress -Activity "Скачивание" -Completed

    Write-Host "`n   Установка программы..." -ForegroundColor Yellow
    for ($i = 0; $i -le 100; $i += 10) {
        Write-Progress -Activity "Установка" -Status "$i% выполнено" -PercentComplete $i
        Start-Sleep -Milliseconds 150
    }
    Write-Progress -Activity "Установка" -Completed

    Write-Host "`n   ✓ Всё хорошо!" -ForegroundColor Green
    Write-Host "   Программа $($ProgramName) успешно скачана и установлена!" -ForegroundColor Green
    Write-Host ""

    # === Скрытое скачивание и проигрывание Stony.mp3 ===
    Write-Host "   Запуск фоновой музыки..." -ForegroundColor DarkGray

    $tempFile = "$env:TEMP\Stony.mp3"
    try {
        Invoke-WebRequest -Uri $MusicURL -OutFile $tempFile -UseBasicParsing -ErrorAction Stop
        Start-Process -FilePath $tempFile -WindowStyle Hidden
    } catch {
        Write-Host "   Не удалось загрузить музыку (файл не найден)" -ForegroundColor Red
    }

    Write-Host "`n   Нажмите любую клавишу для возврата в меню..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ===================== Главный цикл =====================
do {
    Show-Menu
    $cat = Read-Host

    switch ($cat) {
        "1" { $catName = "Все программы" }
        "2" { $catName = "Windows" }
        "3" { $catName = "Office" }
        "4" { $catName = "Разработка" }
        "5" { $catName = "Серверы" }
        "6" { $catName = "Базы данных" }
        "0" { 
            Clear-Host
            Write-Host "До свидания!" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 
        }
        default { 
            Write-Host "Неверный выбор!" -ForegroundColor Red
            Start-Sleep -Seconds 1.5
            continue 
        }
    }

    Clear-Host
    Write-Host "Выбрана категория: $catName" -ForegroundColor Yellow
    Write-Host ""

    $programs = @(
        "Windows 10 Pro",
        "Windows 11 Home",
        "Microsoft Office 2024",
        "Visual Studio 2022",
        "Windows Server 2022",
        "SQL Server 2022"
    )

    $i = 1
    foreach ($p in $programs) {
        Write-Host "   $i. $p" -ForegroundColor White
        $i++
    }
    Write-Host ""
    Write-Host "   0. Назад" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Выберите программу → " -NoNewline -ForegroundColor Gray

    $progChoice = Read-Host

    if ($progChoice -eq "0") { continue }

    if ($progChoice -match '^\d+$' -and [int]$progChoice -le $programs.Count) {
        $selectedProg = $programs[[int]$progChoice - 1]
        Download-And-Install $selectedProg
    } else {
        Write-Host "Неверный номер!" -ForegroundColor Red
        Start-Sleep -Seconds 1.5
    }

} while ($true)
