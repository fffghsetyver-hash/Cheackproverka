# ================================================
#   Adop.ps1 — Программа скачивания в стиле современного сайта (как React)
#   Тёмный Fluent Design + фильтр по категориям + FAQ
# ================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Width  = 1100
$Height = 780

$form = New-Object System.Windows.Forms.Form
$form.Text = "Программы для скачивания"
$form.Size = New-Object System.Drawing.Size($Width, $Height)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28)
$form.ForeColor = "White"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Скруглённые углы окна
$gp = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 20
$gp.AddArc(0,0,$r*2,$r*2,180,90)
$gp.AddArc($Width-$r*2,0,$r*2,$r*2,270,90)
$gp.AddArc($Width-$r*2,$Height-$r*2,$r*2,$r*2,0,90)
$gp.AddArc(0,$Height-$r*2,$r*2,$r*2,90,90)
$form.Region = New-Object System.Drawing.Region($gp)

# ===================== Заголовок =====================
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Height = 65
$titleBar.Dock = "Top"
$titleBar.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)

$title = New-Object System.Windows.Forms.Label
$title.Text = "Программы для скачивания"
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 17)
$title.ForeColor = "White"
$title.Location = New-Object System.Drawing.Point(30, 18)
$titleBar.Controls.Add($title)

$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "✕"
$closeBtn.Size = New-Object System.Drawing.Size(50, 50)
$closeBtn.Location = New-Object System.Drawing.Point($Width-60, 8)
$closeBtn.FlatStyle = "Flat"
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.ForeColor = "White"
$closeBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 18)
$closeBtn.Add_MouseEnter({$this.BackColor = "#E81123"})
$closeBtn.Add_MouseLeave({$this.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)})
$closeBtn.Add_Click({$form.Close()})
$titleBar.Controls.Add($closeBtn)

$form.Controls.Add($titleBar)

# ===================== Данные =====================
$categories = @("Все", "Windows", "Office", "Разработка", "Серверы", "Базы данных")

$programs = @(
    @{Id=1; Name="Windows 10 Pro";          Category="Windows";     Downloads=12450; Url="https://example.com/win10.iso"},
    @{Id=2; Name="Windows 11 Home";         Category="Windows";     Downloads=8750;  Url="https://example.com/win11.iso"},
    @{Id=3; Name="Microsoft Office 2024";   Category="Office";      Downloads=32400; Url="https://example.com/office.iso"},
    @{Id=4; Name="Visual Studio 2022";      Category="Разработка";  Downloads=18900; Url="https://example.com/vs.exe"},
    @{Id=5; Name="Windows Server 2022";     Category="Серверы";     Downloads=5600;  Url="https://example.com/server.iso"},
    @{Id=6; Name="SQL Server 2022";         Category="Базы данных"; Downloads=12400; Url="https://example.com/sql.iso"}
)

$selectedCategory = "Все"
$downloading = $null

# ===================== Кнопки категорий =====================
$catPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$catPanel.Location = New-Object System.Drawing.Point(30, 80)
$catPanel.Size = New-Object System.Drawing.Size(1040, 50)
$catPanel.FlowDirection = "LeftToRight"
$catPanel.WrapContents = $true
$form.Controls.Add($catPanel)

function UpdateCategoryButtons {
    $catPanel.Controls.Clear()
    foreach ($cat in $categories) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $cat
        $btn.AutoSize = $true
        $btn.Height = 36
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderSize = 0
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $btn.Padding = New-Object System.Windows.Forms.Padding(15, 8, 15, 8)

        if ($cat -eq $selectedCategory) {
            $btn.BackColor = "#00FF88"
            $btn.ForeColor = "Black"
        } else {
            $btn.BackColor = "#3A3A3A"
            $btn.ForeColor = "White"
        }

        $btn.Add_Click({
            $global:selectedCategory = $this.Text
            UpdateCategoryButtons
            RenderPrograms
        })

        $catPanel.Controls.Add($btn)
    }
}

# ===================== Сетка программ =====================
$programsPanel = New-Object System.Windows.Forms.Panel
$programsPanel.Location = New-Object System.Drawing.Point(30, 150)
$programsPanel.Size = New-Object System.Drawing.Size(1040, 380)
$form.Controls.Add($programsPanel)

