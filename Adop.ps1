# Visual License Activation System - Windows License Activator
# Стиль Microsoft Office с визуальной загрузкой

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.VisualStyles

# Создаем главную форму
$form = New-Object System.Windows.Forms.Form
$form.Text = "Активация лицензий"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(242, 242, 242)
$form.TopMost = $true

# Добавляем тень
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("user32.dll")]
public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
[DllImport("user32.dll")]
public static extern int GetWindowLong(IntPtr hWnd, int nIndex);
[DllImport("user32.dll")]
public static extern bool SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
'

# Создаем панель для скругления
$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Size = New-Object System.Drawing.Size(780, 580)
$mainPanel.Location = New-Object System.Drawing.Point(10, 10)
$mainPanel.BackColor = [System.Drawing.Color]::White
$mainPanel.BorderStyle = "None"
$form.Controls.Add($mainPanel)

# Кнопка закрытия
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Size = New-Object System.Drawing.Size(30, 30)
$closeBtn.Location = New-Object System.Drawing.Point(740, 10)
$closeBtn.FlatStyle = "Flat"
$closeBtn.FlatAppearance.BorderSize = 0
$closeBtn.BackColor = [System.Drawing.Color]::Transparent
$closeBtn.ForeColor = [System.Drawing.Color]::FromArgb(102, 102, 102)
$closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$closeBtn.Text = "✕"
$closeBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$closeBtn.Add_Click({ $form.Close() })
$mainPanel.Controls.Add($closeBtn)

# Заголовок с иконкой
$iconPanel = New-Object System.Windows.Forms.Panel
$iconPanel.Size = New-Object System.Drawing.Size(80, 80)
$iconPanel.Location = New-Object System.Drawing.Point(350, 30)
$iconPanel.BackColor = [System.Drawing.Color]::Transparent
$mainPanel.Controls.Add($iconPanel)

# Иконка Windows
$windowsIcon = New-Object System.Windows.Forms.PictureBox
$windowsIcon.Size = New-Object System.Drawing.Size(80, 80)
$windowsIcon.Location = New-Object System.Drawing.Point(0, 0)
$windowsIcon.BackColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
$windowsIcon.Image = [System.Drawing.SystemIcons]::Application.ToBitmap()
$windowsIcon.SizeMode = "StretchImage"
$iconPanel.Controls.Add($windowsIcon)

# Массив для хранения статусов лицензий
$licenses = @(
    @{Name="Windows 10"; Color=[System.Drawing.Color]::FromArgb(0,164,239); Status=$false; Indicator=$null; Card=$null},
    @{Name="Windows 11"; Color=[System.Drawing.Color]::FromArgb(0,120,212); Status=$false; Indicator=$null; Card=$null},
    @{Name="Windows Server"; Color=[System.Drawing.Color]::FromArgb(44,110,158); Status=$false; Indicator=$null; Card=$null},
    @{Name="Office Professional"; Color=[System.Drawing.Color]::FromArgb(216,59,1); Status=$false; Indicator=$null; Card=$null},
    @{Name="Visual Studio"; Color=[System.Drawing.Color]::FromArgb(92,45,145); Status=$false; Indicator=$null; Card=$null},
    @{Name="SQL Server"; Color=[System.Drawing.Color]::FromArgb(204,41,39); Status=$false; Indicator=$null; Card=$null}
)

$totalLicenses = $licenses.Count
$activatedCount = 0

# Создаем панель для карточек
$cardsPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$cardsPanel.Size = New-Object System.Drawing.Size(720, 350)
$cardsPanel.Location = New-Object System.Drawing.Point(30, 130)
$cardsPanel.BackColor = [System.Drawing.Color]::Transparent
$cardsPanel.AutoScroll = $true
$cardsPanel.WrapContents = $true
$mainPanel.Controls.Add($cardsPanel)

