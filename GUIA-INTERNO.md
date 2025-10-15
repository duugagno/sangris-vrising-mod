# 🔧 Guia Interno - Gerenciamento do Sangris Interface

> **📋 Guia completo para atualizações, manutenção e gerenciamento do sistema**

---

## 📂 Estrutura do Sistema

```
📁 Sistema Sangris/
├── 📁 WinFormsApp1/                    ← Launcher (C#)
│   ├── 📁 WinFormsApp1/
│   │   ├── 📄 Program.cs
│   │   ├── 📄 MainForm.cs
│   │   └── 📄 Launcher.cs
│   ├── 📁 SangrisRepo/                 ← Repositório do mod
│   │   ├── 📄 manifest.json
│   │   ├── 📄 README.md
│   │   ├── 📁 plugins/
│   │   │   └── 📄 SangrisInterface.dll
│   │   └── 📄 update-sangris.ps1
│   └── 📁 publish/                     ← Launcher compilado
└── 📁 V Rising/                        ← Jogo instalado
    └── 📁 BepInEx/plugins/
        └── 📄 SangrisInterface.dll     ← Mod instalado
```

---

## 🔄 Fluxo Completo de Atualização

### **1. Desenvolveu Nova Versão do Mod**

```powershell
# 1. Navegue até o diretório do repositório
cd "d:\ProjetosC#\WinFormsApp1\SangrisRepo"

# 2. Execute o script de atualização
.\update-sangris.ps1 "1.1.0"
```

**O que o script faz automaticamente:**
- ✅ Copia `SangrisInterface.dll` do V Rising para o repo
- ✅ Calcula novo hash SHA256
- ✅ Atualiza `manifest.json` com nova versão
- ✅ Faz commit e push para GitHub

### **2. Publique a Release no GitHub**

1. **Acesse:** https://github.com/duugagno/sangris-vrising-mod/releases
2. **Clique:** "Create a new release"
3. **Preencha:**
   - **Tag:** `v1.1.0`
   - **Title:** `SangrisInterface v1.1.0`
   - **Description:** Descreva as mudanças
4. **Anexe:** O arquivo `SangrisInterface.dll`
5. **Publique:** "Publish release"

### **3. Teste a Atualização**

```powershell
# Execute o launcher
cd "d:\ProjetosC#\WinFormsApp1"
dotnet run --project WinFormsApp1
```

**Configure no launcher:**
- **Pasta:** `D:\SteamLibrary\steamapps\common\VRising`
- **Manifest:** `https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json`
- **Steam URI:** `steam://rungameid/1604030`

---

## 📝 Comandos Essenciais

### **Git Operations**
```powershell
# Status do repositório
git status

# Ver mudanças
git diff

# Adicionar arquivos
git add .

# Commit manual
git commit -m "feat: nova funcionalidade"

# Push para GitHub
git push

# Ver histórico
git log --oneline
```

### **Compilação do Launcher**
```powershell
# Debug (desenvolvimento)
dotnet build

# Release (produção)
dotnet build --configuration Release

# Standalone (distribuição)
dotnet publish --configuration Release --self-contained true --runtime win-x64 --output publish
```

### **Verificação de Hash**
```powershell
# Calcular SHA256 de um arquivo
Get-FileHash "caminho\arquivo.dll" -Algorithm SHA256
```

---

## 🛠️ Tarefas de Manutenção

### **Atualizar Documentação**

1. **README.md** - Atualize informações principais
2. **CHANGELOG.md** - Adicione nova versão:
   ```markdown
   ## [1.1.0] - 2025-10-16
   ### Adicionado
   - Nova funcionalidade X
   ### Corrigido
   - Bug Y
   ```

### **Backup do Sistema**
```powershell
# Fazer backup completo
$BackupPath = "D:\Backups\Sangris-$(Get-Date -Format 'yyyy-MM-dd')"
Copy-Item "d:\ProjetosC#\WinFormsApp1" $BackupPath -Recurse
```

### **Limpeza de Arquivos Temporários**
```powershell
# Limpar builds
Remove-Item "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\bin" -Recurse -Force
Remove-Item "d:\ProjetosC#\WinFormsApp1\WinFormsApp1\obj" -Recurse -Force

# Rebuild
dotnet clean
dotnet build
```

---

## 🚨 Solução de Problemas

