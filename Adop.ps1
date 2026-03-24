# ================================================
#   Активация лицензий Microsoft — Визуальный инструмент
#   Стиль: Microsoft Fluent Design
#   Автор: Grok (по твоему запросу)
#   Работает на PowerShell 5.0+
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===================== НАСТРОЙКИ =====================
$WindowWidth = 950
$WindowHeight = 700
$MainColor = [System.Drawing.Color]::FromArgb(43, 87, 151)   # #2B5797
$AccentColor = [System.Drawing.Color]::FromArgb(0, 120, 212)

# ===================== ФОРМА =====================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Активация лицензий Microsoft"
$form.Size = New-Object System.Drawing.Size($WindowWidth, $WindowHeight)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Скругление углов окна
$gp = New-Object System.Drawing.Drawing2D.GraphicsPath
$radius = 16
$gp.AddArc(0, 0, $radius*2, $radius*2, 180, 90)
$gp.AddArc($WindowWidth-$radius*2, 0, $radius*2, $radius*2, 270, 90)
$gp.AddArc($WindowWidth-$radius*2, $WindowHeight-$radius*2, $radius*2, $radius*2, 0, 90)
$gp.AddArc(0, $WindowHeight-$radius*2, $radius*2, $radius*2, 90, 90)
$form.Region = New-Object System.Drawing.Region($gp)

# ===================== ЗАГОЛОВОК =====================
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Height = 50
$titleBar.Dock = "Top"
$titleBar.BackColor = $MainColor

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Активация лицензий Microsoft"
$titleLabel.ForeColor = "White"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 14)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(20, 12)
$titleBar.Controls.Add($titleLabel)

# Кнопка закрытия
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "✕"
$closeBtn.Size = New-Object System.Drawing.Size(40, 40)
$closeBtn.Location = New-Object System.Drawing.Point($WindowWidth-50, 5)
$closeBtn.FlatStyle = "Flat"
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.ForeColor = "White"
$closeBtn.BackColor = $MainColor
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$closeBtn.Add_MouseEnter({ $closeBtn.BackColor = [System.Drawing.Color]::FromArgb(232, 17, 35) })
$closeBtn.Add_MouseLeave({ $closeBtn.BackColor = $MainColor })
$closeBtn.Add_Click({ $form.Close() })
$titleBar.Controls.Add($closeBtn)

$form.Controls.Add($titleBar)

# ===================== ПРОДУКТЫ =====================
$products = @(
    @{Name="Windows 10";          Icon="⊞"; Color=[System.Drawing.Color]::FromArgb(0,164,239);   Activated=$false},
    @{Name="Windows 11";          Icon="⊞"; Color=[System.Drawing.Color]::FromArgb(0,120,212);   Activated=$false},
    @{Name="Windows Server";      Icon="⚙"; Color=[System.Drawing.Color]::FromArgb(44,110,158); Activated=$false},
    @{Name="Office Professional"; Icon="○"; Color=[System.Drawing.Color]::FromArgb(216,59,1);    Activated=$false},
    @{Name="Visual Studio";       Icon="◊"; Color=[System.Drawing.Color]::FromArgb(92,45,145);  Activated=$false},
    @{Name="SQL Server";          Icon="◆"; Color=[System.Drawing.Color]::FromArgb(204,41,39);  Activated=$false}
)

$cards = @()
$activatedCount = 0

# Создаём карточки
$row = 0
$col = 0
$cardWidth = 280
$cardHeight = 160
$padding = 20

foreach ($prod in $products) {
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size($cardWidth, $cardHeight)
    $card.Location = New-Object System.Drawing.Point(40 + $col*($cardWidth + $padding), 80 + $row*($cardHeight + $padding))
    $card.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
    $card.BorderStyle = "None"
    $card.Tag = $prod

    # Цветная полоса сверху
    $topBar = New-Object System.Windows.Forms.Panel
    $topBar.Height = 6
    $topBar.Dock = "Top"
    $topBar.BackColor = $prod.Color
    $card.Controls.Add($topBar)

    # Иконка
    $icon = New-Object System.Windows.Forms.Label
    $icon.Text = $prod.Icon
    $icon.Font = New-Object System.Drawing.Font("Segoe UI", 48)
    $icon.ForeColor = $prod.Color
    $icon.AutoSize = $true
    $icon.Location = New-Object System.Drawing.Point(20, 25)
    $card.Controls.Add($icon)

    # Название
    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $prod.Name
    $nameLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
    $nameLabel.ForeColor = "White"
    $nameLabel.Location = New-Object System.Drawing.Point(90, 35)
    $nameLabel.AutoSize = $true
    $card.Controls.Add($nameLabel)

    # Статус
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "Не активировано"
    $statusLabel.ForeColor = "#888888"
    $statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $statusLabel.Location = New-Object System.Drawing.Point(90, 65)
    $statusLabel.AutoSize = $true
    $card.Controls.Add($statusLabel)

    # Индикатор активации (изначально скрыт)
    $activatedIndicator = New-Object System.Windows.Forms.Label
    $activatedIndicator.Text = "✓ Активирована"
    $activatedIndicator.ForeColor = "#00CC6A"
    $activatedIndicator.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
    $activatedIndicator.Location = New-Object System.Drawing.Point(90, 85)
    $activatedIndicator.AutoSize = $true
    $activatedIndicator.Visible = $false
    $card.Controls.Add($activatedIndicator)

    # Эффект наведения
    $card.Add_MouseEnter({
        $this.BackColor = [System.Drawing.Color]::FromArgb(55, 55, 55)
        $this.Cursor = "Hand"
    })
    $card.Add_MouseLeave({
        $this.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
    })

    # Клик по карточке
    $card.Add_Click({
        $prod = $this.Tag
        if ($prod.Activated) { return }

        Show-ActivationModal -Product $prod -Card $this
    })

    $form.Controls.Add($card)
    $cards += $card

    $col++
    if ($col -ge 2) { $col = 0; $row++ }
}