# Функция создания карточки лицензии
function Create-LicenseCard {
    param($license, $index)
    
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size(220, 180)
    $card.BackColor = [System.Drawing.Color]::White
    $card.BorderStyle = "None"
    $card.Cursor = [System.Windows.Forms.Cursors]::Hand
    $card.Tag = $index
    
    # Тень
    $card.Add_Paint({
        param($sender, $e)
        $sender.CreateGraphics().DrawRectangle([System.Drawing.Pens]::LightGray, 0, 0, $sender.Width - 1, $sender.Height - 1)
    })
    
    # Цветная полоса сверху
    $colorBar = New-Object System.Windows.Forms.Panel
    $colorBar.Size = New-Object System.Drawing.Size(220, 5)
    $colorBar.Location = New-Object System.Drawing.Point(0, 0)
    $colorBar.BackColor = $license.Color
    $card.Controls.Add($colorBar)
    
    # Иконка продукта
    $productIcon = New-Object System.Windows.Forms.PictureBox
    $productIcon.Size = New-Object System.Drawing.Size(60, 60)
    $productIcon.Location = New-Object System.Drawing.Point(80, 20)
    $productIcon.BackColor = [System.Drawing.Color]::White
    $productIcon.Image = [System.Drawing.SystemIcons]::Information.ToBitmap()
    $productIcon.SizeMode = "StretchImage"
    $card.Controls.Add($productIcon)
    
    # Название продукта
    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = $license.Name
    $nameLabel.Size = New-Object System.Drawing.Size(200, 30)
    $nameLabel.Location = New-Object System.Drawing.Point(10, 100)
    $nameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $nameLabel.TextAlign = "MiddleCenter"
    $nameLabel.ForeColor = [System.Drawing.Color]::FromArgb(51, 51, 51)
    $card.Controls.Add($nameLabel)
    
    # Индикатор статуса (зеленая точка)
    $indicator = New-Object System.Windows.Forms.Panel
    $indicator.Size = New-Object System.Drawing.Size(12, 12)
    $indicator.Location = New-Object System.Drawing.Point(190, 10)
    $indicator.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    $indicator.Visible = $false
    $card.Controls.Add($indicator)
    
    # Добавляем обработчик клика
    $card.Add_Click({
        param($sender, $e)
        $idx = $sender.Tag
        if (-not $licenses[$idx].Status) {
            Activate-License $idx
        }
    })
    
    $cardsPanel.Controls.Add($card)
    
    # Сохраняем ссылки
    $license.Indicator = $indicator
    $license.Card = $card
    
    return $card
}

# Функция активации лицензии
function Activate-License {
    param($index)
    
    $license = $licenses[$index]
    if ($license.Status) { return }
    
    # Показываем оверлей загрузки
    $overlay.Visible = $true
    $loadingMessage.Text = "Активация $($license.Name)..."
    $progressBar.Value = 0
    
    # Имитация процесса активации
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 30
    $progress = 0
    
    $timer.Add_Tick({
        $progress += 2
        $progressBar.Value = $progress
        
        if ($progress -ge 100) {
            $timer.Stop()
            
            # Отмечаем как активированную
            $license.Status = $true
            $license.Indicator.Visible = $true
            
            # Анимация индикатора
            $license.Indicator.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
            
            # Анимация фона карточки
            $license.Card.BackColor = [System.Drawing.Color]::FromArgb(230, 255, 230)
            $updateTimer = New-Object System.Windows.Forms.Timer
            $updateTimer.Interval = 500
            $updateTimer.Add_Tick({
                $license.Card.BackColor = [System.Drawing.Color]::White
                $updateTimer.Stop()
            })
            $updateTimer.Start()
            
            $script:activatedCount++
            Update-Progress
            
            $overlay.Visible = $false
            $progressBar.Value = 0
            
            # Проверяем все ли активированы
            if ($activatedCount -eq $totalLicenses) {
                Show-SuccessMessage
            }
        }
    })
    
    $timer.Start()
}

# Функция обновления прогресса
function Update-Progress {
    $percent = [math]::Round(($activatedCount / $totalLicenses) * 100)
    $progressText.Text = "$percent%"
    
    # Анимация текста
    $progressText.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
    $fadeTimer = New-Object System.Windows.Forms.Timer
    $fadeTimer.Interval = 200
    $fadeTimer.Add_Tick({
        $progressText.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
        $fadeTimer.Stop()
    })
    $fadeTimer.Start()
}

# Функция показа сообщения об успехе
function Show-SuccessMessage {
    $successPanel = New-Object System.Windows.Forms.Panel
    $successPanel.Size = New-Object System.Drawing.Size(300, 60)
    $successPanel.Location = New-Object System.Drawing.Point(240, 80)
    $successPanel.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
    $successPanel.BorderStyle = "None"
    
    $successLabel = New-Object System.Windows.Forms.Label
    $successLabel.Text = "✓ Все лицензии успешно активированы"
    $successLabel.Size = New-Object System.Drawing.Size(280, 40)
    $successLabel.Location = New-Object System.Drawing.Point(10, 10)
    $successLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $successLabel.ForeColor = [System.Drawing.Color]::White
    $successLabel.TextAlign = "MiddleCenter"
    $successPanel.Controls.Add($successLabel)
    
    $mainPanel.Controls.Add($successPanel)
    $successPanel.BringToFront()
    
    $hideTimer = New-Object System.Windows.Forms.Timer
    $hideTimer.Interval = 3000
    $hideTimer.Add_Tick({
        $mainPanel.Controls.Remove($successPanel)
        $hideTimer.Stop()
    })
    $hideTimer.Start()
    
    # Останавливаем анимацию загрузки
    $loadingRing.Visible = $false
    $progressText.Text = "100% ✓"
    $progressText.ForeColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
}

# Создаем все карточки
for ($i = 0; $i -lt $licenses.Count; $i++) {
    Create-LicenseCard -license $licenses[$i] -index $i
}

# Нижняя панель с прогрессом
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Size = New-Object System.Drawing.Size(780, 80)
$bottomPanel.Location = New-Object System.Drawing.Point(0, 490)
$bottomPanel.BackColor = [System.Drawing.Color]::Transparent
$mainPanel.Controls.Add($bottomPanel)

