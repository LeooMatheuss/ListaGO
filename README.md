>>>>>>> INÍCIO

<div align="center">

# 🛒 ListaGo

**Organizador inteligente de listas de compras para o dia a dia do supermercado brasileiro.**

[![CI](https://github.com/leomatheus/listago/actions/workflows/ci.yaml/badge.svg)](https://github.com/leomatheus/listago/actions/workflows/ci.yaml)
[![Release](https://github.com/leomatheus/listago/actions/workflows/release.yaml/badge.svg)](https://github.com/leomatheus/listago/actions/workflows/release.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Private](https://img.shields.io/badge/repo-privado-lightgrey)]()
[![codecov](https://codecov.io/gh/leomatheus/listago/branch/develop/graph/badge.svg)](https://codecov.io/gh/leomatheus/listago)

[Sobre](#-sobre-o-projeto) •
[Funcionalidades](#-funcionalidades) •
[Stack técnica](#-stack-técnica) •
[Arquitetura](#-arquitetura) •
[Como rodar](#-como-rodar-o-projeto) •
[Testes](#-testes) •
[CI/CD](#-cicd)

</div>

---

## 📱 Sobre o projeto

**ListaGo** é um aplicativo multiplataforma (Android/iOS) para organização de listas de compras, com **categorização automática de produtos** baseada em um dicionário de termos em português do Brasil combinado com aprendizado local das preferências do usuário.

O objetivo é resolver um problema simples de forma direta: transformar uma lista de compras solta em uma lista **organizada pela ordem real das gôndolas do mercado**, sem exigir que o usuário classifique manualmente cada item.

> Este projeto nasceu como uma reescrita multiplataforma de uma versão nativa iOS (SwiftData), mantendo os mesmos princípios de design e arquitetura, adaptados ao ecossistema Flutter.

> 🔒 **Repositório privado e de uso pessoal.** Não são aceitas contribuições, pull requests ou forks de terceiros.

---

## ✨ Funcionalidades

- ✅ Criação e gerenciamento de múltiplas listas de compras
- 🧠 **Categorização automática** de produtos (mercearia, hortifruti, açougue, laticínios, limpeza, etc.) com correspondência em 3 níveis: exata → termo contido → palavra única
- 📚 **Aprendizado local**: quando o usuário corrige uma categoria sugerida, o app memoriza a preferência para próximas buscas
- ⭐ Listas e itens favoritos
- 🕘 Histórico de produtos comprados
- 🔍 Busca inteligente por itens já cadastrados
- 🌓 Suporte completo a tema claro/escuro, seguindo o tema do sistema
- ♿ Acessível: contraste validado (WCAG AA) e suporte a Dynamic Type

---

## 🛠 Stack técnica

| Camada | Tecnologia | Motivo da escolha |
|---|---|---|
| Framework | **Flutter** (Dart ^3.x) | Multiplataforma real, um único código-base para Android e iOS |
| Gerenciamento de estado | **Riverpod 2** | DI testável, sem boilerplate de `Provider` clássico, equivalente direto ao `@Observable` do padrão MVVM |
| Persistência local | **Drift** (SQLite type-safe) | Queries tipadas, migrations explícitas, e caminho aberto para sincronização remota futura |
| Design | **Material 3** | `ColorScheme.fromSeed` com vermelho como cor de destaque, validado contra WCAG AA em light/dark |
| Testes | **Swift Testing**-equivalente via `flutter_test` + `integration_test` | Cobertura unitária, de widget e end-to-end |
| CI/CD | **GitHub Actions** | Lint, análise estática, testes e build automatizados a cada PR |
| Build reprodutível | **Docker** | Ambiente de build determinístico, independente da máquina local |

---

## 🏗 Arquitetura

O projeto segue organização **feature-first** (não layer-first), com camadas internas enxutas por feature — evitando tanto a desorganização de um projeto sem padrão quanto o over-engineering de uma Clean Architecture com camadas excessivas para o escopo atual.

Princípios seguidos deliberadamente: **KISS, YAGNI e SOLID**.

```
lib/
├── core/
│   ├── theme/          # Design system: cores, tipografia, espaçamento
│   ├── logger/          # Logging estruturado (apenas debug)
│   ├── database/        # Schema Drift, migrations
│   └── utils/            # Normalização de texto e helpers puros
├── features/
│   ├── lists/
│   │   ├── data/          # Implementação dos repositórios
│   │   ├── domain/        # Contratos (interfaces) e entidades
│   │   └── presentation/  # Views e Notifiers (ViewModels)
│   ├── items/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── categorization/
│       ├── data/           # Dicionário de termos pt-BR (seed data)
│       ├── domain/         # Motor de categorização (3 níveis de match)
│       └── presentation/
└── main.dart
```

**Fluxo de dados:** `View` → `Notifier (ViewModel)` → `Repository (interface)` → `Repository (implementação Drift)` → `AppDatabase`.
Nenhuma camada acessa diretamente uma camada não adjacente — as Views nunca tocam repositórios ou banco de dados diretamente.

---

## 🚀 Como rodar o projeto

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão definida em `pubspec.yaml`)
- Android Studio / Xcode configurados para emuladores, ou dispositivo físico

### Passos

```bash
# Clonar o repositório
git clone https://github.com/leomatheus/listago.git
cd listago

# Instalar dependências
flutter pub get

# Gerar código (Drift/Riverpod code-gen)
dart run build_runner build --delete-conflicting-outputs

# Rodar o app
flutter run
```

### Build via Docker (ambiente reprodutível)

```bash
docker compose -f docker/docker-compose.yaml run build
```

O `.apk` gerado fica disponível em `build/app/outputs/flutter-apk/`.

---

## ✅ Testes

```bash
# Testes unitários e de widget
flutter test

# Com relatório de cobertura
flutter test --coverage

# Testes de integração (end-to-end)
flutter test integration_test
```

**Metas de cobertura:** 80%+ em `domain/` e `data/`; testes de widget focados nos fluxos críticos (criar lista, adicionar item com sugestão de categoria, marcar item comprado).

---

## ⚙️ CI/CD

O pipeline roda automaticamente via **GitHub Actions**:

| Workflow | Gatilho | O que faz |
|---|---|---|
| `ci.yaml` | PR ou push em `main`/`develop` | Formatação, lint (`flutter analyze --fatal-infos`), testes com cobertura, build-check Android e iOS |
| `release.yaml` | Tag `v*.*.*` | Build do App Bundle Android assinado e publicação automática de release no GitHub |

Branches protegidas (`main`, `develop`) exigem CI verde antes de qualquer merge.

---

## 🌳 Fluxo de branches e versionamento

```
main        → produção, sempre deployável, protegida
develop     → integração contínua
feature/*   → uma por funcionalidade
fix/*       → correções fora de produção
hotfix/*    → correções urgentes, nascem direto de main
```

Commits seguem [Conventional Commits](https://www.conventionalcommits.org/) (`feat`, `fix`, `refactor`, `test`, `chore`, `docs`, `ci`, `perf`) e o versionamento segue [SemVer](https://semver.org/). Detalhes completos do processo — incluindo o passo a passo de hotfix — estão em [`CONTRIBUTING.md`](CONTRIBUTING.md) (guia interno de workflow, não um convite a contribuições externas).

---

## 📄 Uso e propriedade

Projeto pessoal, de código fechado. Todos os direitos reservados ao autor — sem licença de uso, distribuição ou modificação por terceiros.

---

<div align="center">
Desenvolvido por <a href="https://github.com/leomatheus">Léo Matheus</a>
</div>

<<<<<<< FIM
