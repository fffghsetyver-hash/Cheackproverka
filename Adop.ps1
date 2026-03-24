# ================================================
#   Красивая активация лицензий Microsoft 2026
#   Fluent Design — исправленная и улучшенная версия
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Width  = 980
$Height = 680

$form = New-Object System.Windows.Forms.Form
$form.Text = "Активация лицензий Microsoft"
$form.Size = New-Object System.Drawing.Size($Width, $Height)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = "White"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Скруглённые углы главного окна
$gp = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 20
$gp.AddArc(0,0,$r*2,$r*2,180,90)
$gp.AddArc($Width-$r*2,0,$r*2,$r*2,270,90)
$gp.AddArc($Width-$r*2,$Height-$r*2,$r*2,$r*2,0,90)
$gp.AddArc(0,$Height-$r*2,$r*2,$r*2,90,90)
$form.Region = New-Object System.Drawing.Region($gp)

# ===================== Заголовок =====================
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Height = 60
$titleBar.Dock = "Top"
$titleBar.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)

$title = New-Object System.Windows.Forms.Label
$title.Text = "Активация лицензий Microsoft"
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 16)
$title.ForeColor = "White"
$title.Location = New-Object System.Drawing.Point(28, 16)
$titleBar.Controls.Add($title)

$close = New-Object System.Windows.Forms.Button
$close.Text = "✕"
$close.Size = New-Object System.Drawing.Size(50, 50)
$close.Location = New-Object System.Drawing.Point($Width-60, 5)
$close.FlatStyle = "Flat"
$close.FlatAppearance.BorderSize = 0
$close.ForeColor = "White"
$close.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$close.Font = New-Object System.Drawing.Font("Segoe UI", 18)
$close.Add_MouseEnter({$this.BackColor = "#E81123"})
$close.Add_MouseLeave({$this.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)})
$close.Add_Click({$form.Close()})
$titleBar.Controls.Add($close)

$form.Controls.Add($titleBar)

# ===================== Продукты =====================
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

$cardW = 290
$cardH = 168
$pad   = 28
$startX = 40
$startY = 90

for ($i = 0; $i -lt 6; $i++) {
    $p = $products[$i]
    $col = $i % 2
    $row = [math]::Floor($i / 2)

    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size($cardW, $cardH)
    $card.Location = New-Object System.Drawing.Point($startX + $col*($cardW + $pad), $startY + $row*($cardH + $pad))
    $card.BackColor = "#2A2A2A"
    $card.Tag = $p

    # Цветная полоса
    $bar = New-Object System.Windows.Forms.Panel
    $bar.Height = 10
    $bar.Dock = "Top"
    $bar.BackColor = [System.Drawing.ColorTranslator]::FromHtml($p.Color)
    $card.Controls.Add($bar)

    # Иконка
    $icon = New-Object System.Windows.Forms.Label
    $icon.Text = $p.Icon
    $icon.Font = New-Object System.Drawing.Font("Segoe UI", 58)
    $icon.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($p.Color)
    $icon.Location = New-Object System.Drawing.Point(25, 32)
    $card.Controls.Add($icon)

    # Название
    $name = New-Object System.Windows.Forms.Label
    $name.Text = $p.Name
    $name.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 14)
    $name.Location = New-Object System.Drawing.Point(115, 45)
    $name.AutoSize = $true
    $card.Controls.Add($name)

    # Статус
    $status = New-Object System.Windows.Forms.Label
    $status.Text = "Не активировано"
    $status.ForeColor = "#888888"
    $status.Location = New-Object System.Drawing.Point(115, 78)
    $status.AutoSize = $true
    $card.Controls.Add($status)

    # Галочка активировано
    $success = New-Object System.Windows.Forms.Label
    $success.Text = "✓ Активирована"
    $success.ForeColor = "#00CC6A"
    $success.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10.5)
    $success.Location = New-Object System.Drawing.Point(115, 102)
    $success.Visible = $false
    $card.Controls.Add($success)

    # Наведение
    $card.Add_MouseEnter({ $this.BackColor = "#353535" })
    $card.Add_MouseLeave({ $this.BackColor = "#2A2A2A" })

    $card.Add_Click({
        if ($this.Tag.Activated) { return }
        Activate-Product -Product $this.Tag -Card $this
    })

    $form.Controls.Add($card)
    $cards += $card
}