# ===================== МОДАЛЬНОЕ ОКНО АКТИВАЦИИ =====================
function Show-ActivationModal {
    param($Product, $Card)

    $modal = New-Object System.Windows.Forms.Form
    $modal.Text = "Активация — $($Product.Name)"
    $modal.Size = New-Object System.Drawing.Size(420, 280)
    $modal.StartPosition = "CenterParent"
    $modal.FormBorderStyle = "None"
    $modal.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
    $modal.ForeColor = "White"

    # Скругление модального окна
    $mgp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $mr = 12
    $mgp.AddArc(0,0,$mr*2,$mr*2,180,90)
    $mgp.AddArc(400-$mr*2,0,$mr*2,$mr*2,270,90)
    $mgp.AddArc(400-$mr*2,260,$mr*2,$mr*2,0,90)
    $mgp.AddArc(0,260,$mr*2,$mr*2,90,90)
    $modal.Region = New-Object System.Drawing.Region($mgp)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "Выполняется активация $($Product.Name)..."
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $lbl.Location = New-Object System.Drawing.Point(40, 40)
    $lbl.AutoSize = $true
    $modal.Controls.Add($lbl)

    $progress = New-Object System.Windows.Forms.ProgressBar
    $progress.Style = "Marquee"
    $progress.Size = New-Object System.Drawing.Size(340, 20)
    $progress.Location = New-Object System.Drawing.Point(40, 100)
    $modal.Controls.Add($progress)

    $statusText = New-Object System.Windows.Forms.Label
    $statusText.Text = "Проверка лицензии..."
    $statusText.ForeColor = "#AAAAAA"
    $statusText.Location = New-Object System.Drawing.Point(40, 140)
    $statusText.AutoSize = $true
    $modal.Controls.Add($statusText)

    $modal.Show()
    $modal.Refresh()

    $steps = @("Проверка лицензии", "Подключение к серверу активации", "Валидация ключа", "Активация продукта")
    
    foreach ($step in $steps) {
        $statusText.Text = $step
        $modal.Refresh()
        Start-Sleep -Milliseconds 800
    }

    # Успешная активация
    $Product.Activated = $true
    $global:activatedCount++

    # Обновляем карточку
    $indicator = $Card.Controls | Where-Object { $_ -is [System.Windows.Forms.Label] -and $_.Text -like "✓*" }
    $statusLbl = $Card.Controls | Where-Object { $_ -is [System.Windows.Forms.Label] -and $_.Text -eq "Не активировано" }
    
    if ($statusLbl) { $statusLbl.Visible = $false }
    $indicator.Visible = $true

    # Плавное изменение цвета карточки
    $Card.BackColor = [System.Drawing.Color]::FromArgb(40, 55, 40)
    $topBar = $Card.Controls[0]
    $topBar.BackColor = [System.Drawing.Color]::FromArgb(0, 204, 106)

    # Пульсация индикатора
    for ($i = 0; $i -lt 3; $i++) {
        $indicator.ForeColor = "#00FF88"
        $modal.Refresh(); Start-Sleep -Milliseconds 200
        $indicator.ForeColor = "#00CC6A"
        $modal.Refresh(); Start-Sleep -Milliseconds 200
    }

    $modal.Close()

    Update-ProgressBar

    if ($global:activatedCount -eq $products.Count) {
        [System.Windows.Forms.MessageBox]::Show(
            "Поздравляем!`n`nВсе продукты успешно активированы.", 
            "Активация завершена", 
            "OK", 
            "Information"
        )
    }
}

# ===================== ПРОГРЕСС-БАР И НИЖНЯЯ ПАНЕЛЬ =====================
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Height = 80
$bottomPanel.Dock = "Bottom"
$bottomPanel.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(500, 12)
$progressBar.Location = New-Object System.Drawing.Point(40, 20)
$progressBar.Style = "Continuous"
$progressBar.Maximum = 100
$bottomPanel.Controls.Add($progressBar)

$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.Text = "0% активировано"
$percentLabel.ForeColor = "White"
$percentLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$percentLabel.Location = New-Object System.Drawing.Point(40, 45)
$bottomPanel.Controls.Add($percentLabel)

$activateAllBtn = New-Object System.Windows.Forms.Button
$activateAllBtn.Text = "Активировать все"
$activateAllBtn.Size = New-Object System.Drawing.Size(180, 40)
$activateAllBtn.Location = New-Object System.Drawing.Point($WindowWidth - 220, 20)
$activateAllBtn.BackColor = $AccentColor
$activateAllBtn.ForeColor = "White"
$activateAllBtn.FlatStyle = "Flat"
$activateAllBtn.FlatAppearance.BorderSize = 0
$activateAllBtn.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$activateAllBtn.Add_Click({
    foreach ($card in $cards) {
        $prod = $card.Tag
        if (-not $prod.Activated) {
            Show-ActivationModal -Product $prod -Card $card
            Start-Sleep -Milliseconds 300
        }
    }
})
$bottomPanel.Controls.Add($activateAllBtn)

$form.Controls.Add($bottomPanel)

# ===================== ОБНОВЛЕНИЕ ПРОГРЕССА =====================
function Update-ProgressBar {
    $percent = [math]::Round(($global:activatedCount / $products.Count) * 100)
    $progressBar.Value = $percent
    $percentLabel.Text = "$percent% активировано"
}

# ===================== ЗАПУСК =====================
Update-ProgressBar
$form.ShowDialog() | Out-Null
