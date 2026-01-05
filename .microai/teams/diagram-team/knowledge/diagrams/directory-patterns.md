# Directory Structure Patterns

Reference cho visualizing project layouts.

---

## Basic Syntax

```mermaid
graph TD
    root["project/"]
    root --> src["src/"]
    root --> tests["tests/"]
    src --> main["main.go"]
```

---

## Common Project Structures

### Go Project (Clean Architecture)

```mermaid
graph TD
    root["go-project/"]

    root --> cmd["cmd/"]
    root --> internal["internal/"]
    root --> pkg["pkg/"]
    root --> api["api/"]
    root --> configs["configs/"]
    root --> scripts["scripts/"]
    root --> docs["docs/"]

    cmd --> server["server/"]
    server --> main["main.go"]

    internal --> domain["domain/"]
    internal --> usecase["usecase/"]
    internal --> repository["repository/"]
    internal --> delivery["delivery/"]

    domain --> entities["entities/"]
    delivery --> http["http/"]
    delivery --> grpc["grpc/"]

    pkg --> logger["logger/"]
    pkg --> database["database/"]

    api --> openapi["openapi.yaml"]

    configs --> config["config.yaml"]
    configs --> env[".env.example"]
```

### Node.js/TypeScript Project

```mermaid
graph TD
    root["node-project/"]

    root --> src["src/"]
    root --> tests["tests/"]
    root --> public["public/"]
    root --> node_modules["node_modules/"]
    root --> package["package.json"]
    root --> tsconfig["tsconfig.json"]

    src --> components["components/"]
    src --> pages["pages/"]
    src --> hooks["hooks/"]
    src --> utils["utils/"]
    src --> services["services/"]
    src --> types["types/"]
    src --> app["App.tsx"]
    src --> index["index.tsx"]

    components --> common["common/"]
    components --> layout["layout/"]

    tests --> unit["unit/"]
    tests --> integration["integration/"]
    tests --> e2e["e2e/"]
```

### Python Project (FastAPI)

```mermaid
graph TD
    root["python-project/"]

    root --> src["src/"]
    root --> tests["tests/"]
    root --> docs["docs/"]
    root --> pyproject["pyproject.toml"]
    root --> readme["README.md"]

    src --> app["app/"]
    app --> api["api/"]
    app --> core["core/"]
    app --> models["models/"]
    app --> services["services/"]
    app --> repositories["repositories/"]
    app --> schemas["schemas/"]
    app --> main["main.py"]

    api --> v1["v1/"]
    v1 --> endpoints["endpoints/"]

    core --> config["config.py"]
    core --> security["security.py"]
    core --> database["database.py"]

    tests --> conftest["conftest.py"]
    tests --> unit["unit/"]
    tests --> integration["integration/"]
```

### Monorepo (Turborepo/Nx)

```mermaid
graph TD
    root["monorepo/"]

    root --> apps["apps/"]
    root --> packages["packages/"]
    root --> tools["tools/"]
    root --> turbo["turbo.json"]

    apps --> web["web/"]
    apps --> api["api/"]
    apps --> mobile["mobile/"]

    packages --> ui["@repo/ui/"]
    packages --> utils["@repo/utils/"]
    packages --> config["@repo/config/"]
    packages --> types["@repo/types/"]

    web --> srcW["src/"]
    api --> srcA["src/"]
```

### Microservices

```mermaid
graph TD
    root["microservices/"]

    root --> services["services/"]
    root --> libs["libs/"]
    root --> deploy["deploy/"]
    root --> docker["docker-compose.yml"]

    services --> user["user-service/"]
    services --> order["order-service/"]
    services --> payment["payment-service/"]
    services --> notification["notification-service/"]

    user --> cmd1["cmd/"]
    user --> internal1["internal/"]
    user --> Dockerfile1["Dockerfile"]

    libs --> common["common/"]
    libs --> proto["proto/"]

    deploy --> k8s["kubernetes/"]
    deploy --> helm["helm/"]
```

---

## Styling

### With Icons

```mermaid
flowchart TD
    A[("📁 project")] --> B["📁 src"]
    A --> C["📁 tests"]
    A --> D["📄 package.json"]
    A --> E["📄 README.md"]

    B --> B1["📁 components"]
    B --> B2["📁 pages"]

    C --> C1["📁 unit"]
    C --> C2["📁 e2e"]
```

### With File Types

```mermaid
graph TD
    root["project/"]

    root --> src["src/"]
    root --> configs["configs/"]

    src --> ts["*.ts"]
    src --> tsx["*.tsx"]
    src --> css["*.css"]

    configs --> json["*.json"]
    configs --> yaml["*.yaml"]

    style ts fill:#007acc,color:#fff
    style tsx fill:#61dafb,color:#000
    style css fill:#264de4,color:#fff
    style json fill:#f5a623,color:#000
    style yaml fill:#cb171e,color:#fff
```

---

## Best Practices

1. **Focus on key directories** - Skip node_modules, .git
2. **Show 3-4 levels deep** - Not too detailed
3. **Group by purpose** - src, tests, configs, docs
4. **Highlight entry points** - main.go, index.ts
5. **Use consistent naming** - Match actual project
6. **Include config files** - package.json, go.mod
7. **Top-down layout** - TD direction
