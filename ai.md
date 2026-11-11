# AI Guide

This file is the entry guide for AI agents working on `flutter_foundation_kit`.

## Read Order

Before changing this package, read these files first:

1. `README.md`
2. `architecture.md`
3. `lib/flutter_foundation_kit.dart`

Usually these files are enough to understand the package purpose, public API, and architecture boundary. Read `lib/README.md` only when a task needs detailed file-level responsibilities.

## Package Purpose

`flutter_foundation_kit` is a Flutter foundation package. It provides reusable base capabilities for new Flutter projects:

- REST networking
- logging
- settings loading
- lightweight store abstractions
- repository and storage ports
- default infrastructure adapters
- common utilities

The package core is not a complete app template. Keep application pages, routes, feature modules, business models, and app-specific DI setup out of `lib`. The repository does provide `example` plus `make create <ProjectName>` as an app template scaffold.

## Public API Rule

Application code should prefer:

```dart
import 'package:flutter_foundation_kit/flutter_foundation_kit.dart';
```

If a reusable API should be available to host apps, export it from `lib/flutter_foundation_kit.dart`.

Avoid adding new public APIs that require host apps to deep import from internal directories.

## Architecture Boundaries

- `lib/api`: REST contracts and response/error models.
- `lib/wcore`: core framework capabilities and default framework-level implementations.
- `lib/cport`: capability ports. Add new ports here.
- `lib/infra`: default infrastructure implementations backed by plugins.
- `lib/cutil`: generic utilities and extensions.
- `lib/port`: legacy compatibility entrypoint. Do not add new files here.
- `example`: usage demo, host-app composition, and source template for `make create`. Do not treat it as package core.

## Change Guidelines

- Keep edits scoped to the requested layer.
- Prefer abstractions already used by the package.
- Keep business-specific code out of `lib`.
- Keep plugin-specific code in `infra` or implementation files, not in ports.
- Add exports when adding new public APIs.
- Update `README.md` and `architecture.md` when package purpose or boundaries change.
- Update tests when shared behavior changes.

## Known Tradeoffs

The current package intentionally includes default implementations based on Dio, `logger`, `shared_preferences`, and `flutter_keychain` to speed up internal project startup.

This is acceptable for the current internal package stage. If the package is prepared for broader reuse or pub.dev release, consider splitting optional implementations into smaller adapter packages.