# Анимация загрузки (вращающееся кольцо)
$loadingRing = New-Object System.Windows.Forms.PictureBox
$loadingRing.Size = New-Object System.Drawing.Size(30, 30)
$loadingRing.Location = New-Object System.Drawing.Point(20, 25)
$loadingRing.BackColor = [System.Drawing.Color]::Transparent
$loadingRing.Image = [System.Drawing.SystemIcons]::Shield.ToBitmap()
$loadingRing.SizeMode = "StretchImage"
$bottomPanel.Controls.Add($loadingRing)

# Текст прогресса
$progressText = New-Object System.Windows.Forms.Label
$progressText.Text = "0%"
$progressText.Size = New-Object System.Drawing.Size(50, 30)
$progressText.Location = New-Object System.Drawing.Point(60, 25)
$progressText.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$progressText.ForeColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
$bottomPanel.Controls.Add($progressText)

# Кнопка активации всех
$activateAllBtn = New-Object System.Windows.Forms.Button
$activateAllBtn.Text = "Активировать все"
$activateAllBtn.Size = New-Object System.Drawing.Size(150, 40)
$activateAllBtn.Location = New-Object System.Drawing.Point(610, 20)
$activateAllBtn.FlatStyle = "Flat"
$activateAllBtn.BackColor = [System.Drawing.Color]::FromArgb(43, 87, 151)
$activateAllBtn.ForeColor = [System.Drawing.Color]::White
$activateAllBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$activateAllBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
$activateAllBtn.FlatAppearance.BorderSize = 0
$activateAllBtn.Add_Click({
    for ($i = 0; $i -lt $licenses.Count; $i++) {
        if (-not $licenses[$i].Status) {
            Activate-License $i
            Start-Sleep -Milliseconds 200
        }
    }
})
$bottomPanel.Controls.Add($activateAllBtn)

# Оверлей загрузки
$overlay = New-Object System.Windows.Forms.Panel
$overlay.Size = New-Object System.Drawing.Size(780, 580)
$overlay.Location = New-Object System.Drawing.Point(0, 0)
$overlay.BackColor = [System.Drawing.Color]::FromArgb(128, 0, 0, 0)
$overlay.Visible = $false
$mainPanel.Controls.Add($overlay)

# Панель загрузки
$loadingPanel = New-Object System.Windows.Forms.Panel
$loadingPanel.Size = New-Object System.Drawing.Size(300, 200)
$loadingPanel.Location = New-Object System.Drawing.Point(240, 190)
$loadingPanel.BackColor = [System.Drawing.Color]::White
$loadingPanel.BorderStyle = "None"
$overlay.Controls.Add($loadingPanel)

# Иконка загрузки в оверлее
$loadingIcon = New-Object System.Windows.Forms.PictureBox
$loadingIcon.Size = New-Object System.Drawing.Size(60, 60)
$loadingIcon.Location = New-Object System.Drawing.Point(120, 30)
$loadingIcon.BackColor = [System.Drawing.Color]::Transparent
$loadingIcon.Image = [System.Drawing.SystemIcons]::Information.ToBitmap()
$loadingIcon.SizeMode = "StretchImage"
$loadingPanel.Controls.Add($loadingIcon)

# Сообщение загрузки
$loadingMessage = New-Object System.Windows.Forms.Label
$loadingMessage.Text = "Активация..."
$loadingMessage.Size = New-Object System.Drawing.Size(250, 30)
$loadingMessage.Location = New-Object System.Drawing.Point(25, 100)
$loadingMessage.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$loadingMessage.TextAlign = "MiddleCenter"
$loadingPanel.Controls.Add($loadingMessage)

# Прогресс-бар
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(250, 10)
$progressBar.Location = New-Object System.Drawing.Point(25, 140)
$progressBar.Style = "Continuous"
$loadingPanel.Controls.Add($progressBar)

# Анимация вращения для загрузочного кольца
$rotateTimer = New-Object System.Windows.Forms.Timer
$rotateTimer.Interval = 50
$rotateAngle = 0
$rotateTimer.Add_Tick({
    $rotateAngle += 10
    $loadingRing.Image.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone)
    $loadingRing.Refresh()
})
$rotateTimer.Start()

# Показываем форму
$form.Add_Shown({
    $form.Activate()
    $form.TopMost = $true
})

# Применяем скругление углов
Add-Type -AssemblyName System.Drawing
$roundedPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$roundedPath.AddArc(0, 0, 20, 20, 180, 90)
$roundedPath.AddArc($form.Width - 20, 0, 20, 20, -90, 90)
$roundedPath.AddArc($form.Width - 20, $form.Height - 20, 20, 20, 0, 90)
$roundedPath.AddArc(0, $form.Height - 20, 20, 20, 90, 90)
$roundedPath.CloseFigure()

$form.Region = New-Object System.Drawing.Region($roundedPath)

# Запускаем форму
[System.Windows.Forms.Application]::Run($form)