function RenderPrograms {
    $programsPanel.Controls.Clear()

    $filtered = if ($selectedCategory -eq "Все") { $programs } 
                else { $programs | Where-Object { $_.Category -eq $selectedCategory } }

    $x = 0; $y = 0
    $cardW = 320; $cardH = 160; $spacing = 20

    foreach ($prog in $filtered) {
        $card = New-Object System.Windows.Forms.Panel
        $card.Size = New-Object System.Drawing.Size($cardW, $cardH)
        $card.Location = New-Object System.Drawing.Point($x, $y)
        $card.BackColor = "#2A2A2A"
        $card.BorderStyle = "FixedSingle"

        $nameLbl = New-Object System.Windows.Forms.Label
        $nameLbl.Text = $prog.Name
        $nameLbl.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 12)
        $nameLbl.Location = New-Object System.Drawing.Point(20, 20)
        $nameLbl.AutoSize = $true
        $card.Controls.Add($nameLbl)

        $catLbl = New-Object System.Windows.Forms.Label
        $catLbl.Text = $prog.Category
        $catLbl.ForeColor = "#888888"
        $catLbl.Location = New-Object System.Drawing.Point(20, 48)
        $catLbl.AutoSize = $true
        $card.Controls.Add($catLbl)

        $dlLbl = New-Object System.Windows.Forms.Label
        $dlLbl.Text = "$($prog.Downloads) скачиваний"
        $dlLbl.ForeColor = "#AAAAAA"
        $dlLbl.Location = New-Object System.Drawing.Point(20, 75)
        $dlLbl.AutoSize = $true
        $card.Controls.Add($dlLbl)

        $dlBtn = New-Object System.Windows.Forms.Button
        $dlBtn.Text = "Скачать"
        $dlBtn.Size = New-Object System.Drawing.Size(110, 36)
        $dlBtn.Location = New-Object System.Drawing.Point(190, 110)
        $dlBtn.BackColor = "#00CC6A"
        $dlBtn.ForeColor = "Black"
        $dlBtn.FlatStyle = "Flat"
        $dlBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

        $dlBtn.Add_Click({
            if ($global:downloading) { return }
            $global:downloading = $prog.Id
            $this.Text = "Загрузка..."
            $this.Enabled = $false
            $form.Refresh()

            Start-Sleep -Milliseconds 1800   # имитация скачивания

            [System.Windows.Forms.MessageBox]::Show("Файл $($prog.Name) начал скачиваться!", "Загрузка", "OK", "Information")

            $this.Text = "Скачать"
            $this.Enabled = $true
            $global:downloading = $null
        })

        $card.Controls.Add($dlBtn)
        $programsPanel.Controls.Add($card)

        $x += $cardW + $spacing
        if ($x -gt 700) { $x = 0; $y += $cardH + $spacing }
    }
}

# ===================== FAQ =====================
$faqPanel = New-Object System.Windows.Forms.Panel
$faqPanel.Location = New-Object System.Drawing.Point(30, 560)
$faqPanel.Size = New-Object System.Drawing.Size(1040, 160)
$faqPanel.BackColor = "#1F1F1F"
$form.Controls.Add($faqPanel)

$faqTitle = New-Object System.Windows.Forms.Label
$faqTitle.Text = "Часто задаваемые вопросы (FAQ)"
$faqTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 14)
$faqTitle.Location = New-Object System.Drawing.Point(0, 10)
$faqPanel.Controls.Add($faqTitle)

$faqText = New-Object System.Windows.Forms.Label
$faqText.Text = "• Как скачать? — Авторизуйтесь и нажмите кнопку Скачать`n• Безопасно ли? — Да, все файлы проверяются`n• Проблемы? — Создайте тикет в поддержке"
$faqText.Location = New-Object System.Drawing.Point(0, 50)
$faqText.AutoSize = $true
$faqText.ForeColor = "#CCCCCC"
$faqPanel.Controls.Add($faqText)

# ===================== Запуск =====================
UpdateCategoryButtons
RenderPrograms
$form.ShowDialog() | Out-Null
