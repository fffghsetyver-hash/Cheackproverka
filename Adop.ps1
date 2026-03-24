# ============================================
# Microsoft License Activator
# Визуальная активация лицензий Windows
# Стиль Microsoft Office
# ============================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Drawing.Drawing2D

# Отключаем вывод ошибок для чистоты интерфейса
$ErrorActionPreference = "SilentlyContinue"

# Создаем главную форму
$form = New-Object System.Windows.Forms.Form
$form.Text = "Microsoft License Activator"
$form.Size = New-Object System.Drawing.Size(950, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(248, 249, 250)
$form.TopMost = $true

# Функция для скругления углов
function Set-RoundedCorners {
    param($form, $radius = 20)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, $radius, $radius, 180, 90)
    $path.AddArc($form.Width - $radius, 0, $radius, $radius, -90, 90)
    $path.AddArc($form.Width - $radius, $form.Height - $radius, $radius, $radius, 0, 90)
    $path.AddArc(0, $form.Height - $radius, $radius, $radius, 90, 90)
    $path.CloseFigure()
    $form.Region = New-Object System.Drawing.Region($path)
}

# Создаем заголовок
$titlePanel = New-Object System.Windows.Forms.Panel
$titlePanel.Size = New-Object System.Drawing.Size(950, 80)
$titlePanel.Location = New-Object System.Drawing.Point(0, 0)
$titlePanel.BackColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
$titlePanel.BackgroundImageLayout = "Stretch"
$form.Controls.Add($titlePanel)

# Кнопка закрытия
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Size = New-Object System.Drawing.Size(35, 35)
$closeBtn.Location = New-Object System.Drawing.Point(900, 22)
$closeBtn.FlatStyle = "Flat"
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.BackColor = [System.Drawing.Color]::Transparent
$closeBtn.ForeColor = [System.Drawing.Color]::White
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$closeBtn.Text = "✕"
$closeBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$closeBtn.Add_Click({ $form.Close() })
$titlePanel.Controls.Add($closeBtn)

# Заголовок
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Активация лицензий Microsoft"
$titleLabel.Size = New-Object System.Drawing.Size(400, 40)
$titleLabel.Location = New-Object System.Drawing.Point(30, 25)
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titlePanel.Controls.Add($titleLabel)

# Подзаголовок
$subTitle = New-Object System.Windows.Forms.Label
$subTitle.Text = "Выберите продукты для активации"
$subTitle.Size = New-Object System.Drawing.Size(300, 25)
$subTitle.Location = New-Object System.Drawing.Point(32, 55)
$subTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$subTitle.ForeColor = [System.Drawing.Color]::FromArgb(200, 255, 255, 255)
$titlePanel.Controls.Add($subTitle)

# Панель для карточек
$cardsPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$cardsPanel.Size = New-Object System.Drawing.Size(890, 450)
$cardsPanel.Location = New-Object System.Drawing.Point(30, 100)
$cardsPanel.BackColor = [System.Drawing.Color]::Transparent
$cardsPanel.AutoScroll = $true
$cardsPanel.WrapContents = $true
$cardsPanel.Padding = New-Object System.Windows.Forms.Padding(5)
$form.Controls.Add($cardsPanel)

# Данные лицензий
$licenses = @(
    @{
        Name = "Windows 10"
        Color = [System.Drawing.Color]::FromArgb(0, 164, 239)
        Icon = "⊞"
        Status = $false
        Card = $null
        Indicator = $null
    },
    @{
        Name = "Windows 11"
        Color = [System.Drawing.Color]::FromArgb(0, 120, 212)
        Icon = "⊞"
        Status = $false
        Card = $null
        Indicator = $null
    },
    @{
        Name = "Windows Server"
        Color = [System.Drawing.Color]::FromArgb(44, 110, 158)
        Icon = "⚙"
        Status = $false
        Card = $null
        Indicator = $null
    },
    @{
        Name = "Office Professional"
        Color = [System.Drawing.Color]::FromArgb(216, 59, 1)
        Icon = "○"
        Status = $false
        Card = $null
        Indicator = $null
    },
    @{
        Name = "Visual Studio"
        Color = [System.Drawing.Color]::FromArgb(92, 45, 145)
        Icon = "◊"
        Status = $false
        Card = $null
        Indicator = $null
    },
    @{
        Name = "SQL Server"
        Color = [System.Drawing.Color]::FromArgb(204, 41, 39)
        Icon = "◆"
        Status = $false
        Card = $null
        Indicator = $null
    }
)

