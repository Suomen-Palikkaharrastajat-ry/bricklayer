# AGENTS.md

## Build and test

All commands must run inside devenv:

```
devenv shell -- cabal build --offline
devenv shell -- cabal test --offline
devenv shell -- make build
devenv shell -- make blay-compose-all
devenv shell -- make dist
devenv shell -- make test
```

Do not use bare `cabal` outside devenv — GHC is only on PATH inside it.

## Source layout

```
src/
  Bricklayer/   brick-layout pipeline library
    BrickLayout.hs  .blay format: parse, serialise, render to SVG
    Blockify.hs     rasterise source SVG → brick grid
    Compose.hs      subtitle text composition below logo
    Animate.hs      assemble PNG frames → GIF / WebP
    Raster.hs       SVG → PNG / WebP via rsvg-convert / cwebp
    Favicons.hs     generate favicon PNGs + favicon.ico
  Cmd/          executable entry points
    Render.hs       blay-render
    Draft.hs        blay-draft
    Compose.hs      blay-compose
    Animate.hs      blay-animate
tests/
  Bricklayer/   BlockifySpec
layouts/        .blay files (masters + derived; all committed)
scripts/        text_to_path.py (used by make outline-text)
fonts/          Outfit variable font (subtitle composition)
```

## Three-tool pipeline

```
blay-draft  --source SRC.svg --output layouts/head-basic.blay   # local only
make blay-compose-al                                            # derive all .blay; commit
make dist                                                       # .blay → logo/ + favicon/
```

Masters in `layouts/head-*.blay` use `F2CD37` as the face colour placeholder.

## Key make targets

| Target | Action |
|--------|--------|
| `make build` | compile all executables |
| `make blay-compose-all` | derive `.blay` files (run locally; commit) |
| `make dist` | render `.blay` → `logo/` and `favicon/` |
| `make test` | cabal test + hlint |
| `make check` | hlint only |
| `make format` | fourmolu in-place |
| `make clean` | remove generated files and build artifacts |

## Git rules

- Commit `.blay` files in `layouts/` (CI reads them)
- Do not commit `logo/` or `favicon/` (gitignored)
- Do not commit `TODO.md` or `TODO-*.md`
