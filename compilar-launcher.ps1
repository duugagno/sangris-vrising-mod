# Script para Compilar Launcher Standalone
# Uso: .\compilar-launcher.ps1

param(
    [string]$Tipo = "single-file"  # single-file, standalone, ou all
)

$LauncherPath = "d:\ProjetosC#\WinFormsApp1"
$ProjectFile = "WinFormsApp1/WinFormsApp1.csproj"

Write-Host "🚀 Compilando Sangria Launcher..." -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

Set-Location $LauncherPath

# Limpar builds anteriores
Write-Host "`n🧹 Limpando builds anteriores..."
dotnet clean --configuration Release | Out-Null

function Compile-Launcher {
    param($Type, $OutputDir, $Description, $ExtraParams = @())
    
    Write-Host "`n🔨 Compilando: $Description" -ForegroundColor Yellow
    
    $baseParams = @(
        "publish", $ProjectFile,
        "--configuration", "Release",
        "--self-contained", "true",
        "--runtime", "win-x64",
        "--output", $OutputDir
    )
    
    $allParams = $baseParams + $ExtraParams
    
    try {
        $startTime = Get-Date
        & dotnet @allParams
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        
        if ($LASTEXITCODE -eq 0) {
            $exePath = Join-Path $OutputDir "SangriaLauncher.exe"
            if (Test-Path $exePath) {
                $size = [math]::Round((Get-Item $exePath).Length / 1MB, 2)
                Write-Host "✅ Sucesso! Tamanho: ${size}MB | Tempo: ${duration}s" -ForegroundColor Green
                return $true
            }
        }
        Write-Host "❌ Falha na compilação" -ForegroundColor Red
        return $false
    } catch {
        Write-Host "❌ Erro: $_" -ForegroundColor Red
        return $false
    }
}

$compilations = @()

switch ($Tipo.ToLower()) {
    "single-file" {
        $compilations += @{
            Type = "single-file"
            OutputDir = "release-single-file"
            Description = "Arquivo Único (Recomendado)"
            ExtraParams = @("-p:PublishSingleFile=true", "-p:IncludeNativeLibrariesForSelfExtract=true")
        }
    }
    "standalone" {
        $compilations += @{
            Type = "standalone"
            OutputDir = "release-standalone"
            Description = "Standalone Multi-arquivos"
            ExtraParams = @()
        }
    }
    "all" {
        $compilations += @{
            Type = "single-file"
            OutputDir = "release-single-file"
            Description = "Arquivo Único (Recomendado)"
            ExtraParams = @("-p:PublishSingleFile=true", "-p:IncludeNativeLibrariesForSelfExtract=true")
        }
        $compilations += @{
            Type = "standalone"
            OutputDir = "release-standalone"
            Description = "Standalone Multi-arquivos"
            ExtraParams = @()
        }
    }
    default {
        Write-Error "Tipo inválido. Use: single-file, standalone, ou all"
        exit 1
    }
}

$results = @()
foreach ($comp in $compilations) {
    $success = Compile-Launcher -Type $comp.Type -OutputDir $comp.OutputDir -Description $comp.Description -ExtraParams $comp.ExtraParams
    
    $results += [PSCustomObject]@{
        Tipo = $comp.Type
        Pasta = $comp.OutputDir
        Status = if ($success) { "✅ Sucesso" } else { "❌ Falha" }
        Executavel = if ($success) { Join-Path $comp.OutputDir "SangriaLauncher.exe" } else { "N/A" }
    }
}

# Resumo
Write-Host "`n📊 Resumo da Compilação" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

$results | Format-Table -AutoSize

# Informações detalhadas dos arquivos gerados
Write-Host "`n📁 Arquivos Gerados:" -ForegroundColor Cyan
foreach ($result in $results) {
    if ($result.Status -like "*Sucesso*" -and (Test-Path $result.Executavel)) {
        $file = Get-Item $result.Executavel
        $sizeMB = [math]::Round($file.Length / 1MB, 2)
        Write-Host "📦 $($result.Tipo): $($file.FullName) (${sizeMB}MB)" -ForegroundColor Green
    }
}

# Teste básico
$singleFileExe = "release-single-file\SangriaLauncher.exe"
if (Test-Path $singleFileExe) {
    Write-Host "`n🧪 Testando executável..." -ForegroundColor Yellow
    
    # Teste de execução rápida (fecha automaticamente)
    try {
        $process = Start-Process -FilePath $singleFileExe -PassThru -WindowStyle Hidden
        Start-Sleep -Seconds 2
        if (-not $process.HasExited) {
            $process.CloseMainWindow()
            Start-Sleep -Seconds 1
            if (-not $process.HasExited) {
                $process.Kill()
            }
        }
        Write-Host "✅ Executável funciona corretamente" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Não foi possível testar o executável: $_" -ForegroundColor Yellow
    }
}

Write-Host "`n🎯 Compilação concluída!" -ForegroundColor Green
Write-Host "`n💡 Para distribuição, use o arquivo único:" -ForegroundColor Yellow
Write-Host "   📁 $LauncherPath\release-single-file\SangriaLauncher.exe" -ForegroundColor Yellow