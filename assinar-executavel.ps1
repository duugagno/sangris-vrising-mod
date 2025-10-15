# Script para auto-assinar o executável Sangria Falls
# ATENÇÃO: Auto-assinatura ainda mostra aviso, mas identifica o autor

param(
    [string]$ExePath = "d:\ProjetosC#\WinFormsApp1\sangria-launcher-final\Sangria Falls.exe",
    [string]$CertName = "Sangria Falls Developer"
)

Write-Host "🔐 Auto-assinando executável Sangria Falls..." -ForegroundColor Cyan

try {
    # Verificar se o executável existe
    if (-not (Test-Path $ExePath)) {
        Write-Error "❌ Executável não encontrado: $ExePath"
        exit 1
    }

    # Criar certificado auto-assinado (válido por 3 anos)
    Write-Host "📋 Criando certificado auto-assinado..." -ForegroundColor Yellow
    
    $cert = New-SelfSignedCertificate -DnsName $CertName -Type CodeSigning -CertStoreLocation Cert:\CurrentUser\My -NotAfter (Get-Date).AddYears(3)
    
    Write-Host "✅ Certificado criado: $($cert.Thumbprint)" -ForegroundColor Green
    
    # Assinar o executável
    Write-Host "🖊️  Assinando executável..." -ForegroundColor Yellow
    
    Set-AuthenticodeSignature -FilePath $ExePath -Certificate $cert -TimestampServer "http://timestamp.digicert.com"
    
    # Verificar assinatura
    $signature = Get-AuthenticodeSignature -FilePath $ExePath
    
    if ($signature.Status -eq "Valid") {
        Write-Host "✅ Executável assinado com sucesso!" -ForegroundColor Green
        Write-Host "📋 Status: $($signature.Status)" -ForegroundColor Green
        Write-Host "🏷️  Signatário: $($signature.SignerCertificate.Subject)" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Assinatura criada mas com status: $($signature.Status)" -ForegroundColor Yellow
        Write-Host "💡 Isso é normal para certificados auto-assinados" -ForegroundColor Yellow
    }
    
    # Instruções para o usuário
    Write-Host "`n📋 INSTRUÇÕES IMPORTANTES:" -ForegroundColor Cyan
    Write-Host "1. ✅ O executável agora está assinado com seu certificado" -ForegroundColor Green
    Write-Host "2. ⚠️  Ainda aparecerá aviso 'Editor desconhecido' para outros usuários" -ForegroundColor Yellow
    Write-Host "3. 💡 Para remover completamente, você precisa de um certificado comercial" -ForegroundColor Yellow
    Write-Host "4. 🔒 Usuários podem clicar 'Mais informações' → 'Executar assim mesmo'" -ForegroundColor Yellow
    
} catch {
    Write-Error "❌ Erro ao assinar: $($_.Exception.Message)"
    exit 1
}

Write-Host "`n🎯 ALTERNATIVAS PARA DISTRIBUIÇÃO:" -ForegroundColor Cyan
Write-Host "• 📦 Distribuir via Microsoft Store (assinatura automática)" -ForegroundColor Yellow
Write-Host "• 🌐 Hospedar em site com boa reputação" -ForegroundColor Yellow
Write-Host "• 📋 Fornecer instruções claras para usuários" -ForegroundColor Yellow
Write-Host "• 💰 Comprar certificado de Code Signing comercial" -ForegroundColor Yellow