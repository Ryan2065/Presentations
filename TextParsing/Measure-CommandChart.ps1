Function Measure-CommandChart {
    Param(
        [ScriptBlock[]]$ScriptBlocks,
        [string[]]$ScriptBlockNames,
        [int]$Times = 10
    )
    Class CommandChartResult{
        [String]$Name
        [TimeSpan]$Timespan
        CommandChartResult($strName, $Ts){
            $this.Name = $strName
            $this.Timespan = $Ts
        }
    }
    Class CommandChartFinalResult{
        [string]$Name
        [TimeSpan]$TotalTime
        [double]$AverageSeconds
        [double]$AverageMilliseconds
        CommandChartFinalResult($strName, $TTime, $Times){
            $this.Name = $strName
            $this.TotalTime = $TTime
            $this.AverageSeconds = $this.TotalTime.TotalSeconds / $Times
            $this.AverageMilliseconds = $this.TotalTime.TotalMilliseconds / $Times
        }
    }
    $Results = New-Object -TypeName System.Collections.Generic.List[CommandChartResult]
    $hash = [hashtable]::Synchronized(@{})
    $FinalResults
    $hash.Complete = $false
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable('Hash',$hash)
    $powershell = [powershell]::Create()
    $powershell.Runspace = $runspace
    $null = $powershell.AddScript({
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization
        $FinalResults = $Hash.FinalResults
        $TimesRun = $Hash.TimesRun
        if([string]::IsNullOrEmpty($TimesRUn)){
            $TimesRun = 0
        }
        $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
        $Chart.Width = 500 
        $Chart.Height = 400 
        $Chart.Left = 40 
        $Chart.Top = 30
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
        $Chart.ChartAreas.Add($ChartArea)
        [void]$Chart.Series.Add("Data")
        $Chart.Series["Data"].Points.DataBindXY($FinalResults.Name, $FinalResults.AverageMilliseconds)
        $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
        
        $TotalChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
        $TotalChart.Width = 500 
        $TotalChart.Height = 400 
        $TotalChart.Left = 40 
        $TotalChart.Top = 30
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
        $TotalChart.ChartAreas.Add($ChartArea)
        [void]$TotalChart.Series.Add("Data")
        $TotalChart.Series["Data"].Points.DataBindXY($FinalResults.Name, $FinalResults.TotalTime.TotalMilliseconds)
        $TotalChart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
        
        $Form = New-Object Windows.Forms.Form 
        $Form.Text = "Measure-Command - Times Run: $TimesRun"
        $Form.Width = 600 
        $Form.Height = 900
        $Form.controls.add($Chart)
        $Form.Controls.Add($TotalChart)
        $Form.TopMost = $true
        $Form.Add_Shown({$Form.Activate()})
        [void]$Form.Show()
        while($hash.Complete -eq $false) {
            [System.Windows.Forms.Application]::DoEvents()
            if($Hash.FinalResults -ne $FinalResults) {
                $Form.controls.clear()
                $FinalResults = $Hash.FinalResults
                $TimesRun = $Hash.TimesRun
                $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
                $Chart.Width = 500 
                $Chart.Height = 400 
                $Chart.Left = 40 
                $Chart.Top = 30
                $chart.Name = 'Average'
                $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
                $Chart.ChartAreas.Add($ChartArea)
                [void]$Chart.Series.Add("Data")
                $Chart.Series["Data"].Points.DataBindXY($FinalResults.Name, $FinalResults.AverageMilliseconds)
                $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
                $Form.controls.add($Chart)
                $TotalChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
                $TotalChart.Width = 500 
                $TotalChart.Height = 400 
                $TotalChart.Left = 40 
                $TotalChart.Top = 450
                
                $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
                $TotalChart.ChartAreas.Add($ChartArea)
                [void]$TotalChart.Series.Add("Data")
                $TotalChart.Series["Data"].Points.DataBindXY($FinalResults.Name, $FinalResults.TotalTime.TotalMilliseconds)
                $TotalChart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
                $Form.Controls.Add($TotalChart)
                $Form.Text = "Measure-Command - Times Run: $TimesRun"
                [System.Windows.Forms.Application]::DoEvents()
            }
            Start-sleep -Milliseconds 200
        }
        $Form.controls.clear()
        $FinalResults = $Hash.FinalResults
        $TimesRun = $Hash.TimesRun
        $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
        $Chart.Width = 500 
        $Chart.Height = 400 
        $Chart.Left = 40 
        $Chart.Top = 30
        $chart.Name = 'Average'
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
        $Chart.ChartAreas.Add($ChartArea)
        [void]$Chart.Series.Add("Data")
        $Chart.Series["Data"].Points.DataBindXY($FinalResults.Name, $FinalResults.AverageMilliseconds)
        $Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
        $Form.controls.add($Chart)
        $TotalChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
        $TotalChart.Width = 500 
        $TotalChart.Height = 400 
        $TotalChart.Left = 40 
        $TotalChart.Top = 450
        
        $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
        $TotalChart.ChartAreas.Add($ChartArea)
        [void]$TotalChart.Series.Add("Data")
        $TotalChart.Series["Data"].Points.DataBindXY($FinalResults.Name, $FinalResults.TotalTime.TotalMilliseconds)
        $TotalChart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
        $Form.Controls.Add($TotalChart)
        $Form.Text = "Measure-Command - Times Run: $TimesRun"
        while($true){
            [System.Windows.Forms.Application]::DoEvents()
            start-sleep -Milliseconds 200
        }
    })
    $null = $powershell.BeginInvoke()
    $count = 0
    while($count -lt $Times){
        $count++
        $IndexArray = New-Object -TypeName System.Collections.Generic.List[int]
        while($IndexArray.count -ne $ScriptBlocks.count){
            $MaxNumber = $ScriptBlocks.Count
            $RandomNumber = Get-Random -Minimum 0 -Maximum $MaxNumber
            if($IndexArray -notcontains $RandomNumber){
                $IndexArray.Add($RandomNumber)
            }
        }
        foreach($Index in $IndexArray){
            $StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
            $StopWatch.Start()
            $null = . $ScriptBlocks[$Index]
            $StopWatch.Stop()
            $Results.Add([CommandChartResult]::new($ScriptBlockNames[$Index], $StopWatch.Elapsed))
        }
        $HashResults = @{}
        Foreach($result in $results){
            $HashResults[$result.Name] += $result.Timespan
        }
        $FinalResults = New-Object -Type System.Collections.Generic.List[CommandChartFinalResult]
        foreach($key in $HashResults.Keys){
            $FinalResults.Add([CommandChartFinalResult]::new($key, $HashResults[$key], $Times))
        }
        $hash.FinalResults = $FinalResults
        $Hash.TimesRun = $count
    }
    $hash.complete = $true
    $FinalResults

}