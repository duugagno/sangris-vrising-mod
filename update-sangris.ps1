# Script para atualizar SangrisInterface
# Uso: .\update-sangris.ps1 "1.1.0"

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$SourceFile = "D:\SteamLibrary\steamapps\common\VRising\BepInEx\plugins\SangrisInterface.dll"
$RepoPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
$DestFile = "$RepoPath\plugins\SangrisInterface.dll"
$ManifestFile = "$RepoPath\manifest.json"

Write-Host "🔄 Iniciando atualização para versão $Version..."

# 1. Verificar se o arquivo fonte existe
if (-not (Test-Path $SourceFile)) {
    Write-Error "❌ Arquivo fonte não encontrado: $SourceFile"
    exit 1
}

# 2. Copiar arquivo
Write-Host "📁 Copiando arquivo..."
Copy-Item $SourceFile $DestFile -Force

# 3. Calcular hash
Write-Host "🔐 Calculando hash SHA256..."
$Hash = Get-FileHash $DestFile -Algorithm SHA256
$HashLower = $Hash.Hash.ToLower()

# 4. Obter tamanho
$Size = (Get-Item $DestFile).Length

# 5. Atualizar manifest
Write-Host "📝 Atualizando manifest..."
$ManifestContent = @"
{
  "version": "$Version",
  "files": [
    {
      "path": "BepInEx/plugins/SangrisInterface.dll",
      "url": "https://github.com/duugagno/sangris-vrising-mod/releases/download/v$Version/SangrisInterface.dll",
      "sha256": "$HashLower",
      "size": $Size
    }
  ]
}
"@

$ManifestContent | Out-File -FilePath $ManifestFile -Encoding UTF8

# 6. Git operations
Write-Host "📤 Commitando mudanças..."
Set-Location $RepoPath
git add .
git commit -m "Update SangrisInterface to v$Version"
git push

Write-Host "✅ Atualização concluída!"
Write-Host ""
Write-Host "🚀 Próximos passos:"
Write-Host "1. Acesse: https://github.com/duugagno/sangris-vrising-mod/releases"
Write-Host "2. Crie uma nova release com tag: v$Version"
Write-Host "3. Faça upload do arquivo SangrisInterface.dll"
Write-Host ""
Write-Host "📋 Informações da versão:"
Write-Host "Versão: $Version"
Write-Host "Hash: $HashLower"
Write-Host "Tamanho: $Size bytes"