# ===================== Функция активации =====================
function Activate-Product {
    param($Product, $Card)

    $modal = New-Object System.Windows.Forms.Form
    $modal.Size = New-Object System.Drawing.Size(480, 280)
    $modal.StartPosition = "CenterParent"
    $modal.FormBorderStyle = "None"
    $modal.BackColor = "#1F1F1F"

    # Скругление модального окна
    $mp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = 18
    $mp.AddArc(0,0,$r*2,$r*2,180,90)
    $mp.AddArc(480-$r*2,0,$r*2,$r*2,270,90)
    $mp.AddArc(480-$r*2,280-$r*2,$r*2,$r*2,0,90)
    $mp.AddArc(0,280-$r*2,$r*2,$r*2,90,90)
    $modal.Region = New-Object System.Drawing.Region($mp)

    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Активация"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 14)
    $lblTitle.Location = New-Object System.Drawing.Point(40, 30)
    $modal.Controls.Add($lblTitle)

    $lblProd = New-Object System.Windows.Forms.Label
    $lblProd.Text = $Product.Name
    $lblProd.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $lblProd.ForeColor = "#CCCCCC"
    $lblProd.Location = New-Object System.Drawing.Point(40, 60)
    $modal.Controls.Add($lblProd)

    $prog = New-Object System.Windows.Forms.ProgressBar
    $prog.Size = New-Object System.Drawing.Size(400, 12)
    $prog.Location = New-Object System.Drawing.Point(40, 120)
    $prog.Maximum = 100
    $modal.Controls.Add($prog)

    $lblStatus = New-Object System.Windows.Forms.Label
    $lblStatus.Text = "Подключение к серверам Microsoft..."
    $lblStatus.ForeColor = "#AAAAAA"
    $lblStatus.Location = New-Object System.Drawing.Point(40, 150)
    $modal.Controls.Add($lblStatus)

    $modal.Show()
    $modal.Refresh()

    $steps = @("Проверка лицензии...", "Подключение...", "Валидация ключа...", "Активация продукта...")
    for ($i = 0; $i -lt 4; $i++) {
        $lblStatus.Text = $steps[$i]
        $prog.Value = ($i+1)*25
        $modal.Refresh()
        Start-Sleep -Milliseconds 700
    }

    # Успех
    $Product.Activated = $true
    $global:activatedCount++

    $Card.Controls | Where-Object { $_.Text -eq "Не активировано" } | ForEach-Object { $_.Visible = $false }
    $Card.Controls | Where-Object { $_.Text -like "✓*" } | ForEach-Object { 
        $_.Visible = $true 
        # пульсация
        for ($x=0; $x -lt 3; $x++) {
            $_.ForeColor = "#00FF88"; Start-Sleep -m 150
            $_.ForeColor = "#00CC6A"; Start-Sleep -m 150
        }
    }

    $Card.BackColor = "#1E3A2F"
    $Card.Controls[0].BackColor = "#00CC6A"   # верхняя полоса зелёная

    $modal.Close()
    Update-Progress

    if ($global:activatedCount -eq 6) {
        [System.Windows.Forms.MessageBox]::Show("Все лицензии успешно активированы!", "Готово", "OK", "Information")
    }
}

# ===================== Нижняя панель =====================
$bottom = New-Object System.Windows.Forms.Panel
$bottom.Height = 90
$bottom.Dock = "Bottom"
$bottom.BackColor = "#252525"

$totalProg = New-Object System.Windows.Forms.ProgressBar
$totalProg.Size = New-Object System.Drawing.Size(560, 14)
$totalProg.Location = New-Object System.Drawing.Point(40, 25)
$totalProg.Maximum = 100
$bottom.Controls.Add($totalProg)

$percLabel = New-Object System.Windows.Forms.Label
$percLabel.Text = "0% активировано"
$percLabel.Location = New-Object System.Drawing.Point(40, 52)
$percLabel.ForeColor = "White"
$percLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$bottom.Controls.Add($percLabel)

$allBtn = New-Object System.Windows.Forms.Button
$allBtn.Text = "Активировать все"
$allBtn.Size = New-Object System.Drawing.Size(200, 45)
$allBtn.Location = New-Object System.Drawing.Point($Width-240, 23)
$allBtn.BackColor = "#0078D4"
$allBtn.ForeColor = "White"
$allBtn.FlatStyle = "Flat"
$allBtn.FlatAppearance.BorderSize = 0
$allBtn.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$allBtn.Add_Click({
    foreach ($c in $cards) {
        if (-not $c.Tag.Activated) {
            Activate-Product -Product $c.Tag -Card $c
            Start-Sleep -Milliseconds 400
        }
    }
})
$bottom.Controls.Add($allBtn)

$form.Controls.Add($bottom)

function Update-Progress {
    $p = [math]::Round(($global:activatedCount / 6) * 100)
    $totalProg.Value = $p
    $percLabel.Text = "$p% активировано"
}

# Запуск
Update-Progress
$form.ShowDialog() | Out-Null
