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

## � Fluxo Completo de Atualização

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

### **2. Compile o Launcher Standalone (se necessário)**

```powershell
# Navegue para a pasta do launcher
cd "d:\ProjetosC#\WinFormsApp1"

# Compile arquivo único para distribuição
.\SangrisRepo\compilar-launcher.ps1 single-file

# OU use o comando direto
dotnet publish WinFormsApp1/WinFormsApp1.csproj --configuration Release --self-contained true --runtime win-x64 --output single-file-launcher -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true
```

**Resultado:** `single-file-launcher\SangriaLauncher.exe` (~154MB)

### **3. Publique as Releases no GitHub**

#### **Para o Mod (SangrisInterface):**
1. **Acesse:** https://github.com/duugagno/sangris-vrising-mod/releases
2. **Clique:** "Create a new release"
3. **Preencha:**
   - **Tag:** `v1.1.0`
   - **Title:** `SangrisInterface v1.1.0`
   - **Description:** Descreva as mudanças
4. **Anexe:** O arquivo `SangrisInterface.dll`
5. **Publique:** "Publish release"

#### **Para o Launcher (se atualizado):**
1. **Crie repositório** para o launcher (ex: `sangria-launcher`)
2. **Faça release** com `SangriaLauncher.exe`
3. **Atualize links** no README do mod

### **4. Teste a Atualização**

```powershell
# Execute o launcher
cd "d:\ProjetosC#\WinFormsApp1\single-file-launcher"
.\SangriaLauncher.exe
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

# Standalone - Arquivo Único (RECOMENDADO para distribuição)
dotnet publish WinFormsApp1/WinFormsApp1.csproj --configuration Release --self-contained true --runtime win-x64 --output single-file-launcher -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true

# Standalone - Multi-arquivos (desenvolvimento)
dotnet publish WinFormsApp1/WinFormsApp1.csproj --configuration Release --self-contained true --runtime win-x64 --output standalone-launcher

# Script automatizado (usa o script compilar-launcher.ps1)
.\compilar-launcher.ps1 single-file    # Arquivo único (~154MB)
.\compilar-launcher.ps1 standalone     # Multi-arquivos (~120MB)
.\compilar-launcher.ps1 all           # Ambos os tipos
```

### **Verificação de Hash**
```powershell
# Calcular SHA256 de um arquivo
Get-FileHash "caminho\arquivo.dll" -Algorithm SHA256
```

---

## 🛠️ Tarefas de Manutenção

### **Compilar Nova Versão do Launcher**

```powershell
# Método rápido com script
cd "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
.\compilar-launcher.ps1 single-file

# OU método manual
cd "d:\ProjetosC#\WinFormsApp1"
dotnet publish WinFormsApp1/WinFormsApp1.csproj --configuration Release --self-contained true --runtime win-x64 --output single-file-launcher -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true
```

**Tipos de compilação disponíveis:**
- **Single File** (~154MB): Um único arquivo, ideal para distribuição
- **Standalone** (~120MB): Múltiplos arquivos, mais rápido para executar
- **Framework-dependent** (~200KB): Requer .NET instalado

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
Remove-Item "d:\ProjetosC#\WinFormsApp1\standalone-launcher" -Recurse -Force
Remove-Item "d:\ProjetosC#\WinFormsApp1\single-file-launcher" -Recurse -Force

# Rebuild
dotnet clean
dotnet build
```

### **Distribuição do Launcher**

**Para usuários finais:**
1. Compile com: `.\compilar-launcher.ps1 single-file`
2. Distribua: `single-file-launcher\SangriaLauncher.exe`
3. Arquivo único de ~154MB
4. Não requer .NET instalado

**Para desenvolvedores:**
1. Forneça o código fonte
2. OU distribua versão framework-dependent menor

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

### **Checklist de Atualização**

### **Antes de Atualizar:**
- [ ] Backup do sistema atual
- [ ] Testar nova versão localmente
- [ ] Documentar mudanças no CHANGELOG
- [ ] Verificar se o launcher precisa ser recompilado

### **Durante a Atualização:**
- [ ] Executar `update-sangris.ps1` ou `deploy.ps1`
- [ ] Verificar que o commit foi feito
- [ ] Confirmar push para GitHub
- [ ] Criar release com arquivo anexado
- [ ] (Se necessário) Compilar nova versão do launcher

### **Após a Atualização:**
- [ ] Testar download via launcher
- [ ] Verificar integridade do arquivo
- [ ] Confirmar funcionamento no jogo
- [ ] Executar `testar-sistema.ps1` para validação completa
- [ ] Notificar usuários (se necessário)
- [ ] Atualizar links de download do launcher (se aplicável)

---

## 🔧 Scripts Úteis

### **Script de Verificação Completa**
```powershell
# verificar-sistema.ps1
.\verificar-sistema.ps1
```
**Funcionalidades:**
- ✅ Verifica estrutura de diretórios
- ✅ Compara hashes entre repo e jogo
- ✅ Valida manifest.json
- ✅ Verifica status do Git
- ✅ Mostra informações detalhadas

### **Script de Compilação do Launcher**
```powershell
# compilar-launcher.ps1
.\compilar-launcher.ps1 single-file    # Arquivo único (~154MB) - RECOMENDADO
.\compilar-launcher.ps1 standalone     # Multi-arquivos (~120MB)
.\compilar-launcher.ps1 all           # Compila ambos os tipos
```
**Funcionalidades:**
- ✅ Limpa builds anteriores
- ✅ Compila standalone automaticamente
- ✅ Mostra tamanhos e tempo de compilação
- ✅ Testa executável gerado
- ✅ Relatório detalhado

### **Script de Deploy Completo**
```powershell
# deploy.ps1
.\deploy.ps1 "1.1.0"
```
**Funcionalidades:**
- ✅ Backup automático do sistema
- ✅ Atualiza mod (via update-sangris.ps1)
- ✅ Recompila launcher standalone
- ✅ Executa testes básicos
- ✅ Gera arquivo com informações da release
- ✅ Abre GitHub automaticamente

### **Script de Testes Completos**
```powershell
# testar-sistema.ps1
.\testar-sistema.ps1
```
**Funcionalidades:**
- ✅ 7 testes diferentes do sistema
- ✅ Validação de arquivos e estrutura
- ✅ Verificação de integridade SHA256
- ✅ Teste de compilação do launcher
- ✅ Conectividade com GitHub
- ✅ Relatório detalhado com estatísticas

---

## 📞 Contatos de Emergência

### **URLs Importantes:**
- **Repositório Mod:** https://github.com/duugagno/sangris-vrising-mod
- **Releases Mod:** https://github.com/duugagno/sangris-vrising-mod/releases
- **Manifest:** https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json
- **Repositório Launcher:** (criar se necessário para distribuição)

### **Comandos de Emergência:**
```powershell
# Reverter última mudança
git revert HEAD

