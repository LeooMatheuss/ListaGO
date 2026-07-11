# ListaGO

![CI](https://github.com/LeooMatheuss/ListaGO/actions/workflows/ci.yaml/badge.svg)

## Cobertura de testes

Meta mínima de cobertura para validação contínua:
- 80% em domain/ e data/
- foco em fluxos críticos de listas, itens e categorização

Comandos principais:
- flutter test
- flutter test --coverage
- flutter analyze --fatal-infos

## Release automatizado

O workflow de release é disparado por tags SemVer no formato v*.*.* e publica um AAB assinado no GitHub Releases.

Próximo passo futuro para iOS: configurar certificados e provisioning profile para publicação na App Store.

## Build com Docker

Use Docker quando quiser garantir um ambiente de build reproduzível para Android, independente da máquina local.

### Como usar

```bash
docker compose -f docker/docker-compose.yaml run build
```

O APK gerado fica em `build/app/outputs/flutter-apk/`.

### Limitação

O build de iOS não está containerizado porque exige macOS nativo com Xcode e certificados/provisioning profile. O fluxo local de compilação para iOS continua sendo o build check do CI.

## Configuração de branches do GitHub

Para manter o fluxo profissional do repositório, as regras recomendadas são:
- `main`: exigir PR, exigir status check `analyze-and-test`, exigir 1 aprovação e bloquear force-push
- `develop`: exigir status check `analyze-and-test` e permitir apenas squash merge
