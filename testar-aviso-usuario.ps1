# Teste para simular experiência de usuário externo
Write-Host "🧪 Testando como outros usuários verão o executável..." -ForegroundColor Cyan

$exePath = "d:\ProjetosC#\WinFormsApp1\sangria-launcher-final\Sangria Falls.exe"

if (-not (Test-Path $exePath)) {
    Write-Error "❌ Executável não encontrado: $exePath"
    exit 1
}

# 1. Verificar assinatura atual
Write-Host "`n🔍 1. Verificando assinatura atual..." -ForegroundColor Yellow
$signature = Get-AuthenticodeSignature -FilePath $exePath
Write-Host "   Status: $($signature.Status)" -ForegroundColor $(if($signature.Status -eq 'Valid'){'Green'}else{'Red'})
Write-Host "   Signatário: $($signature.SignerCertificate.Subject)" -ForegroundColor Yellow

# 2. Verificar zona de segurança
Write-Host "`n🌐 2. Verificando zona de segurança..." -ForegroundColor Yellow
try {
    $zone = Get-Content -Path $exePath -Stream Zone.Identifier -ErrorAction SilentlyContinue
    if ($zone) {
        Write-Host "   Zona detectada: $zone" -ForegroundColor Red
    } else {
        Write-Host "   ✅ Nenhuma zona restritiva (arquivo local)" -ForegroundColor Green
    }
} catch {
    Write-Host "   ✅ Nenhuma zona restritiva (arquivo local)" -ForegroundColor Green
}

# 3. Simular download da internet
Write-Host "`n💾 3. Simulando download da internet..." -ForegroundColor Yellow
$testPath = "$env:TEMP\Sangria Falls - Teste.exe"
Copy-Item $exePath $testPath -Force

# Marcar como baixado da internet
$zoneContent = @"
[ZoneTransfer]
ZoneId=3
ReferrerUrl=https://github.com/duugagno/sangris-vrising-mod/releases
HostUrl=https://github.com/duugagno/sangris-vrising-mod/releases/download/v1.3.0/Sangria-Falls.exe
"@

Set-Content -Path $testPath -Stream Zone.Identifier -Value $zoneContent

# 4. Testar assinatura do arquivo "baixado"
Write-Host "`n🔍 4. Verificando arquivo simulado como download..." -ForegroundColor Yellow
$testSignature = Get-AuthenticodeSignature -FilePath $testPath
Write-Host "   Status: $($testSignature.Status)" -ForegroundColor $(if($testSignature.Status -eq 'Valid'){'Green'}else{'Red'})

if ($testSignature.Status -ne 'Valid') {
    Write-Host "   ⚠️  ESTE arquivo mostraria aviso para usuários!" -ForegroundColor Red
} else {
    Write-Host "   ✅ Este arquivo seria aceito sem avisos" -ForegroundColor Green
}

Write-Host "`n📋 RESULTADOS:" -ForegroundColor Cyan
Write-Host "• Arquivo original (seu PC): Sem avisos" -ForegroundColor Green
Write-Host "• Arquivo baixado (outros): $(if($testSignature.Status -ne 'Valid'){'COM avisos ⚠️'}else{'Sem avisos ✅'})" -ForegroundColor $(if($testSignature.Status -ne 'Valid'){'Red'}else{'Green'})

Write-Host "`n💡 CONCLUSÃO:" -ForegroundColor Yellow
Write-Host "No SEU computador não aparece aviso porque:" -ForegroundColor Yellow
Write-Host "1. ✅ Você é o desenvolvedor" -ForegroundColor Green
Write-Host "2. ✅ Arquivo está na máquina local" -ForegroundColor Green
Write-Host "3. ✅ Windows confia em arquivos locais" -ForegroundColor Green
Write-Host "`nPara OUTROS usuários que baixarem:" -ForegroundColor Yellow
Write-Host "$(if($testSignature.Status -ne 'Valid'){'❌ APARECERÁ o aviso "Editor desconhecido"'}else{'✅ Não aparecerá aviso'})" -ForegroundColor $(if($testSignature.Status -ne 'Valid'){'Red'}else{'Green'})

# Limpar arquivo de teste
Remove-Item $testPath -Force -ErrorAction SilentlyContinue

Write-Host "`n🎯 RECOMENDAÇÃO:" -ForegroundColor Cyan
if ($testSignature.Status -ne 'Valid') {
    Write-Host "Execute: .\assinar-executavel.ps1" -ForegroundColor Yellow
    Write-Host "Para melhorar a situação para outros usuários" -ForegroundColor Yellow
}