$activatedCount = 0
$totalLicenses = $licenses.Count

# Функция создания карточки
function New-LicenseCard {
    param($license, $index)
    
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size(280, 200)
    $card.BackColor = [System.Drawing.Color]::White
    $card.BorderStyle = "None"
    $card.Cursor = [System.Windows.Forms.Cursors]::Hand
    $card.Tag = $index
    $card.Padding = New-Object System.Windows.Forms.Padding(0)
    
    # Добавляем тень
    $card.Add_Paint({
        param($sender, $e)
        $rect = New-Object System.Drawing.Rectangle(0, 0, $sender.Width - 1, $sender.Height - 1)
        $e.Graphics.DrawRectangle([System.Drawing.Pens]::LightGray, $rect)
    })
    
    # Верхняя цветная полоса
    $colorBar = New-Object System.Windows.Forms.Panel
    $colorBar.Size = New-Object System.Drawing.Size(280, 5)
    $colorBar.Location = New-Object System.Drawing.Point(0, 0)
    $colorBar.BackColor = $license.Color
    $card.Controls.Add($colorBar)
    
    # Иконка
    $iconLabel = New-Object System.Windows.Forms.Label
    $iconLabel.Text = $license.Icon
    $iconLabel.Size = New-Object System.Drawing.Size(80, 80)
    $iconLabel.Location = New-Object System.Drawing.Point(100, 30)
    $iconLabel.Font = New-Object System.Drawing.Font("Segoe UI", 48, [System.Drawing.FontStyle]::Regular)
    $iconLabel.ForeColor = $license.Color
    $iconLabel.TextAlign = "MiddleCenter"
    $card.Controls.Add($iconLabel)
    
    # Название
    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $license.Name
    $nameLabel.Size = New-Object System.Drawing.Size(260, 30)
    $nameLabel.Location = New-Object System.Drawing.Point(10, 120)
    $nameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $nameLabel.TextAlign = "MiddleCenter"
    $nameLabel.ForeColor = [System.Drawing.Color]::FromArgb(51, 51, 51)
    $card.Controls.Add($nameLabel)
    
    # Статус
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "● Не активирована"
    $statusLabel.Size = New-Object System.Drawing.Size(260, 25)
    $statusLabel.Location = New-Object System.Drawing.Point(10, 155)
    $statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $statusLabel.TextAlign = "MiddleCenter"
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(153, 153, 153)
    $card.Controls.Add($statusLabel)
    
    # Индикатор
    $indicator = New-Object System.Windows.Forms.Panel
    $indicator.Size = New-Object System.Drawing.Size(12, 12)
    $indicator.Location = New-Object System.Drawing.Point(250, 15)
    $indicator.BackColor = [System.Drawing.Color]::FromArgb(204, 204, 204)
    $indicator.Visible = $false
    $card.Controls.Add($indicator)
    
    # Обработчик клика
    $card.Add_Click({
        param($sender, $e)
        $idx = $sender.Tag
        if (-not $licenses[$idx].Status) {
            Activate-License $idx
        }
    })
    
    $cardsPanel.Controls.Add($card)
    
    # Сохраняем ссылки
    $license.Card = $card
    $license.Indicator = $indicator
    $license.StatusLabel = $statusLabel
    
    return $card
}