# Voltar para versão anterior
git reset --hard HEAD~1

# Forçar push (cuidado!)
git push --force-with-lease

# Recompilar launcher urgente
.\compilar-launcher.ps1 single-file
```

### **Locais dos Executáveis:**
- **Desenvolvimento:** `d:\ProjetosC#\WinFormsApp1\WinFormsApp1\bin\Debug\net8.0-windows\SangriaLauncher.exe`
- **Release:** `d:\ProjetosC#\WinFormsApp1\WinFormsApp1\bin\Release\net8.0-windows\SangriaLauncher.exe`
- **Standalone:** `d:\ProjetosC#\WinFormsApp1\standalone-launcher\SangriaLauncher.exe`
- **Single File:** `d:\ProjetosC#\WinFormsApp1\single-file-launcher\SangriaLauncher.exe` ⭐ **Recomendado**

---

## � Compilação Standalone Detalhada

### **🎯 Tipos de Compilação**

| Tipo | Comando | Tamanho | Arquivos | Melhor Para |
|------|---------|---------|----------|-------------|
| **Single File** | `.\compilar-launcher.ps1 single-file` | ~154MB | 1 arquivo | **Distribuição** ⭐ |
| **Standalone** | `.\compilar-launcher.ps1 standalone` | ~120MB | 180+ arquivos | Desenvolvimento |
| **Framework-dependent** | `dotnet build --configuration Release` | ~200KB | Poucos | Servidores com .NET |

### **🚀 Compilação Rápida (Recomendada)**

```powershell
# Usando script automatizado
cd "d:\ProjetosC#\WinFormsApp1\SangrisRepo"
.\compilar-launcher.ps1 single-file

# Resultado: ../single-file-launcher/SangriaLauncher.exe (~154MB)
```

### **🔧 Compilação Manual**

```powershell
# Navegar para pasta do projeto
cd "d:\ProjetosC#\WinFormsApp1"

# Limpar builds anteriores
dotnet clean --configuration Release

# Compilar arquivo único
dotnet publish WinFormsApp1/WinFormsApp1.csproj \
  --configuration Release \
  --self-contained true \
  --runtime win-x64 \
  --output single-file-launcher \
  -p:PublishSingleFile=true \
  -p:IncludeNativeLibrariesForSelfExtract=true

# Testar executável
.\single-file-launcher\SangriaLauncher.exe
```

### **📊 Comparação de Performance**

| Aspecto | Single File | Standalone | Framework-dependent |
|---------|-------------|------------|---------------------|
| **Startup** | Médio | Rápido | Muito Rápido |
| **Distribuição** | Excelente | Ruim | Médio |
| **Tamanho** | Grande | Grande | Pequeno |
| **Dependências** | Nenhuma | Nenhuma | .NET 8 |

### **🎯 Quando Usar Cada Tipo**

#### **Single File - Use quando:**
- ✅ Distribuir para usuários finais
- ✅ Máquinas sem .NET instalado
- ✅ Facilidade de compartilhamento
- ✅ Instalação "zero-click"

#### **Standalone - Use quando:**
- ✅ Desenvolvimento/debug
- ✅ Performance de startup é crítica
- ✅ Acesso fácil a DLLs individuais

#### **Framework-dependent - Use quando:**
- ✅ Servidores com .NET instalado
- ✅ Tamanho é crítico
- ✅ Atualizações frequentes do runtime

### **🔍 Troubleshooting Compilação**

#### **Erro: "Windows Forms is not supported with trimming"**
```powershell
# REMOVA o parâmetro -p:PublishTrimmed=true
# Windows Forms não suporta trimming
```

#### **Erro: "Could not find a part of the path"**
```powershell
# Verifique se o caminho do projeto está correto
# Use caminhos absolutos se necessário
```

#### **Executável não inicia**
```powershell
# Verifique se é Windows x64
# Teste sem parâmetros -p:PublishSingleFile primeiro
# Verifique antivírus (pode bloquear executáveis grandes)
```

---

> ⚠️ **SEMPRE** faça backup antes de mudanças importantes
> 
> 🔐 **NUNCA** commite senhas ou tokens
> 
> 📋 **SEMPRE** teste antes de publicar
> 
> 📝 **SEMPRE** documente mudanças no CHANGELOG

---

**💡 Dica:** Mantenha este arquivo sempre atualizado conforme o sistema evolui!