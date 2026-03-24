# ================================================
#   Красивая активация лицензий Microsoft (Fluent Design)
#   Исправленная версия — красивое модальное окно
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===================== НАСТРОЙКИ =====================
$W = 960
$H = 720
$MainBlue = [System.Drawing.Color]::FromArgb(43, 87, 151)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Активация лицензий Microsoft"
$form.Size = New-Object System.Drawing.Size($W, $H)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
$form.ForeColor = "White"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)

# Скругление главного окна
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 18
$path.AddArc(0, 0, $r*2, $r*2, 180, 90)
$path.AddArc($W-$r*2, 0, $r*2, $r*2, 270, 90)
$path.AddArc($W-$r*2, $H-$r*2, $r*2, $r*2, 0, 90)
$path.AddArc(0, $H-$r*2, $r*2, $r*2, 90, 90)
$form.Region = New-Object System.Drawing.Region($path)

# ===================== ЗАГОЛОВОК =====================
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Dock = "Top"
$titleBar.Height = 56
$titleBar.BackColor = $MainBlue

$title = New-Object System.Windows.Forms.Label
$title.Text = "Активация лицензий Microsoft"
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 15)
$title.ForeColor = "White"
$title.Location = New-Object System.Drawing.Point(24, 14)
$title.AutoSize = $true
$titleBar.Controls.Add($title)

$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "✕"
$closeBtn.Size = New-Object System.Drawing.Size(46, 46)
$closeBtn.Location = New-Object System.Drawing.Point($W-56, 5)
$closeBtn.FlatStyle = "Flat"
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.ForeColor = "White"
$closeBtn.BackColor = $MainBlue
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 16)
$closeBtn.Add_MouseEnter({$this.BackColor = "#E81123"})
$closeBtn.Add_MouseLeave({$this.BackColor = $MainBlue})
$closeBtn.Add_Click({$form.Close()})
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

$cardW = 278
$cardH = 162
$startX = 40
$startY = 90
$spacing = 24

