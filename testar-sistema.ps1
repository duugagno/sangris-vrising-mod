# Script de Teste do Sistema Completo
# Uso: .\testar-sistema.ps1

Write-Host "🧪 Iniciando Testes do Sistema Sangris" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

$ErrorActionPreference = "Continue"
$TestResults = @()

function Add-TestResult {
    param($Name, $Status, $Message)
    $TestResults += [PSCustomObject]@{
        Teste = $Name
        Status = $Status
        Mensagem = $Message
    }
}

# Teste 1: Verificar estrutura de arquivos
Write-Host "`n📁 Teste 1: Estrutura de arquivos"
try {
    $requiredFiles = @(
        "d:\ProjetosC#\WinFormsApp1\SangrisRepo\manifest.json",
        "d:\ProjetosC#\WinFormsApp1\SangrisRepo\plugins\SangrisInterface.dll",
        "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\MainForm.cs",
        "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\Launcher.cs"
    )
    
    $missing = $requiredFiles | Where-Object { -not (Test-Path $_) }
    if ($missing.Count -eq 0) {
        Add-TestResult "Estrutura de Arquivos" "✅ PASS" "Todos arquivos encontrados"
        Write-Host "✅ Todos arquivos necessários encontrados" -ForegroundColor Green
    } else {
        Add-TestResult "Estrutura de Arquivos" "❌ FAIL" "Arquivos ausentes: $($missing -join ', ')"
        Write-Host "❌ Arquivos ausentes: $($missing -join ', ')" -ForegroundColor Red
    }
} catch {
    Add-TestResult "Estrutura de Arquivos" "❌ ERROR" $_.Exception.Message
}

# Teste 2: Validar manifest.json
Write-Host "`n📋 Teste 2: Validação do manifest.json"
try {
    $manifestPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo\manifest.json"
    $manifest = Get-Content $manifestPath | ConvertFrom-Json
    
    $issues = @()
    if (-not $manifest.version) { $issues += "Versão ausente" }
    if (-not $manifest.files -or $manifest.files.Count -eq 0) { $issues += "Lista de arquivos vazia" }
    
    foreach ($file in $manifest.files) {
        if (-not $file.path) { $issues += "Path ausente em arquivo" }
        if (-not $file.url) { $issues += "URL ausente em arquivo" }
        if (-not $file.sha256) { $issues += "SHA256 ausente em arquivo" }
        if (-not $file.size) { $issues += "Size ausente em arquivo" }
    }
    
    if ($issues.Count -eq 0) {
        Add-TestResult "Manifest JSON" "✅ PASS" "Manifest válido - v$($manifest.version)"
        Write-Host "✅ Manifest válido - versão $($manifest.version)" -ForegroundColor Green
    } else {
        Add-TestResult "Manifest JSON" "❌ FAIL" "Problemas: $($issues -join ', ')"
        Write-Host "❌ Problemas no manifest: $($issues -join ', ')" -ForegroundColor Red
    }
} catch {
    Add-TestResult "Manifest JSON" "❌ ERROR" $_.Exception.Message
    Write-Host "❌ Erro ao validar manifest: $_" -ForegroundColor Red
}

# Teste 3: Verificar integridade do arquivo
Write-Host "`n🔐 Teste 3: Integridade do arquivo"
try {
    $dllPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo\plugins\SangrisInterface.dll"
    $manifest = Get-Content "d:\ProjetosC#\WinFormsApp1\SangrisRepo\manifest.json" | ConvertFrom-Json
    
    if (Test-Path $dllPath) {
        $actualHash = (Get-FileHash $dllPath -Algorithm SHA256).Hash.ToLower()
        $expectedHash = $manifest.files[0].sha256.ToLower()
        
        if ($actualHash -eq $expectedHash) {
            Add-TestResult "Integridade SHA256" "✅ PASS" "Hash confere"
            Write-Host "✅ Hash SHA256 confere" -ForegroundColor Green
        } else {
            Add-TestResult "Integridade SHA256" "❌ FAIL" "Hash não confere"
            Write-Host "❌ Hash SHA256 não confere" -ForegroundColor Red
            Write-Host "   Esperado: $expectedHash" -ForegroundColor Red
            Write-Host "   Atual:    $actualHash" -ForegroundColor Red
        }
    } else {
        Add-TestResult "Integridade SHA256" "❌ FAIL" "Arquivo DLL não encontrado"
        Write-Host "❌ Arquivo DLL não encontrado" -ForegroundColor Red
    }
} catch {
    Add-TestResult "Integridade SHA256" "❌ ERROR" $_.Exception.Message
}

