# Command Smart - Documentação do Projeto

## Visão Geral
Command Smart é uma aplicação desktop Windows desenvolvida em Flutter para gerenciar e executar comandos de desenvolvimento de forma eficiente. O aplicativo permite salvar, organizar e executar comandos comuns usados no desenvolvimento de software.

## Estrutura do Projeto

```
command_smart/
├── lib/
│   ├── database/
│   │   ├── database.dart         # Configuração do banco de dados Drift
│   │   └── database.g.dart       # Código gerado do Drift
│   ├── models/
│   │   ├── git_credentials.dart  # Modelo para credenciais Git
│   │   └── saved_project.dart    # Modelo para projetos salvos
│   ├── providers/
│   │   ├── command_provider.dart    # Gerenciamento de comandos
│   │   ├── directory_provider.dart  # Gerenciamento de diretórios
│   │   └── git_credentials_provider.dart # Gerenciamento de credenciais Git
│   ├── screens/
│   │   └── home_screen.dart      # Tela principal do aplicativo
│   ├── services/
│   │   ├── database_service.dart # Serviços de banco de dados
│   │   └── directory_watcher_service.dart # Monitoramento de diretórios
│   ├── widgets/
│   │   ├── command_categories.dart  # Lista de categorias de comandos
│   │   ├── directory_bar.dart      # Barra de diretório
│   │   ├── draggable_window.dart   # Janela arrastável
│   │   └── git_credentials_manager.dart # Gerenciador de credenciais Git
│   └── main.dart                # Ponto de entrada da aplicação
├── windows/                     # Configurações específicas do Windows
├── installer.iss               # Script do instalador Inno Setup
├── pubspec.yaml                # Dependências do Flutter
└── .gitignore                  # Configuração de arquivos ignorados
```

## Funcionalidades Principais

### 1. Gerenciamento de Diretórios
- Salva diretórios de projetos localmente
- Monitora alterações nos diretórios
- Backup automático do banco de dados
- Navegação rápida entre projetos

### 2. Categorias de Comandos
1. **Git Init Commands**
   - Inicialização de repositório
   - Configuração de remote
   - Commits iniciais
   - Gerenciamento de branches

2. **Git Commands**
   - Operações básicas do Git
   - Status, add, commit, push
   - Gerenciamento de forks

3. **Flutter Commands**
   - Clean, pub get
   - Build e run
   - Comandos de desenvolvimento

4. **Flutter Windows Fix**
   - Correção de problemas Windows
   - Recriação de projeto Windows
   - Atualização de dependências

5. **Docker Commands**
   - Gerenciamento de containers
   - Operações com imagens
   - Compose up/down
   - Logs e execução

6. **NodeJS Commands**
   - Gerenciamento de pacotes
   - Scripts npm
   - Build e desenvolvimento

7. **Git Advanced Commands**
   - Stash
   - Reset
   - Checkout
   - Backup de branches

8. **Windows Commands**
   - Criação de ZIP
   - Gerenciamento de terminais
   - Comandos administrativos
   - Utilitários do sistema

### 3. Recursos de Comandos
- Timer para execução temporizada
- Confirmação de exclusão
- Cópia rápida para clipboard
- Execução interativa/não-interativa
- Feedback visual de execução

### 4. Armazenamento
- Banco de dados SQLite local
- Backup automático do banco
- Diretórios:
  - `/projetosalvos/` - Banco de dados principal
  - `/projetosalvosBKP/` - Backup automático

### 5. Interface
- Design moderno e escuro
- Janela arrastável personalizada
- Categorias expansíveis
- Barra de diretório integrada
- Feedback visual de ações

## Execução de Comandos

### Fluxo de Execução
1. Seleção de diretório de trabalho
2. Escolha da categoria
3. Seleção do comando
4. Configuração do timer (opcional)
5. Execução do comando

### Tipos de Comandos
1. **Não Interativos**
   ```dart
   {
     'name': 'Nome do Comando',
     'command': 'comando --param',
     'description': 'Descrição',
     'interactive': 'false'
   }
   ```

2. **Interativos**
   ```dart
   {
     'name': 'Nome do Comando',
     'command': 'comando',
     'description': 'Descrição',
     'interactive': 'true'
   }
   ```

### Timer de Execução
- Ativação por ícone
- Configuração em segundos
- Fechamento automático do terminal
- Feedback visual do tempo

## Instalação

### Requisitos
- Windows 10 ou superior
- Flutter SDK
- Visual Studio com C++ build tools
- Inno Setup (para criar instalador)

### Compilação
```batch
flutter clean
flutter pub get
flutter build windows
```

### Criação do Instalador
```batch
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer.iss
```

## Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  window_manager: ^0.3.7
  provider: ^6.0.5
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.2
  path: ^1.8.3
  file_picker: ^6.1.1
  process_run: ^0.13.1
  intl: ^0.19.0
```

## Considerações de Desenvolvimento
1. **Arquivos Grandes**
   - Evitar commits de arquivos >100MB
   - Usar .gitignore adequado
   - Manter backups separados

2. **Segurança**
   - Não armazenar tokens sensíveis
   - Validar comandos interativos
   - Backup automático de dados

3. **Performance**
   - Monitoramento assíncrono de diretórios
   - Execução eficiente de comandos
   - Cache de comandos frequentes

4. **Manutenção**
   - Código modular
   - Providers para estado
   - Serviços isolados
   - Widgets reutilizáveis 