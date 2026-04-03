# Bricklayer

Haskell pipeline that generates toy-brick-style logo assets.

## Requirements

[devenv](https://devenv.sh/) provides all dependencies. Enter the shell once:

```
devenv shell
```

## Usage

```bash
make build            # compile executables
make blay-compose-all # derive .blay variants from master layouts (commit outputs)
make dist             # render .blay → logo/ + favicon/ + design-guide.json
```

Run `make help` for all targets.

## Pipeline

1. **`blay-draft`** — rasterise a source SVG into a draft `.blay` layout file (local dev only)
2. **`blay-compose`** — derive colour/tile variants from master `.blay` files; commit outputs
3. **`blay-render`** — render committed `.blay` files to SVG, PNG, WebP, GIF, and favicons