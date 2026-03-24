# ================================================
#   Красивая активация лицензий Microsoft (Fluent Design)
#   Исправленная версия — без ошибок умножения/вычитания
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===================== НАСТРОЙКИ =====================
$Width  = 960
$Height = 720
$MainBlue = [System.Drawing.Color]::FromArgb(43, 87, 151)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Активация лицензий Microsoft"
$form.Size = New-Object System.Drawing.Size($Width, $Height)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
$form.ForeColor = "White"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Скругление главного окна
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 18
$path.AddArc(0, 0, $r*2, $r*2, 180, 90)
$path.AddArc($Width-$r*2, 0, $r*2, $r*2, 270, 90)
$path.AddArc($Width-$r*2, $Height-$r*2, $r*2, $r*2, 0, 90)
$path.AddArc(0, $Height-$r*2, $r*2, $r*2, 90, 90)
$form.Region = New-Object System.Drawing.Region($path)

# ===================== ЗАГОЛОВОК =====================
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Dock = "Top"
$titleBar.Height = 56
$titleBar.BackColor = $MainBlue

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Активация лицензий Microsoft"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 15)
$titleLabel.ForeColor = "White"
$titleLabel.Location = New-Object System.Drawing.Point(24, 14)
$titleLabel.AutoSize = $true
$titleBar.Controls.Add($titleLabel)

# Кнопка закрытия
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "✕"
$closeBtn.Size = New-Object System.Drawing.Size(46, 46)
$closeBtn.Location = New-Object System.Drawing.Point($Width - 56, 5)
$closeBtn.FlatStyle = "Flat"
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.ForeColor = "White"
$closeBtn.BackColor = $MainBlue
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 16)
$closeBtn.Add_MouseEnter({ $this.BackColor = "#E81123" })
$closeBtn.Add_MouseLeave({ $this.BackColor = $MainBlue })
$closeBtn.Add_Click({ $form.Close() })
$titleBar.Controls.Add($closeBtn)

$form.Controls.Add($titleBar)

# ===================== ПРОДУКТЫ =====================
$products = @(
    @{Name="Windows 10";          Icon="⊞"; Color="#00A4EF"},
    @{Name="Windows 11";          Icon="⊞"; Color="#0078D4"},
    @{Name="Windows Server";      Icon="⚙"; Color="#2C6E9E"},
    @{Name="Office Professional"; Icon="○"; Color="#D83B01"},
    @{Name="Visual Studio";       Icon="◊"; Color="#5C2D91"},
    @{Name="SQL Server";          Icon="◆"; Color="#CC2927"}
)

$cards = @()
$activatedCount = 0

$cardWidth = 278
$cardHeight = 162
$startX = 40
$startY = 90
$spacing = 24

for ($i = 0; $i -lt $products.Count; $i++) {
    $p = $products[$i]
    $col = $i % 2
    $row = [math]::Floor($i / 2)

    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size($cardWidth, $cardHeight)
    $card.Location = New-Object System.Drawing.Point($startX + $col * ($cardWidth + $spacing), 
                                                     $startY + $row * ($cardHeight + $spacing))
    $card.BackColor = "#2D2D2D"
    $card.Tag = $p

    # Цветная полоса сверху
    $topBar = New-Object System.Windows.Forms.Panel
    $topBar.Height = 8
    $topBar.Dock = "Top"
    $topBar.BackColor = [System.Drawing.ColorTranslator]::FromHtml($p.Color)
    $card.Controls.Add($topBar)

    # Иконка
    $icon = New-Object System.Windows.Forms.Label
    $icon.Text = $p.Icon
    $icon.Font = New-Object System.Drawing.Font("Segoe UI", 52)
    $icon.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($p.Color)
    $icon.Location = New-Object System.Drawing.Point(24, 28)
    $icon.AutoSize = $true
    $card.Controls.Add($icon)

    # Название продукта
    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $p.Name
    $nameLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
    $nameLabel.Location = New-Object System.Drawing.Point(110, 38)
    $nameLabel.AutoSize = $true
    $card.Controls.Add($nameLabel)

    # Статус "Не активировано"
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "Не активировано"
    $statusLabel.ForeColor = "#999999"
    $statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $statusLabel.Location = New-Object System.Drawing.Point(110, 68)
    $statusLabel.AutoSize = $true
    $card.Controls.Add($statusLabel)

    # Индикатор "Активирована"
    $successLabel = New-Object System.Windows.Forms.Label
    $successLabel.Text = "✓ Активирована"
    $successLabel.ForeColor = "#00CC6A"
    $successLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
    $successLabel.Location = New-Object System.Drawing.Point(110, 92)
    $successLabel.AutoSize = $true
    $successLabel.Visible = $false
    $card.Controls.Add($successLabel)

    # Эффекты наведения
    $card.Add_MouseEnter({ $this.BackColor = "#3A3A3A" })
    $card.Add_MouseLeave({ $this.BackColor = "#2D2D2D" })

    # Клик по карточке
    $card.Add_Click({
        if ($this.Tag.Activated) { return }
        Show-BeautifulActivationModal -Product $this.Tag -Card $this
    })

    $form.Controls.Add($card)
    $cards += $card
}