# Функция активации
function Activate-License {
    param($index)
    
    $license = $licenses[$index]
    if ($license.Status) { return }
    
    # Создаем форму загрузки
    $loadingForm = New-Object System.Windows.Forms.Form
    $loadingForm.Text = "Активация"
    $loadingForm.Size = New-Object System.Drawing.Size(400, 200)
    $loadingForm.StartPosition = "CenterParent"
    $loadingForm.FormBorderStyle = "FixedDialog"
    $loadingForm.ControlBox = $false
    $loadingForm.BackColor = [System.Drawing.Color]::White
    $loadingForm.TopMost = $true
    
    # Заголовок
    $loadingTitle = New-Object System.Windows.Forms.Label
    $loadingTitle.Text = "Активация $($license.Name)"
    $loadingTitle.Size = New-Object System.Drawing.Size(360, 30)
    $loadingTitle.Location = New-Object System.Drawing.Point(20, 20)
    $loadingTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $loadingTitle.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
    $loadingForm.Controls.Add($loadingTitle)
    
    # Анимация загрузки
    $loadingSpinner = New-Object System.Windows.Forms.PictureBox
    $loadingSpinner.Size = New-Object System.Drawing.Size(50, 50)
    $loadingSpinner.Location = New-Object System.Drawing.Point(175, 70)
    $loadingSpinner.BackColor = [System.Drawing.Color]::Transparent
    $loadingSpinner.Image = [System.Drawing.SystemIcons]::Shield.ToBitmap()
    $loadingSpinner.SizeMode = "StretchImage"
    $loadingForm.Controls.Add($loadingSpinner)
    
    # Текст статуса
    $statusText = New-Object System.Windows.Forms.Label
    $statusText.Text = "Подготовка..."
    $statusText.Size = New-Object System.Drawing.Size(360, 25)
    $statusText.Location = New-Object System.Drawing.Point(20, 130)
    $statusText.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $statusText.TextAlign = "MiddleCenter"
    $loadingForm.Controls.Add($statusText)
    
    # Прогресс бар
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Size = New-Object System.Drawing.Size(360, 10)
    $progressBar.Location = New-Object System.Drawing.Point(20, 160)
    $progressBar.Style = "Continuous"
    $loadingForm.Controls.Add($progressBar)
    
    $loadingForm.Show()
    $loadingForm.Refresh()
    
    # Имитация процесса активации
    $steps = @(
        "Проверка лицензии...",
        "Подключение к серверу...",
        "Валидация ключа...",
        "Активация продукта...",
        "Сохранение настроек...",
        "Завершение..."
    )
    
    for ($i = 0; $i -lt $steps.Count; $i++) {
        $statusText.Text = $steps[$i]
        $progressBar.Value = [math]::Round(($i + 1) / $steps.Count * 100)
        $loadingForm.Refresh()
        Start-Sleep -Milliseconds 400
    }
    
    # Завершаем активацию
    $license.Status = $true
    $license.Indicator.Visible = $true
    $license.Indicator.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    $license.StatusLabel.Text = "✓ Активирована"
    $license.StatusLabel.ForeColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    $license.Card.BackColor = [System.Drawing.Color]::FromArgb(240, 255, 240)
    
    # Анимация индикатора
    for ($i = 1; $i -le 3; $i++) {
        $license.Indicator.Size = New-Object System.Drawing.Size(12 + $i*2, 12 + $i*2)
        $license.Indicator.Location = New-Object System.Drawing.Point(250 - $i, 15 - $i)
        $loadingForm.Refresh()
        Start-Sleep -Milliseconds 50
    }
    $license.Indicator.Size = New-Object System.Drawing.Size(12, 12)
    $license.Indicator.Location = New-Object System.Drawing.Point(250, 15)
    
    $loadingForm.Close()
    
    $script:activatedCount++
    Update-Progress
    
    # Проверяем все ли активированы
    if ($activatedCount -eq $totalLicenses) {
        Show-SuccessMessage
    }
}

# Обновление прогресса
function Update-Progress {
    $percent = [math]::Round(($activatedCount / $totalLicenses) * 100)
    $progressText.Text = "$percent%"
    $progressBarMain.Value = $percent
    
    # Анимация
    $progressText.ForeColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    Start-Sleep -Milliseconds 200
    $progressText.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
}

