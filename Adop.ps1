# ================================================
#   Adop.ps1 — Красивое меню в командной строке
#   Стиль: современное консольное меню
# ================================================

Clear-Host
$host.UI.RawUI.WindowTitle = "Adop — Программы для скачивания"

function Show-Menu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    ADOP — Программы для скачивания                 ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Выберите категорию:" -ForegroundColor Yellow
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
    Write-Host "   Введите номер и нажмите Enter → " -NoNewline -ForegroundColor Gray
}

function Show-Programs {
    param([string]$Category)

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    if ($Category -eq "Все") {
        Write-Host "║                     ВСЕ ДОСТУПНЫЕ ПРОГРАММЫ                        ║" -ForegroundColor Cyan
    } else {
        Write-Host "║                  ПРОГРАММЫ: $Category                          ║" -ForegroundColor Cyan
    }
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    $list = @(
        @{Name="Windows 10 Pro";          Cat="Windows";     Dls="12 450"},
        @{Name="Windows 11 Home";         Cat="Windows";     Dls="8 750"},
        @{Name="Microsoft Office 2024";   Cat="Office";      Dls="32 400"},
        @{Name="Visual Studio 2022";      Cat="Разработка";  Dls="18 900"},
        @{Name="Windows Server 2022";     Cat="Серверы";     Dls="5 600"},
        @{Name="SQL Server 2022";         Cat="Базы данных"; Dls="12 400"}
    )

    if ($Category -ne "Все") {
        $list = $list | Where-Object { $_.Cat -eq $Category }
    }

    $i = 1
    foreach ($prog in $list) {
        Write-Host "   $i. $($prog.Name)" -ForegroundColor White
        Write-Host "       Категория: $($prog.Cat)   |   Скачиваний: $($prog.Dls)" -ForegroundColor DarkGray
        Write-Host ""
        $i++
    }

    Write-Host "   0. Назад в меню" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Введите номер программы для скачивания → " -NoNewline -ForegroundColor Gray

    $choice = Read-Host

    if ($choice -eq "0") { return }

    if ($choice -match '^\d+$' -and [int]$choice -le $list.Count) {
        $selected = $list[[int]$choice - 1]
        
        Write-Host "`n   Скачивание $($selected.Name)..." -ForegroundColor Green
        Write-Host "   Подождите, идёт подготовка файла..." -ForegroundColor Gray
        
        Start-Sleep -Seconds 2
        
        Write-Host "`n   ✓ Файл $($selected.Name) успешно скачан!" -ForegroundColor Green
        Write-Host "   Ссылка: https://example.com/download/$($selected.Name.Replace(' ',''))" -ForegroundColor Cyan
        Write-Host "`n   Нажмите любую клавишу для продолжения..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    else {
        Write-Host "`n   Ошибка: неверный номер!" -ForegroundColor Red
        Start-Sleep -Seconds 1.5
    }
}

# ===================== Главный цикл =====================
do {
    Show-Menu
    $input = Read-Host

    switch ($input) {
        "1" { Show-Programs "Все" }
        "2" { Show-Programs "Windows" }
        "3" { Show-Programs "Office" }
        "4" { Show-Programs "Разработка" }
        "5" { Show-Programs "Серверы" }
        "6" { Show-Programs "Базы данных" }
        "0" { 
            Clear-Host
            Write-Host "Спасибо за использование Adop! До свидания." -ForegroundColor Cyan
            Start-Sleep -Seconds 1.5
            exit 
        }
        default { 
            Write-Host "`n   Неверный выбор! Попробуйте снова." -ForegroundColor Red
            Start-Sleep -Seconds 1.2
        }
    }
} while ($true)