for ($i = 0; $i -lt $products.Count; $i++) {
    $p = $products[$i]
    $col = $i % 2
    $row = [math]::Floor($i / 2)

    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size($cardW, $cardH)
    $card.Location = New-Object System.Drawing.Point($startX + $col*($cardW + $spacing), $startY + $row*($cardH + $spacing))
    $card.BackColor = "#2D2D2D"
    $card.Tag = $p

    # Цветная полоса
    $bar = New-Object System.Windows.Forms.Panel
    $bar.Height = 8
    $bar.Dock = "Top"
    $bar.BackColor = [System.Drawing.ColorTranslator]::FromHtml($p.Color)
    $card.Controls.Add($bar)

    # Иконка
    $icon = New-Object System.Windows.Forms.Label
    $icon.Text = $p.Icon
    $icon.Font = New-Object System.Drawing.Font("Segoe UI", 52)
    $icon.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($p.Color)
    $icon.Location = New-Object System.Drawing.Point(24, 28)
    $icon.AutoSize = $true
    $card.Controls.Add($icon)

    # Название
    $lblName = New-Object System.Windows.Forms.Label
    $lblName.Text = $p.Name
    $lblName.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
    $lblName.Location = New-Object System.Drawing.Point(110, 38)
    $lblName.AutoSize = $true
    $card.Controls.Add($lblName)

    # Статус
    $lblStatus = New-Object System.Windows.Forms.Label
    $lblStatus.Text = "Не активировано"
    $lblStatus.ForeColor = "#999999"
    $lblStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $lblStatus.Location = New-Object System.Drawing.Point(110, 68)
    $lblStatus.AutoSize = $true
    $card.Controls.Add($lblStatus)

    # Индикатор успеха
    $lblSuccess = New-Object System.Windows.Forms.Label
    $lblSuccess.Text = "✓ Активирована"
    $lblSuccess.ForeColor = "#00CC6A"
    $lblSuccess.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
    $lblSuccess.Location = New-Object System.Drawing.Point(110, 92)
    $lblSuccess.AutoSize = $true
    $lblSuccess.Visible = $false
    $card.Controls.Add($lblSuccess)

    # Эффекты
    $card.Add_MouseEnter({ $this.BackColor = "#3A3A3A" })
    $card.Add_MouseLeave({ $this.BackColor = "#2D2D2D" })

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
    $mpath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = 16
    $mpath.AddArc(0,0,$r*2,$r*2,180,90)
    $mpath.AddArc(460-$r*2,0,$r*2,$r*2,270,90)
    $mpath.AddArc(460-$r*2,260-$r*2,$r*2,$r*2,0,90)
    $mpath.AddArc(0,260-$r*2,$r*2,$r*2,90,90)
    $modal.Region = New-Object System.Drawing.Region($mpath)

    # Заголовок модального окна
    $mTitle = New-Object System.Windows.Forms.Label
    $mTitle.Text = "Активация продукта"
    $mTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
    $mTitle.Location = New-Object System.Drawing.Point(32, 24)
    $mTitle.AutoSize = $true
    $modal.Controls.Add($mTitle)

    $mProduct = New-Object System.Windows.Forms.Label
    $mProduct.Text = $Product.Name
    $mProduct.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $mProduct.ForeColor = "#CCCCCC"
    $mProduct.Location = New-Object System.Drawing.Point(32, 52)
    $mProduct.AutoSize = $true
    $modal.Controls.Add($mProduct)

    # Прогресс-бар
    $prog = New-Object System.Windows.Forms.ProgressBar
    $prog.Size = New-Object System.Drawing.Size(396, 10)
    $prog.Location = New-Object System.Drawing.Point(32, 110)
    $prog.Style = "Continuous"
    $prog.Maximum = 100
    $modal.Controls.Add($prog)

    # Текст статуса
    $mStatus = New-Object System.Windows.Forms.Label
    $mStatus.Text = "Подключение к серверам Microsoft..."
    $mStatus.ForeColor = "#AAAAAA"
    $mStatus.Location = New-Object System.Drawing.Point(32, 135)
    $mStatus.AutoSize = $true
    $modal.Controls.Add($mStatus)

    $modal.Show()
    $modal.Refresh()

    $steps = @(
        "Проверка лицензии...",
        "Подключение к серверам активации...",
        "Валидация ключа продукта...",
        "Активация продукта..."
    )

    for ($i = 0; $i -lt $steps.Count; $i++) {
        $mStatus.Text = $steps[$i]
        $prog.Value = ($i + 1) * 25
        $modal.Refresh()
        Start-Sleep -Milliseconds 650
    }

    # Успешная активация
    $Product.Activated = $true
    $global:activatedCount++

    $successLabel = $Card.Controls | Where-Object { $_.Text -like "✓*" }
    $notActivatedLabel = $Card.Controls | Where-Object { $_.Text -eq "Не активировано" }

    if ($notActivatedLabel) { $notActivatedLabel.Visible = $false }
    $successLabel.Visible = $true

    # Изменение цвета карточки
    $Card.BackColor = "#1E3A2F"
    $topBar = $Card.Controls[0]
    $topBar.BackColor = "#00CC6A"

    # Пульсация галочки
    for ($i = 0; $i -lt 4; $i++) {
        $successLabel.ForeColor = "#00FF99"
        Start-Sleep -Milliseconds 180
        $successLabel.ForeColor = "#00CC6A"
        Start-Sleep -Milliseconds 180
    }

    $modal.Close()

    Update-Progress

    if ($global:activatedCount -eq $products.Count) {
        [System.Windows.Forms.MessageBox]::Show("Все лицензии успешно активированы!`n`nСпасибо, что выбрали Microsoft.", 
            "Поздравляем!", "OK", "Information")
    }
}

# ===================== НИЖНЯЯ ПАНЕЛЬ =====================
$bottom = New-Object System.Windows.Forms.Panel
$bottom.Height = 85
$bottom.Dock = "Bottom"
$bottom.BackColor = "#252525"

$progTotal = New-Object System.Windows.Forms.ProgressBar
$progTotal.Size = New-Object System.Drawing.Size(520, 12)
$progTotal.Location = New-Object System.Drawing.Point(40, 22)
$progTotal.Maximum = 100
$bottom.Controls.Add($progTotal)

$percentText = New-Object System.Windows.Forms.Label
$percentText.Text = "0% активировано"
$percentText.Location = New-Object System.Drawing.Point(40, 48)
$percentText.ForeColor = "White"
$percentText.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$bottom.Controls.Add($percentText)

$allBtn = New-Object System.Windows.Forms.Button
$allBtn.Text = "Активировать все"
$allBtn.Size = New-Object System.Drawing.Size(190, 42)
$allBtn.Location = New-Object System.Drawing.Point($W-230, 22)
$allBtn.BackColor = "#0078D4"
$allBtn.ForeColor = "White"
$allBtn.FlatStyle = "Flat"
$allBtn.FlatAppearance.BorderSize = 0
$allBtn.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$allBtn.Add_Click({
    foreach ($c in $cards) {
        if (-not $c.Tag.Activated) {
            Show-BeautifulActivationModal -Product $c.Tag -Card $c
            Start-Sleep -Milliseconds 250
        }
    }
})
$bottom.Controls.Add($allBtn)

$form.Controls.Add($bottom)

function Update-Progress {
    $perc = [math]::Round(($global:activatedCount / $products.Count) * 100)
    $progTotal.Value = $perc
    $percentText.Text = "$perc% активировано"
}

# ===================== ЗАПУСК =====================
Update-Progress
$form.ShowDialog() | Out-Null
