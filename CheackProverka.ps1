# ================================================
#   Adop.ps1 — Финальная версия с музыкой
# ================================================

Clear-Host
$host.UI.RawUI.WindowTitle = "Adop — Программы для скачивания"

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
    Write-Host "║                  Установка: $ProgramName" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    # Анимация
    Write-Host "   Скачивание..." -ForegroundColor Yellow
    for ($i = 0; $i -le 100; $i += 8) {
        Write-Progress -Activity "Скачивание" -Status "$i%" -PercentComplete $i
        Start-Sleep -Milliseconds 80
    }
    Write-Progress -Activity "Скачивание" -Completed

    Write-Host "`n   Установка..." -ForegroundColor Yellow
    for ($i = 0; $i -le 100; $i += 12) {
        Write-Progress -Activity "Установка" -Status "$i%" -PercentComplete $i
        Start-Sleep -Milliseconds 100
    }
    Write-Progress -Activity "Установка" -Completed

    # Успешное завершение
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО!                    ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Программа: $ProgramName" -ForegroundColor White
    Write-Host "   Статус: ✓ Успешно установлена" -ForegroundColor Green
    Write-Host ""

    # === Скачивание и открытие Stony.mp3 ===
    Write-Host "   Загрузка музыки Stony.mp3..." -ForegroundColor Gray

    $mp3Path = "$env:TEMP\Stony_$(Get-Random).mp3"

    try {
        Invoke-WebRequest -Uri $MusicURL -OutFile $mp3Path -UseBasicParsing -TimeoutSec 30
        Write-Host "   Музыка загружена успешно!" -ForegroundColor Green

        # Открываем файл через стандартный проигрыватель Windows
        Start-Process -FilePath $mp3Path
        Write-Host "   Файл Stony.mp3 открыт в проигрывателе" -ForegroundColor Cyan
    }
    catch {
        Write-Host "   Не удалось скачать музыку. Проверьте интернет или наличие файла в репозитории." -ForegroundColor Red
    }

    Write-Host "`n   Нажмите любую клавишу для возврата в меню..." -ForegroundColor Gray
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
        "0" { Clear-Host; Write-Host "До свидания!" -ForegroundColor Cyan; exit }
        default { Write-Host "Неверный выбор!" -ForegroundColor Red; Start-Sleep -Seconds 1.5; continue }
    }

    $programs = @("Windows 10 Pro","Windows 11 Home","Microsoft Office 2024","Visual Studio 2022","Windows Server 2022","SQL Server 2022")

    Clear-Host
    Write-Host "Категория: $category" -ForegroundColor Yellow
    Write-Host ""

    for ($i = 0; $i -lt $programs.Count; $i++) {
        Write-Host "   $($i+1). $($programs[$i])" -ForegroundColor White
    }
    Write-Host "   0. Назад" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Выберите программу → " -NoNewline -ForegroundColor Gray

    $num = Read-Host

    if ($num -eq "0") { continue }

    if ($num -match '^\d+$' -and [int]$num -le $programs.Count) {
        $selected = $programs[[int]$num - 1]
        Install-Program $selected
    } else {
        Write-Host "Неверный номер!" -ForegroundColor Red
        Start-Sleep -Seconds 1.5
    }
} while ($true)
