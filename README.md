# Sangris Interface - V Rising Mod

## 📋 Sobre
Este repositório contém o mod **SangrisInterface** para V Rising, distribuído através do **Sangria Launcher**.

## 🚀 Como usar

### Para Jogadores
1. Baixe o [Sangria Launcher](https://github.com/SEUUSUARIO/SangriaLauncher/releases)
2. Configure a pasta do V Rising: `D:\SteamLibrary\steamapps\common\VRising`
3. Use a URL do manifest: `https://raw.githubusercontent.com/SEUUSUARIO/SEUREPOSITORIO/main/manifest.json`
4. Clique em "Verificar/Atualizar"

### Para Desenvolvedores
O arquivo será instalado em: `BepInEx/plugins/SangrisInterface.dll`

## 📁 Estrutura
```
VRising/
├── BepInEx/
│   └── plugins/
│       └── SangrisInterface.dll  ← Arquivo do mod
└── ...outros arquivos do jogo
```

## 🔄 Atualizações
- **v1.0.0**: Versão inicial do SangrisInterface
- SHA256: `825fa1c9d3a7724370ce51dc32c69f8a380344400cd63bb4ac7289cdad1e343b`
- Tamanho: 336,384 bytes

## ⚙️ Compatibilidade
- **Jogo**: V Rising
- **BepInEx**: 5.0+
- **Sistema**: Windows

## 📝 Manifest
O arquivo `manifest.json` contém:
- Lista de arquivos do mod
- URLs de download
- Hashes SHA256 para verificação
- Informações de tamanho

## 🔧 Desenvolvimento
Para atualizar o mod:
1. Substitua o arquivo na pasta `plugins/`
2. Recalcule o hash SHA256
3. Atualize o `manifest.json`
4. Crie uma nova release no GitHub