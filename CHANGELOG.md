# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/specification.html).

## [Unreleased]

### Added
- Scaffold inicial com arquitetura feature-first (MVVM + Riverpod 2 + Drift)
- Design system Material 3 com tokens de cor, espaçamento, tipografia e raio
- Banco de dados SQLite local via Drift com persistência em arquivo
- CRUD completo de listas de compras (criar, listar, favoritar, duplicar, deletar)
- CRUD completo de itens por lista (adicionar, marcar comprado, remover)
- Motor de categorização determinístico em 3 níveis (exato → frase contida → palavra)
- Seed dictionary com ~120 termos em português do Brasil
- Aprendizado local de categorias por preferência do usuário
- Agrupamento de itens por categoria na tela de detalhe
- Barra de progresso de compra
- Suporte completo a tema claro/escuro seguindo o sistema
- Estado vazio e de erro em todas as telas
- CI com análise estática, formatação, testes e build-check Android/iOS
- Pipeline de release automatizado por tags SemVer com AAB assinado
- Ambiente de build Docker reproduzível para Android
- Templates de PR/Issue, CODEOWNERS e guia de contribuição

### Fixed
- Banco de dados substituído de memória para arquivo persistente (dados preservados entre sessões)
- `drift_dev` movido para `dev_dependencies` (reduz tamanho do APK)
- `onDelete: cascade` adicionado em `shopping_items.list_id` (sem itens órfãos)
- Unique constraints adicionados em `learned_categories.term` e `product_memories.normalized_name`
- Índices de banco adicionados em `shopping_items(list_id)` e `shopping_items(list_id, bought)`
- Memory leak de `TextEditingController` corrigido em `_showCreateListDialog`
- Mensagens de erro técnicas substituídas por mensagens amigáveis ao usuário
- `permissions: contents: write` adicionado no job de release do GitHub Actions
- Token do Codecov adicionado no workflow de CI
- Entidades de domínio `ShoppingList` e `ShoppingItem` com `==` e `hashCode`

### Removed
- Arquivos de teste duplicados (`debug_categorization_test`, `category_service_test`)