# Показать сообщение об успехе
function Show-SuccessMessage {
    $successForm = New-Object System.Windows.Forms.Form
    $successForm.Text = "Успех"
    $successForm.Size = New-Object System.Drawing.Size(350, 180)
    $successForm.StartPosition = "CenterParent"
    $successForm.FormBorderStyle = "FixedDialog"
    $successForm.ControlBox = $false
    $successForm.BackColor = [System.Drawing.Color]::White
    $successForm.TopMost = $true
    
    $successIcon = New-Object System.Windows.Forms.Label
    $successIcon.Text = "✓"
    $successIcon.Size = New-Object System.Drawing.Size(60, 60)
    $successIcon.Location = New-Object System.Drawing.Point(145, 20)
    $successIcon.Font = New-Object System.Drawing.Font("Segoe UI", 48, [System.Drawing.FontStyle]::Bold)
    $successIcon.ForeColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    $successIcon.TextAlign = "MiddleCenter"
    $successForm.Controls.Add($successIcon)
    
    $successMessage = New-Object System.Windows.Forms.Label
    $successMessage.Text = "Все лицензии успешно активированы!"
    $successMessage.Size = New-Object System.Drawing.Size(310, 30)
    $successMessage.Location = New-Object System.Drawing.Point(20, 90)
    $successMessage.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $successMessage.TextAlign = "MiddleCenter"
    $successForm.Controls.Add($successMessage)
    
    $okBtn = New-Object System.Windows.Forms.Button
    $okBtn.Text = "OK"
    $okBtn.Size = New-Object System.Drawing.Size(100, 35)
    $okBtn.Location = New-Object System.Drawing.Point(125, 130)
    $okBtn.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    $okBtn.ForeColor = [System.Drawing.Color]::White
    $okBtn.FlatStyle = "Flat"
    $okBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $okBtn.Add_Click({ $successForm.Close() })
    $successForm.Controls.Add($okBtn)
    
    $successForm.ShowDialog()
}

# Нижняя панель
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Size = New-Object System.Drawing.Size(950, 70)
$bottomPanel.Location = New-Object System.Drawing.Point(0, 560)
$bottomPanel.BackColor = [System.Drawing.Color]::White
$bottomPanel.BorderStyle = "None"
$form.Controls.Add($bottomPanel)

# Разделитель
$separator = New-Object System.Windows.Forms.Panel
$separator.Size = New-Object System.Drawing.Size(950, 1)
$separator.Location = New-Object System.Drawing.Point(0, 0)
$separator.BackColor = [System.Drawing.Color]::FromArgb(224, 224, 224)
$bottomPanel.Controls.Add($separator)

# Текст прогресса
$progressText = New-Object System.Windows.Forms.Label
$progressText.Text = "0%"
$progressText.Size = New-Object System.Drawing.Size(60, 40)
$progressText.Location = New-Object System.Drawing.Point(30, 15)
$progressText.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$progressText.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
$bottomPanel.Controls.Add($progressText)

# Прогресс бар
$progressBarMain = New-Object System.Windows.Forms.ProgressBar
$progressBarMain.Size = New-Object System.Drawing.Size(300, 10)
$progressBarMain.Location = New-Object System.Drawing.Point(30, 45)
$progressBarMain.Style = "Continuous"
$bottomPanel.Controls.Add($progressBarMain)

# Статус текст
$statusMain = New-Object System.Windows.Forms.Label
$statusMain.Text = "Готов к активации"
$statusMain.Size = New-Object System.Drawing.Size(200, 30)
$statusMain.Location = New-Object System.Drawing.Point(350, 25)
$statusMain.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusMain.ForeColor = [System.Drawing.Color]::FromArgb(102, 102, 102)
$bottomPanel.Controls.Add($statusMain)

# Кнопка активации всех
$activateAllBtn = New-Object System.Windows.Forms.Button
$activateAllBtn.Text = "Активировать все"
$activateAllBtn.Size = New-Object System.Drawing.Size(160, 45)
$activateAllBtn.Location = New-Object System.Drawing.Point(760, 12)
$activateAllBtn.BackColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
$activateAllBtn.ForeColor = [System.Drawing.Color]::White
$activateAllBtn.FlatStyle = "Flat"
$activateAllBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$activateAllBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$activateAllBtn.FlatAppearance.BorderSize = 0
$activateAllBtn.Add_Click({
    $statusMain.Text = "Активация всех лицензий..."
    $statusMain.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
    for ($i = 0; $i -lt $licenses.Count; $i++) {
        if (-not $licenses[$i].Status) {
            Activate-License $i
            Start-Sleep -Milliseconds 300
        }
    }
    $statusMain.Text = "Все лицензии активированы!"
    $statusMain.ForeColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
})
$bottomPanel.Controls.Add($activateAllBtn)

# Создаем все карточки
for ($i = 0; $i -lt $licenses.Count; $i++) {
    New-LicenseCard -license $licenses[$i] -index $i
}

# Применяем скругление углов
Set-RoundedCorners -form $form

# Показываем форму
$form.Add_Shown({
    $form.Activate()
    $form.TopMost = $true
})

# Запускаем форму
[System.Windows.Forms.Application]::Run($form)
