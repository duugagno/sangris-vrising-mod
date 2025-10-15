# Script de Verificação do Sistema Sangris
# Uso: .\verificar-sistema.ps1

$RepoPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
$GamePath = "D:\SteamLibrary\steamapps\common\VRising\BepInEx\plugins"

Write-Host "🔍 Verificando Sistema Sangris..." -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Verificar estrutura de diretórios
Write-Host "`n📁 Verificando estrutura de diretórios..."

$DirectoriesToCheck = @(
    $RepoPath,
    "$RepoPath\plugins",
    $GamePath
)

foreach ($dir in $DirectoriesToCheck) {
    if (Test-Path $dir) {
        Write-Host "✅ $dir" -ForegroundColor Green
    } else {
        Write-Host "❌ $dir" -ForegroundColor Red
    }
}

# Verificar arquivos principais
Write-Host "`n📄 Verificando arquivos principais..."

$FilesToCheck = @(
    "$RepoPath\manifest.json",
    "$RepoPath\plugins\SangrisInterface.dll",
    "$RepoPath\update-sangris.ps1",
    "$GamePath\SangrisInterface.dll"
)

foreach ($file in $FilesToCheck) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        Write-Host "✅ $(Split-Path $file -Leaf) ($size bytes)" -ForegroundColor Green
    } else {
        Write-Host "❌ $(Split-Path $file -Leaf)" -ForegroundColor Red
    }
}

# Comparar hashes se ambos arquivos existem
Write-Host "`n🔐 Verificando integridade..."

$RepoFile = "$RepoPath\plugins\SangrisInterface.dll"
$GameFile = "$GamePath\SangrisInterface.dll"

if ((Test-Path $RepoFile) -and (Test-Path $GameFile)) {
    $RepoHash = (Get-FileHash $RepoFile -Algorithm SHA256).Hash.ToLower()
    $GameHash = (Get-FileHash $GameFile -Algorithm SHA256).Hash.ToLower()
    
    Write-Host "📊 Hash Repositório: $RepoHash"
    Write-Host "📊 Hash Jogo:       $GameHash"
    
    if ($RepoHash -eq $GameHash) {
        Write-Host "✅ Hashes coincidem - Arquivos idênticos" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Hashes diferentes - Arquivos dessincronizados" -ForegroundColor Yellow
        Write-Host "💡 Execute: .\update-sangris.ps1 para sincronizar" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Não foi possível comparar hashes - arquivo(s) ausente(s)" -ForegroundColor Yellow
}

# Verificar status do Git
Write-Host "`n📋 Status do Git..."
try {
    Set-Location $RepoPath
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Existem mudanças não commitadas:" -ForegroundColor Yellow
        git status --short
    } else {
        Write-Host "✅ Repositório limpo - todas mudanças commitadas" -ForegroundColor Green
    }
    
    # Verificar se está sincronizado com origin
    $behind = git rev-list HEAD..origin/main --count 2>$null
    $ahead = git rev-list origin/main..HEAD --count 2>$null
    
    if ($behind -gt 0) {
        Write-Host "⚠️  $behind commit(s) atrás do GitHub" -ForegroundColor Yellow
    }
    if ($ahead -gt 0) {
        Write-Host "⚠️  $ahead commit(s) à frente do GitHub - faça push" -ForegroundColor Yellow
    }
    if ($behind -eq 0 -and $ahead -eq 0) {
        Write-Host "✅ Sincronizado com GitHub" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erro ao verificar Git: $_" -ForegroundColor Red
}

# Verificar manifest.json
Write-Host "`n📋 Verificando manifest.json..."
try {
    $manifest = Get-Content "$RepoPath\manifest.json" | ConvertFrom-Json
    Write-Host "✅ Versão atual: $($manifest.version)" -ForegroundColor Green
    Write-Host "✅ Arquivos listados: $($manifest.files.Count)" -ForegroundColor Green
    
    foreach ($file in $manifest.files) {
        Write-Host "   📄 $($file.path) - $($file.size) bytes"
    }
} catch {
    Write-Host "❌ Erro ao ler manifest.json: $_" -ForegroundColor Red
}

Write-Host "`n🎯 Verificação concluída!" -ForegroundColor Cyan