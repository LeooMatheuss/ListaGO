# Guia de contribuição

## Fluxo de branches
- `main`: branch deployável e protegido
- `develop`: branch de integração
- `feature/*`, `fix/*`, `hotfix/*`: branches de trabalho

## Convenção de commits
Use commits no formato Conventional Commits:
- `feat`: nova funcionalidade
- `fix`: correção de bug
- `refactor`: refatoração
- `test`: testes
- `chore`: manutenção
- `docs`: documentação
- `ci`: integração contínua
- `perf`: performance

## Fluxo de uma feature
1. Criar branch a partir de `develop`
2. Implementar e validar localmente
3. Abrir PR para `develop`
4. Realizar squash merge após aprovação

## Fluxo de hotfix
1. Criar branch a partir de `main`
2. Corrigir o problema e validar
3. Abrir PR direto para `main`
4. Criar tag SemVer após merge
5. Sincronizar `develop` com o hotfix

## Versionamento
Siga SemVer: `MAJOR.MINOR.PATCH`.

## Checklist pré-push
- [ ] `dart format` executado
- [ ] `flutter analyze --fatal-infos` sem erros
- [ ] `flutter test` verde
- [ ] CI verde
