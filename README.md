# 🩸 Sangris Interface - V Rising Mod

<div align="center">

![V Rising](https://img.shields.io/badge/V%20Rising-Compatible-darkred?style=for-the-badge&logo=steam)
![BepInEx](https://img.shields.io/badge/BepInEx-5.0+-orange?style=for-the-badge)
![Version](https://img.shields.io/github/v/release/duugagno/sangris-vrising-mod?style=for-the-badge&color=crimson)
![Downloads](https://img.shields.io/github/downloads/duugagno/sangris-vrising-mod/total?style=for-the-badge&color=darkred)

**Mod avançado para V Rising com sistema de atualização automática**

[🚀 Baixar Launcher](#-instalação-automática) • [📋 Releases](https://github.com/duugagno/sangris-vrising-mod/releases) • [🐛 Reportar Bug](https://github.com/duugagno/sangris-vrising-mod/issues)

</div>

---

## 📋 Sobre o Projeto

O **Sangris Interface** é um mod avançado para V Rising que oferece melhorias na interface e funcionalidades adicionais. Este repositório utiliza o **Sangria Launcher** para distribuição e atualizações automáticas, garantindo que os jogadores sempre tenham a versão mais recente.

### ✨ Características

- 🔄 **Atualizações automáticas** via Sangria Launcher
- 🛡️ **Verificação de integridade** com SHA256
- 📦 **Instalação simplificada** com um clique
- 🎮 **Compatível** com a versão mais recente do V Rising
- ⚡ **Performance otimizada** para gameplay fluido

---

## 🚀 Instalação Automática

### Para Jogadores

1. **Baixe o Sangria Launcher**
   ```
   https://github.com/duugagno/sangria-launcher/releases
   ```

2. **Configure o launcher:**
   - **Pasta do jogo**: `D:\SteamLibrary\steamapps\common\VRising`
   - **Manifest URL**: `https://raw.githubusercontent.com/duugagno/sangris-vrising-mod/main/manifest.json`
   - **Steam URI**: `steam://rungameid/1604030`

3. **Instale o mod:**
   - Clique em "Verificar/Atualizar"
   - Aguarde o download automático
   - Clique em "Jogar" para iniciar o V Rising

### 📁 Estrutura de Instalação

```
📂 V Rising/
├── 📂 BepInEx/
│   ├── 📂 plugins/
│   │   └── 📄 SangrisInterface.dll  ← Mod instalado aqui
│   └── 📂 core/
└── 📄 VRising.exe
```

---

## 🔄 Versões e Changelog

### 📅 v1.0.0 - Versão Inicial
- ✅ Implementação base do SangrisInterface
- ✅ Compatibilidade com V Rising atual
- ✅ Sistema de atualização automática

<details>
<summary>📊 Detalhes Técnicos v1.0.0</summary>

- **SHA256**: `825fa1c9d3a7724370ce51dc32c69f8a380344400cd63bb4ac7289cdad1e343b`
- **Tamanho**: 336,384 bytes
- **Data**: 15/10/2025
</details>

---

## ⚙️ Requisitos do Sistema

| Componente | Requisito |
|------------|-----------|
| **Jogo** | V Rising (Steam) |
| **Framework** | BepInEx 5.0+ |
| **Sistema** | Windows 10/11 |
| **RAM** | 4GB+ recomendado |
| **Espaço** | ~500MB livre |

---

## �️ Para Desenvolvedores

### 🔧 Atualizando o Mod

1. **Execute o script de atualização:**
   ```powershell
   .\update-sangris.ps1 "1.1.0"
   ```

2. **O script automaticamente:**
   - 📁 Copia o novo arquivo
   - 🔐 Calcula hash SHA256
   - 📝 Atualiza manifest.json
   - 📤 Faz commit e push

3. **Crie a release no GitHub:**
   - Acesse [Releases](https://github.com/duugagno/sangris-vrising-mod/releases)
   - "Create a new release"
   - Tag: `v1.1.0`
   - Anexe o arquivo `SangrisInterface.dll`

### 📋 Estrutura do Manifest

```json
{
  "version": "1.0.0",
  "files": [
    {
      "path": "BepInEx/plugins/SangrisInterface.dll",
      "url": "https://github.com/duugagno/sangris-vrising-mod/releases/download/v1.0.0/SangrisInterface.dll",
      "sha256": "825fa1c9d3a7724370ce51dc32c69f8a380344400cd63bb4ac7289cdad1e343b",
      "size": 336384
    }
  ]
}
```

---

## 🤝 Contribuindo

1. **Fork** o repositório
2. **Crie** uma branch para sua feature: `git checkout -b feature/nova-funcionalidade`
3. **Commit** suas mudanças: `git commit -m 'Adiciona nova funcionalidade'`
4. **Push** para a branch: `git push origin feature/nova-funcionalidade`
5. **Abra** um Pull Request

---

## � Suporte

### 🐛 Encontrou um bug?
- [Abra uma issue](https://github.com/duugagno/sangris-vrising-mod/issues/new?template=bug_report.md)
- Inclua logs e steps para reproduzir

### 💡 Tem uma sugestão?
- [Abra uma feature request](https://github.com/duugagno/sangris-vrising-mod/issues/new?template=feature_request.md)
- Descreva detalhadamente sua ideia

### 💬 Comunidade
- Discord: [Link do servidor]
- Steam: [Página do mod]

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 🙏 Agradecimentos

- **Stunlock Studios** - Pelo incrível jogo V Rising
- **BepInEx Team** - Pela framework de modding
- **Comunidade V Rising** - Pelo suporte e feedback

---

<div align="center">

**⭐ Se este mod foi útil, deixe uma estrela no repositório!**

[![GitHub stars](https://img.shields.io/github/stars/duugagno/sangris-vrising-mod?style=social)](https://github.com/duugagno/sangris-vrising-mod/stargazers)

</div>