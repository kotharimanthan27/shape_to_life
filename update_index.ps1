$ErrorActionPreference = "Stop"

# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find the most recently created HTML report
$latestHtml = Get-ChildItem -Path (Join-Path $scriptDir "AutomationReport_*.html") | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $latestHtml) {
    Write-Host "No AutomationReport found in $scriptDir"
    exit
}

# Extract timestamp
$fileName = $latestHtml.Name
if ($fileName -match "AutomationReport_(.*)\.html") {
    $timestamp = $matches[1]
} else {
    Write-Host "Could not extract timestamp from $fileName"
    exit
}

Write-Host "Latest timestamp found: $timestamp"

# Create the index.html content
$indexContent = @"
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Automation Reports</title>
  <style>
    :root {
      color-scheme: light;
      font-family: Arial, Helvetica, sans-serif;
      color: #1f2937;
      background: #f5f7fb;
    }

    body {
      margin: 0;
      padding: 32px;
    }

    main {
      max-width: 860px;
      margin: 0 auto;
    }

    h1 {
      margin: 0 0 8px;
      font-size: 32px;
      line-height: 1.2;
    }

    p {
      margin: 0 0 24px;
      color: #5b6472;
    }

    ul {
      display: grid;
      gap: 12px;
      margin: 0;
      padding: 0;
      list-style: none;
    }

    a {
      display: block;
      padding: 16px 18px;
      border: 1px solid #d8dee9;
      border-radius: 8px;
      color: #075985;
      background: #fff;
      text-decoration: none;
      font-weight: 700;
    }

    a:hover,
    a:focus {
      border-color: #0ea5e9;
      color: #0369a1;
    }
  </style>
</head>

<body>
  <main>
    <h1>Automation Reports</h1>
    <p>Latest generated report files.</p>
    <ul>
      <li><a href="AutomationReport_$timestamp.html">Open HTML report</a></li>
      <li><a href="AutomationReport_$timestamp.pdf">Open PDF report</a></li>
      <li><a href="ExecutionLog_$timestamp.log">Open execution log</a></li>
    </ul>
  </main>
</body>

</html>
"@

# Write to index.html
$indexPath = Join-Path $scriptDir "index.html"
Set-Content -Path $indexPath -Value $indexContent
Write-Host "Successfully updated index.html with links for timestamp: $timestamp"