### **Problema: Hash não confere**
```powershell
# Recalcular hash do arquivo atual
Get-FileHash "d:\ProjetosC#\WinFormsApp1\SangrisRepo\plugins\SangrisInterface.dll" -Algorithm SHA256

# Atualizar manifest manualmente se necessário
```

### **Problema: Git push falha**
```powershell
# Verificar status
git status

# Resolver conflitos se houver
git pull
git add .
git commit -m "resolve: merge conflicts"
git push
```

### **Problema: Launcher não compila**
```powershell
# Limpar e recompilar
dotnet clean
dotnet restore
dotnet build
```

### **Problema: Release não funciona**
1. Verifique se a tag está correta (`v1.1.0`)
2. Confirme que o arquivo foi anexado
3. Teste a URL de download manualmente

---

## 📋 Checklist de Atualização

### **Antes de Atualizar:**
- [ ] Backup do sistema atual
- [ ] Testar nova versão localmente
- [ ] Documentar mudanças no CHANGELOG

### **Durante a Atualização:**
- [ ] Executar `update-sangris.ps1`
- [ ] Verificar que o commit foi feito
- [ ] Confirmar push para GitHub
- [ ] Criar release com arquivo anexado

### **Após a Atualização:**
- [ ] Testar download via launcher
- [ ] Verificar integridade do arquivo
- [ ] Confirmar funcionamento no jogo
- [ ] Notificar usuários (se necessário)

---

## 🔧 Scripts Úteis

### **Script de Verificação Completa**
```powershell
# verificar-sistema.ps1
$RepoPath = "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
$GamePath = "D:\SteamLibrary\steamapps\common\VRising\BepInEx\plugins"

Write-Host "🔍 Verificando sistema..."

# Verificar arquivos
if (Test-Path "$RepoPath\plugins\SangrisInterface.dll") {
    Write-Host "✅ Arquivo no repo encontrado"
} else {
    Write-Host "❌ Arquivo no repo não encontrado"
}

if (Test-Path "$GamePath\SangrisInterface.dll") {
    Write-Host "✅ Arquivo no jogo encontrado"
} else {
    Write-Host "❌ Arquivo no jogo não encontrado"
}

# Verificar hashes
$RepoHash = (Get-FileHash "$RepoPath\plugins\SangrisInterface.dll" -Algorithm SHA256).Hash.ToLower()
$GameHash = (Get-FileHash "$GamePath\SangrisInterface.dll" -Algorithm SHA256).Hash.ToLower()

if ($RepoHash -eq $GameHash) {
    Write-Host "✅ Hashes coincidem"
} else {
    Write-Host "⚠️ Hashes diferentes - necessário atualizar"
}

Write-Host "📊 Repo Hash: $RepoHash"
Write-Host "📊 Game Hash: $GameHash"
```

### **Script de Deploy Completo**
```powershell
# deploy.ps1
param([string]$Version)

if (-not $Version) {
    Write-Error "Uso: .\deploy.ps1 '1.1.0'"
    exit 1
}

Write-Host "🚀 Iniciando deploy da versão $Version..."

# 1. Atualizar mod
.\update-sangris.ps1 $Version

# 2. Recompilar launcher
Set-Location ".."
dotnet build --configuration Release
dotnet publish --configuration Release --self-contained true --runtime win-x64 --output publish

Write-Host "✅ Deploy concluído!"
Write-Host "📋 Próximos passos:"
Write-Host "1. Criar release no GitHub: https://github.com/duugagno/sangris-vrising-mod/releases"
Write-Host "2. Anexar SangrisInterface.dll"
Write-Host "3. Testar launcher"
```

---

## 📞 Contatos de Emergência

### **URLs Importantes:**
- **Repositório:** https://github.com/duugagno/sangris-vrising-mod
- **Releases:** https://github.com/duugagno/sangris-vrising-mod/releases
- **Manifest:** https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json

### **Comandos de Emergência:**
```powershell
# Reverter última mudança
git revert HEAD

# Voltar para versão anterior
git reset --hard HEAD~1

# Forçar push (cuidado!)
git push --force-with-lease
```

---

## 📝 Notas Importantes

> ⚠️ **SEMPRE** faça backup antes de mudanças importantes
> 
> 🔐 **NUNCA** commite senhas ou tokens
> 
> 📋 **SEMPRE** teste antes de publicar
> 
> 📝 **SEMPRE** documente mudanças no CHANGELOG

---

**💡 Dica:** Mantenha este arquivo sempre atualizado conforme o sistema evolui!