# Teste 4: Compilação do launcher
Write-Host "`n🔨 Teste 4: Compilação do launcher"
try {
    Set-Location "d:\ProjetosC#\WinFormsApp1"
    $buildOutput = dotnet build --configuration Release --verbosity quiet 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Add-TestResult "Compilação Launcher" "✅ PASS" "Compilação bem-sucedida"
        Write-Host "✅ Launcher compila sem erros" -ForegroundColor Green
    } else {
        Add-TestResult "Compilação Launcher" "❌ FAIL" "Erro na compilação"
        Write-Host "❌ Erro na compilação do launcher" -ForegroundColor Red
        Write-Host $buildOutput -ForegroundColor Red
    }
} catch {
    Add-TestResult "Compilação Launcher" "❌ ERROR" $_.Exception.Message
}

# Teste 5: Conectividade com GitHub
Write-Host "`n🌐 Teste 5: Conectividade com GitHub"
try {
    $manifestUrl = "https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json"
    $response = Invoke-WebRequest -Uri $manifestUrl -Method Head -TimeoutSec 10
    
    if ($response.StatusCode -eq 200) {
        Add-TestResult "GitHub Conectividade" "✅ PASS" "Manifest acessível"
        Write-Host "✅ Manifest acessível no GitHub" -ForegroundColor Green
    } else {
        Add-TestResult "GitHub Conectividade" "❌ FAIL" "Status: $($response.StatusCode)"
        Write-Host "❌ Problema ao acessar manifest: $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Add-TestResult "GitHub Conectividade" "⚠️ WARN" "Não foi possível verificar: $($_.Exception.Message)"
    Write-Host "⚠️ Não foi possível verificar conectividade: $_" -ForegroundColor Yellow
}

# Teste 6: Verificar Git status
Write-Host "`n📋 Teste 6: Status do Git"
try {
    Set-Location "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
    $gitStatus = git status --porcelain
    
    if (-not $gitStatus) {
        Add-TestResult "Git Status" "✅ PASS" "Repositório limpo"
        Write-Host "✅ Repositório limpo" -ForegroundColor Green
    } else {
        Add-TestResult "Git Status" "⚠️ WARN" "Mudanças não commitadas"
        Write-Host "⚠️ Existem mudanças não commitadas" -ForegroundColor Yellow
    }
} catch {
    Add-TestResult "Git Status" "❌ ERROR" $_.Exception.Message
}

# Teste 7: Verificar scripts auxiliares
Write-Host "`n📜 Teste 7: Scripts auxiliares"
try {
    $scripts = @(
        "d:\ProjetosC#\WinFormsApp1\SangrisRepo\update-sangris.ps1",
        "d:\ProjetosC#\WinFormsApp1\SangrisRepo\verificar-sistema.ps1",
        "d:\ProjetosC#\WinFormsApp1\SangrisRepo\deploy.ps1"
    )
    
    $missingScripts = $scripts | Where-Object { -not (Test-Path $_) }
    if ($missingScripts.Count -eq 0) {
        Add-TestResult "Scripts Auxiliares" "✅ PASS" "Todos scripts encontrados"
        Write-Host "✅ Todos scripts auxiliares encontrados" -ForegroundColor Green
    } else {
        Add-TestResult "Scripts Auxiliares" "❌ FAIL" "Scripts ausentes: $($missingScripts -join ', ')"
        Write-Host "❌ Scripts ausentes: $($missingScripts -join ', ')" -ForegroundColor Red
    }
} catch {
    Add-TestResult "Scripts Auxiliares" "❌ ERROR" $_.Exception.Message
}

# Resumo dos resultados
Write-Host "`n📊 Resumo dos Testes" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan

$TestResults | Format-Table -AutoSize

$passCount = ($TestResults | Where-Object { $_.Status -like "*PASS*" }).Count
$failCount = ($TestResults | Where-Object { $_.Status -like "*FAIL*" }).Count
$warnCount = ($TestResults | Where-Object { $_.Status -like "*WARN*" }).Count
$errorCount = ($TestResults | Where-Object { $_.Status -like "*ERROR*" }).Count

Write-Host "`n🎯 Estatísticas:" -ForegroundColor Cyan
Write-Host "✅ Passou: $passCount" -ForegroundColor Green
Write-Host "❌ Falhou: $failCount" -ForegroundColor Red
Write-Host "⚠️ Avisos: $warnCount" -ForegroundColor Yellow
Write-Host "💥 Erros: $errorCount" -ForegroundColor Magenta

if ($failCount -eq 0 -and $errorCount -eq 0) {
    Write-Host "`n🎉 Todos os testes críticos passaram!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n🚨 Alguns testes falharam. Verifique os problemas acima." -ForegroundColor Red
    exit 1
}