# ===================== КРАСИВОЕ МОДАЛЬНОЕ ОКНО =====================
function Show-BeautifulActivationModal {
    param($Product, $Card)

    $modal = New-Object System.Windows.Forms.Form
    $modal.Size = New-Object System.Drawing.Size(460, 260)
    $modal.StartPosition = "CenterParent"
    $modal.FormBorderStyle = "None"
    $modal.BackColor = "#1F1F1F"

    # Скругление модального окна
    $mp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = 16
    $mp.AddArc(0,0,$r*2,$r*2,180,90)
    $mp.AddArc(460-$r*2,0,$r*2,$r*2,270,90)
    $mp.AddArc(460-$r*2,260-$r*2,$r*2,$r*2,0,90)
    $mp.AddArc(0,260-$r*2,$r*2,$r*2,90,90)
    $modal.Region = New-Object System.Drawing.Region($mp)

    $mTitle = New-Object System.Windows.Forms.Label
    $mTitle.Text = "Активация продукта"
    $mTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
    $mTitle.Location = New-Object System.Drawing.Point(32, 24)
    $modal.Controls.Add($mTitle)

    $mProdName = New-Object System.Windows.Forms.Label
    $mProdName.Text = $Product.Name
    $mProdName.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $mProdName.ForeColor = "#CCCCCC"
    $mProdName.Location = New-Object System.Drawing.Point(32, 52)
    $modal.Controls.Add($mProdName)

    $progress = New-Object System.Windows.Forms.ProgressBar
    $progress.Size = New-Object System.Drawing.Size(396, 10)
    $progress.Location = New-Object System.Drawing.Point(32, 110)
    $progress.Maximum = 100
    $modal.Controls.Add($progress)

    $mStatus = New-Object System.Windows.Forms.Label
    $mStatus.Text = "Подключение к серверам Microsoft..."
    $mStatus.ForeColor = "#AAAAAA"
    $mStatus.Location = New-Object System.Drawing.Point(32, 135)
    $modal.Controls.Add($mStatus)

    $modal.Show()
    $modal.Refresh()

    $steps = @("Проверка лицензии...", "Подключение к серверам активации...", "Валидация ключа продукта...", "Активация продукта...")
    
    for ($i = 0; $i -lt $steps.Count; $i++) {
        $mStatus.Text = $steps[$i]
        $progress.Value = ($i + 1) * 25
        $modal.Refresh()
        Start-Sleep -Milliseconds 650
    }

    # Активация завершена
    $Product.Activated = $true
    $global:activatedCount++

    $successLbl = $Card.Controls | Where-Object { $_.Text -like "✓*" }
    $notActLbl  = $Card.Controls | Where-Object { $_.Text -eq "Не активировано" }

    if ($notActLbl)  { $notActLbl.Visible = $false }
    if ($successLbl) { $successLbl.Visible = $true }

    $Card.BackColor = "#1E3A2F"
    $Card.Controls[0].BackColor = "#00CC6A"   # топ-бар становится зелёным

    # Пульсация галочки
    for ($i = 0; $i -lt 4; $i++) {
        $successLbl.ForeColor = "#00FF99"
        Start-Sleep -Milliseconds 160
        $successLbl.ForeColor = "#00CC6A"
        Start-Sleep -Milliseconds 160
    }

    $modal.Close()
    Update-ProgressBar

    if ($global:activatedCount -eq $products.Count) {
        [System.Windows.Forms.MessageBox]::Show("Все продукты успешно активированы!", 
            "Поздравляем!", "OK", "Information")
    }
}

# ===================== НИЖНЯЯ ПАНЕЛЬ =====================
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Height = 85
$bottomPanel.Dock = "Bottom"
$bottomPanel.BackColor = "#252525"

$progressTotal = New-Object System.Windows.Forms.ProgressBar
$progressTotal.Size = New-Object System.Drawing.Size(520, 12)
$progressTotal.Location = New-Object System.Drawing.Point(40, 22)
$progressTotal.Maximum = 100
$bottomPanel.Controls.Add($progressTotal)

$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.Text = "0% активировано"
$percentLabel.Location = New-Object System.Drawing.Point(40, 48)
$percentLabel.ForeColor = "White"
$percentLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$bottomPanel.Controls.Add($percentLabel)

$activateAll = New-Object System.Windows.Forms.Button
$activateAll.Text = "Активировать все"
$activateAll.Size = New-Object System.Drawing.Size(190, 42)
$activateAll.Location = New-Object System.Drawing.Point($Width - 230, 22)
$activateAll.BackColor = "#0078D4"
$activateAll.ForeColor = "White"
$activateAll.FlatStyle = "Flat"
$activateAll.FlatAppearance.BorderSize = 0
$activateAll.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$activateAll.Add_Click({
    foreach ($card in $cards) {
        if (-not $card.Tag.Activated) {
            Show-BeautifulActivationModal -Product $card.Tag -Card $card
            Start-Sleep -Milliseconds 300
        }
    }
})
$bottomPanel.Controls.Add($activateAll)

$form.Controls.Add($bottomPanel)

# ===================== ФУНКЦИЯ ОБНОВЛЕНИЯ ПРОГРЕССА =====================
function Update-ProgressBar {
    $percent = [math]::Round(($global:activatedCount / $products.Count) * 100)
    $progressTotal.Value = $percent
    $percentLabel.Text = "$percent% активировано"
}

# ===================== ЗАПУСК =====================
Update-ProgressBar
$form.ShowDialog() | Out-Null
