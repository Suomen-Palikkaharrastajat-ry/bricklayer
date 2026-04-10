# ── Pipeline constants ────────────────────────────────────────────────────────
# Single source of truth — forwarded verbatim as CLI flags to the executables.
# Change a value here; no Haskell rebuild required.

FONT_PATH := fonts/Outfit-VariableFont_wght.ttf
SUBTITLE  := Suomen Palikkaharrastajat ry

BLK_W     := 24
BLK_H     := 20
SQ_PAD_V  := 20
HZ_PAD_TOP:= 20
GAP_STUDS := 2
TXT_SIZE       := 63
TXT_SIZE_BOLD  := 60
TXT_SIZE_SQ    := 24
TXT_SIZE_SQ_BOLD := 22
TXT_WEIGHT_BOLD := 700
HZ_BOLD_PAD_X  := 0
SUBTITLE_LINE1 := Suomen
SUBTITLE_LINE2 := Palikkaharrastajat ry
ANIM_MS        := 10000
RASTER_W  := 800
OG_W      := 1200
OG_H      := 630

# Subtitle colours (6-digit hex, no #)
SUBTITLE_LIGHT := 05131D
SUBTITLE_DARK  := FFFFFF

# Placeholder and skin-tone colours in master .blay files (6-digit hex, no #)
FACE_PH           := F2CD37
SKIN_WHITE        := FFFFFF
SKIN_YELLOW       := F2CD37
SKIN_LIGHT_NOUGAT := F6D7B3
SKIN_NOUGAT       := D09168
SKIN_DARK_NOUGAT  := AD6140

# Rainbow colours (6-digit hex, no #)
RB_SALMON   := F2705E
RB_ORANGE   := F9BA61
RB_YELLOW   := F2CD37
RB_GREEN    := 73DCA1
RB_BLUE     := 9FC3E9
RB_INDIGO   := 9195CA
RB_LAVENDER := AC78BA

_HZ_TILE := --tile --gap-studs $(GAP_STUDS) --pad-top $(HZ_PAD_TOP) --pad-bottom $(HZ_PAD_TOP)

# ── PATH trimming (prevents E2BIG when cabal spawns GHC) ─────────────────────
_GHC_BIN    := $(shell dirname $(shell which ghc          2>/dev/null) 2>/dev/null)
_CABAL_BIN  := $(shell dirname $(shell which cabal        2>/dev/null) 2>/dev/null)
_RSVG_BIN   := $(shell dirname $(shell which rsvg-convert 2>/dev/null) 2>/dev/null)
_WEBP_BIN   := $(shell dirname $(shell which cwebp        2>/dev/null) 2>/dev/null)
_GIFSKI_BIN := $(shell dirname $(shell which gifski       2>/dev/null) 2>/dev/null)
_ICO_BIN    := $(shell dirname $(shell which icotool      2>/dev/null) 2>/dev/null)
_MAGICK_BIN := $(shell dirname $(shell which convert      2>/dev/null) 2>/dev/null)
_SLIM_PATH  := $(_GHC_BIN):$(_CABAL_BIN):$(_RSVG_BIN):$(_WEBP_BIN):$(_GIFSKI_BIN):$(_ICO_BIN):$(_MAGICK_BIN):/usr/bin:/bin
CABAL       := env PATH="$(_SLIM_PATH)" cabal

HS_SOURCES := $(shell find src -name '*.hs') bricklayer.cabal $(wildcard cabal.project*)

# ── Output roots ─────────────────────────────────────────────────────────────
SQ_SVG := dist/public/logo/square/svg
SQ_PNG := dist/public/logo/square/png
HZ_SVG := dist/public/logo/horizontal/svg
HZ_PNG := dist/public/logo/horizontal/png
FAVICON := dist/public
OG_SVG  := $(FAVICON)/og-image.svg
OG_PNG  := $(FAVICON)/og-image.png
OG_WEBP := $(FAVICON)/og-image.webp

# ── Phony help ────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# ── Haskell ───────────────────────────────────────────────────────────────────

.PHONY: build
build: ## Compile all Haskell executables (no run)
	$(CABAL) build --offline

# ── blay-compose: derive .blay files from masters (run locally; commit outputs)
#
# Masters: layouts/head-basic.blay ... layouts/head-laugh.blay use FACE_PH as placeholder.
# Draft a new master from a source SVG:
#   cabal run --offline blay-draft -- --source SRC.svg --output layouts/head-basic.blay

_COMPOSE = $(CABAL) run --offline blay-compose --

# Square smiley blays
layouts/square-basic.blay: layouts/head-basic.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-smile.blay: layouts/head-smile.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-blink.blay: layouts/head-blink.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-laugh.blay: layouts/head-laugh.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-mystery.blay: layouts/head-mystery.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-mystery.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-video.blay: layouts/head-video.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-video.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-marker.blay: layouts/head-marker.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-marker.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-bookmark.blay: layouts/head-bookmark.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-bookmark.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

layouts/square-construction.blay: layouts/head-construction.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-construction.blay:$(FACE_PH):$(SKIN_YELLOW) --output $@

# Black-and-white square blays (white face, dark details)
layouts/square-bw-basic.blay: layouts/head-basic.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_WHITE) --output $@

layouts/square-bw-smile.blay: layouts/head-smile.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_WHITE) --output $@

layouts/square-bw-blink.blay: layouts/head-blink.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_WHITE) --output $@

layouts/square-bw-laugh.blay: layouts/head-laugh.blay $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_WHITE) --output $@

_SQ_BLAYS := layouts/square-basic.blay layouts/square-smile.blay layouts/square-blink.blay layouts/square-laugh.blay

# Horizontal smiley blays
layouts/horizontal.blay: $(_SQ_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/square-basic.blay --input layouts/square-smile.blay --input layouts/square-blink.blay --input layouts/square-laugh.blay $(_HZ_TILE) --output $@

layouts/horizontal-rot1.blay: $(_SQ_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/square-smile.blay --input layouts/square-blink.blay --input layouts/square-laugh.blay --input layouts/square-basic.blay $(_HZ_TILE) --output $@

layouts/horizontal-rot2.blay: $(_SQ_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/square-blink.blay --input layouts/square-laugh.blay --input layouts/square-basic.blay --input layouts/square-smile.blay $(_HZ_TILE) --output $@

layouts/horizontal-rot3.blay: $(_SQ_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/square-laugh.blay --input layouts/square-basic.blay --input layouts/square-smile.blay --input layouts/square-blink.blay $(_HZ_TILE) --output $@

_MASTER_BLAYS := layouts/square-basic.blay layouts/square-smile.blay layouts/square-blink.blay layouts/square-laugh.blay

# Horizontal rainbow blays — sliding windows of 4 from 7 rainbow colours
layouts/horizontal-rainbow.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_SALMON) --input layouts/head-smile.blay:$(FACE_PH):$(RB_ORANGE) --input layouts/head-blink.blay:$(FACE_PH):$(RB_YELLOW) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_GREEN) $(_HZ_TILE) --output $@

layouts/horizontal-rainbow-rot1.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_ORANGE) --input layouts/head-smile.blay:$(FACE_PH):$(RB_YELLOW) --input layouts/head-blink.blay:$(FACE_PH):$(RB_GREEN) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_BLUE) $(_HZ_TILE) --output $@

layouts/horizontal-rainbow-rot2.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_YELLOW) --input layouts/head-smile.blay:$(FACE_PH):$(RB_GREEN) --input layouts/head-blink.blay:$(FACE_PH):$(RB_BLUE) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_INDIGO) $(_HZ_TILE) --output $@

layouts/horizontal-rainbow-rot3.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_GREEN) --input layouts/head-smile.blay:$(FACE_PH):$(RB_BLUE) --input layouts/head-blink.blay:$(FACE_PH):$(RB_INDIGO) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_LAVENDER) $(_HZ_TILE) --output $@

layouts/horizontal-rainbow-rot4.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_BLUE) --input layouts/head-smile.blay:$(FACE_PH):$(RB_INDIGO) --input layouts/head-blink.blay:$(FACE_PH):$(RB_LAVENDER) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_SALMON) $(_HZ_TILE) --output $@

layouts/horizontal-rainbow-rot5.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_INDIGO) --input layouts/head-smile.blay:$(FACE_PH):$(RB_LAVENDER) --input layouts/head-blink.blay:$(FACE_PH):$(RB_SALMON) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_ORANGE) $(_HZ_TILE) --output $@

layouts/horizontal-rainbow-rot6.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(RB_LAVENDER) --input layouts/head-smile.blay:$(FACE_PH):$(RB_SALMON) --input layouts/head-blink.blay:$(FACE_PH):$(RB_ORANGE) --input layouts/head-laugh.blay:$(FACE_PH):$(RB_YELLOW) $(_HZ_TILE) --output $@

# Horizontal skintone blays — sliding 4 skin colors
layouts/horizontal-skintone.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_YELLOW) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_LIGHT_NOUGAT) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_NOUGAT) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_DARK_NOUGAT) $(_HZ_TILE) --output $@

layouts/horizontal-skintone-rot1.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_LIGHT_NOUGAT) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_NOUGAT) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_DARK_NOUGAT) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_YELLOW) $(_HZ_TILE) --output $@

layouts/horizontal-skintone-rot2.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_NOUGAT) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_DARK_NOUGAT) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_YELLOW) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_LIGHT_NOUGAT) $(_HZ_TILE) --output $@

layouts/horizontal-skintone-rot3.blay: $(_MASTER_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_DARK_NOUGAT) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_YELLOW) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_LIGHT_NOUGAT) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_NOUGAT) $(_HZ_TILE) --output $@

_BW_SQ_BLAYS := layouts/square-bw-basic.blay layouts/square-bw-smile.blay layouts/square-bw-blink.blay layouts/square-bw-laugh.blay

# Black-and-white horizontal blays (white face, dark details)
layouts/horizontal-bw.blay: $(_BW_SQ_BLAYS) $(HS_SOURCES)
	$(_COMPOSE) --input layouts/head-basic.blay:$(FACE_PH):$(SKIN_WHITE) --input layouts/head-smile.blay:$(FACE_PH):$(SKIN_WHITE) --input layouts/head-blink.blay:$(FACE_PH):$(SKIN_WHITE) --input layouts/head-laugh.blay:$(FACE_PH):$(SKIN_WHITE) $(_HZ_TILE) --output $@

DERIVED_BLAYS := \
  layouts/square-basic.blay layouts/square-smile.blay \
  layouts/square-blink.blay layouts/square-laugh.blay \
  layouts/square-mystery.blay layouts/square-video.blay \
  layouts/square-marker.blay layouts/square-bookmark.blay \
  layouts/square-construction.blay \
  layouts/square-bw-basic.blay layouts/square-bw-smile.blay \
  layouts/square-bw-blink.blay layouts/square-bw-laugh.blay \
  layouts/horizontal.blay layouts/horizontal-rot1.blay \
  layouts/horizontal-rot2.blay layouts/horizontal-rot3.blay \
  layouts/horizontal-rainbow.blay layouts/horizontal-rainbow-rot1.blay \
  layouts/horizontal-rainbow-rot2.blay layouts/horizontal-rainbow-rot3.blay \
  layouts/horizontal-rainbow-rot4.blay layouts/horizontal-rainbow-rot5.blay \
  layouts/horizontal-rainbow-rot6.blay \
  layouts/horizontal-skintone.blay layouts/horizontal-skintone-rot1.blay \
  layouts/horizontal-skintone-rot2.blay layouts/horizontal-skintone-rot3.blay \
  layouts/horizontal-bw.blay

.PHONY: blay-compose-all
blay-compose-all: build $(DERIVED_BLAYS) ## Derive all .blay files (run locally; commit outputs)

# ── blay-render: .blay -> SVG + PNG + WebP ───────────────────────────────────
# Each .blay is an independent Make target: one run produces all formats.
# No stamp files — the output files themselves are the targets.

_RENDER = $(CABAL) run --offline blay-render --

_COMPOSE_FLAGS := \
  --compose-font '$(FONT_PATH)' \
  --compose-text '$(SUBTITLE)' \
  --compose-text-weight 400 \
  --compose-text-size $(TXT_SIZE) \
  --compose-light-color $(SUBTITLE_LIGHT) \
  --compose-dark-color $(SUBTITLE_DARK) \
  --compose-pad-bottom 0

_COMPOSE_FLAGS_BOLD := \
  --compose-font '$(FONT_PATH)' \
  --compose-text '$(SUBTITLE)' \
  --compose-text-weight $(TXT_WEIGHT_BOLD) \
  --compose-text-size $(TXT_SIZE_BOLD) \
  --compose-light-color $(SUBTITLE_LIGHT) \
  --compose-dark-color $(SUBTITLE_DARK) \
  --compose-pad-bottom 0 \
  --compose-pad-x $(HZ_BOLD_PAD_X)

_COMPOSE_FLAGS_SQ := \
  --compose-font '$(FONT_PATH)' \
  --compose-text '$(SUBTITLE_LINE1)' \
  --compose-text2 '$(SUBTITLE_LINE2)' \
  --compose-text-weight 400 \
  --compose-text-size $(TXT_SIZE_SQ) \
  --compose-light-color $(SUBTITLE_LIGHT) \
  --compose-dark-color $(SUBTITLE_DARK) \
  --compose-pad-bottom 0 \
  --compose-square

_COMPOSE_FLAGS_SQ_BOLD := \
  --compose-font '$(FONT_PATH)' \
  --compose-text '$(SUBTITLE_LINE1)' \
  --compose-text2 '$(SUBTITLE_LINE2)' \
  --compose-text-weight $(TXT_WEIGHT_BOLD) \
  --compose-text-size $(TXT_SIZE_SQ_BOLD) \
  --compose-light-color $(SUBTITLE_LIGHT) \
  --compose-dark-color $(SUBTITLE_DARK) \
  --compose-pad-bottom 0 \
  --compose-square

# Macro: render a square-basic.blay => SVG + PNG + WebP (no subtitle composition)
# $(1) = stem (e.g. square-basic)
define render_square
$(SQ_SVG)/$(1).svg $(SQ_PNG)/$(1).png $(SQ_PNG)/$(1).webp &: layouts/$(1).blay $(HS_SOURCES) | build
	@mkdir -p $(SQ_SVG) $(SQ_PNG)
	$(_RENDER) \
	  --input layouts/$(1).blay \
	  --svg-out  $(SQ_SVG)/$(1).svg \
	  --png-out  $(SQ_PNG)/$(1).png \
	  --webp-out $(SQ_PNG)/$(1).webp \
	  --width $(RASTER_W)
endef

# Macro: render a horizontal blay => SVG + PNG + WebP + light/dark composed variants
# (regular weight 400 + bold weight 700)
# $(1) = stem (e.g. horizontal)
define render_horizontal
$(HZ_SVG)/$(1).svg $(HZ_PNG)/$(1).png $(HZ_PNG)/$(1).webp \
$(HZ_SVG)/$(1)-full.svg $(HZ_PNG)/$(1)-full.png $(HZ_PNG)/$(1)-full.webp \
$(HZ_SVG)/$(1)-full-dark.svg $(HZ_PNG)/$(1)-full-dark.png $(HZ_PNG)/$(1)-full-dark.webp \
$(HZ_SVG)/$(1)-full-bold.svg $(HZ_PNG)/$(1)-full-bold.png $(HZ_PNG)/$(1)-full-bold.webp \
$(HZ_SVG)/$(1)-full-dark-bold.svg $(HZ_PNG)/$(1)-full-dark-bold.png $(HZ_PNG)/$(1)-full-dark-bold.webp &: layouts/$(1).blay $(FONT_PATH) $(HS_SOURCES) | build
	@mkdir -p $(HZ_SVG) $(HZ_PNG)
	$(_RENDER) \
	  --input    layouts/$(1).blay \
	  --svg-out  $(HZ_SVG)/$(1).svg \
	  --png-out  $(HZ_PNG)/$(1).png \
	  --webp-out $(HZ_PNG)/$(1).webp \
	  --width $(RASTER_W) \
	  $(_COMPOSE_FLAGS) \
	  --compose-svg-out       $(HZ_SVG)/$(1)-full.svg \
	  --compose-png-out       $(HZ_PNG)/$(1)-full.png \
	  --compose-webp-out      $(HZ_PNG)/$(1)-full.webp \
	  --compose-dark-svg-out  $(HZ_SVG)/$(1)-full-dark.svg \
	  --compose-dark-png-out  $(HZ_PNG)/$(1)-full-dark.png \
	  --compose-dark-webp-out $(HZ_PNG)/$(1)-full-dark.webp
	$(_RENDER) \
	  --input    layouts/$(1).blay \
	  --width $(RASTER_W) \
	  $(_COMPOSE_FLAGS_BOLD) \
	  --compose-svg-out       $(HZ_SVG)/$(1)-full-bold.svg \
	  --compose-png-out       $(HZ_PNG)/$(1)-full-bold.png \
	  --compose-webp-out      $(HZ_PNG)/$(1)-full-bold.webp \
	  --compose-dark-svg-out  $(HZ_SVG)/$(1)-full-dark-bold.svg \
	  --compose-dark-png-out  $(HZ_PNG)/$(1)-full-dark-bold.png \
	  --compose-dark-webp-out $(HZ_PNG)/$(1)-full-dark-bold.webp
endef

# square-basic is rendered by the favicon rule below (single grouped target);
# the remaining square faces go through the render_square macro.
_SQ_DERIVED := square-laugh square-blink square-basic square-mystery square-video square-marker square-bookmark square-construction square-bw-basic square-bw-smile square-bw-blink square-bw-laugh
SQ_STEMS    := square-smile $(_SQ_DERIVED)
HZ_STEMS    := \
  horizontal horizontal-rot1 horizontal-rot2 horizontal-rot3 \
  horizontal-rainbow horizontal-rainbow-rot1 horizontal-rainbow-rot2 \
  horizontal-rainbow-rot3 horizontal-rainbow-rot4 \
  horizontal-rainbow-rot5 horizontal-rainbow-rot6 \
  horizontal-skintone horizontal-skintone-rot1 horizontal-skintone-rot2 \
  horizontal-skintone-rot3 \
  horizontal-bw

$(foreach s,$(_SQ_DERIVED),$(eval $(call render_square,$(s))))
$(foreach s,$(HZ_STEMS),$(eval $(call render_horizontal,$(s))))

# Favicons — generated alongside the square-smile PNG (the primary neutral face)
$(SQ_SVG)/square-smile.svg $(SQ_PNG)/square-smile.png $(SQ_PNG)/square-smile.webp $(FAVICON)/favicon.ico $(FAVICON)/icon-maskable.png &: layouts/square-smile.blay $(HS_SOURCES) | build
	@mkdir -p $(SQ_SVG) $(SQ_PNG) $(FAVICON)
	$(_RENDER) \
	  --input    layouts/square-smile.blay \
	  --svg-out  $(SQ_SVG)/square-smile.svg \
	  --png-out  $(SQ_PNG)/square-smile.png \
	  --webp-out $(SQ_PNG)/square-smile.webp \
	  --width $(RASTER_W) \
	  --favicon-dir $(FAVICON)

$(FAVICON)/favicon.svg: $(SQ_SVG)/square-smile.svg
	cp $< $@

WEB_ICON_OUTPUTS := \
  $(FAVICON)/favicon.ico \
  $(FAVICON)/favicon.svg \
  $(FAVICON)/apple-touch-icon.png \
  $(FAVICON)/apple-touch-icon-192.png \
  $(FAVICON)/apple-touch-icon-512.png \
  $(FAVICON)/favicon-16x16.png \
  $(FAVICON)/favicon-32x32.png \
  $(FAVICON)/favicon-48x48.png \
  $(FAVICON)/icon-192.png \
  $(FAVICON)/icon-512.png \
  $(FAVICON)/icon-maskable.png

# Default Open Graph image: horizontal full dark bold on a 1200x630 canvas
$(OG_SVG) $(OG_PNG) $(OG_WEBP) &: layouts/horizontal.blay $(FONT_PATH) $(HS_SOURCES) | build
	@mkdir -p $(FAVICON)
	$(_RENDER) \
	  --input layouts/horizontal.blay \
	  --width $(OG_W) \
	  $(_COMPOSE_FLAGS_BOLD) \
	  --compose-background    $(SUBTITLE_LIGHT) \
	  --compose-canvas-width  $(OG_W) \
	  --compose-canvas-height $(OG_H) \
	  --compose-dark-svg-out  $(OG_SVG) \
	  --compose-dark-png-out  $(OG_PNG) \
	  --compose-dark-webp-out $(OG_WEBP)

OG_IMAGE_OUTPUTS := $(OG_SVG) $(OG_PNG) $(OG_WEBP)

# Square logo with two-line centered text below (normal + bold, light + dark)
$(SQ_SVG)/square-smile-full.svg $(SQ_PNG)/square-smile-full.png $(SQ_PNG)/square-smile-full.webp \
$(SQ_SVG)/square-smile-full-dark.svg $(SQ_PNG)/square-smile-full-dark.png $(SQ_PNG)/square-smile-full-dark.webp \
$(SQ_SVG)/square-smile-full-bold.svg $(SQ_PNG)/square-smile-full-bold.png $(SQ_PNG)/square-smile-full-bold.webp \
$(SQ_SVG)/square-smile-full-dark-bold.svg $(SQ_PNG)/square-smile-full-dark-bold.png $(SQ_PNG)/square-smile-full-dark-bold.webp &: layouts/square-smile.blay $(FONT_PATH) $(HS_SOURCES) | build
	@mkdir -p $(SQ_SVG) $(SQ_PNG)
	$(_RENDER) \
	  --input layouts/square-smile.blay \
	  --width $(RASTER_W) \
	  $(_COMPOSE_FLAGS_SQ) \
	  --compose-svg-out       $(SQ_SVG)/square-smile-full.svg \
	  --compose-png-out       $(SQ_PNG)/square-smile-full.png \
	  --compose-webp-out      $(SQ_PNG)/square-smile-full.webp \
	  --compose-dark-svg-out  $(SQ_SVG)/square-smile-full-dark.svg \
	  --compose-dark-png-out  $(SQ_PNG)/square-smile-full-dark.png \
	  --compose-dark-webp-out $(SQ_PNG)/square-smile-full-dark.webp
	$(_RENDER) \
	  --input layouts/square-smile.blay \
	  --width $(RASTER_W) \
	  $(_COMPOSE_FLAGS_SQ_BOLD) \
	  --compose-svg-out       $(SQ_SVG)/square-smile-full-bold.svg \
	  --compose-png-out       $(SQ_PNG)/square-smile-full-bold.png \
	  --compose-webp-out      $(SQ_PNG)/square-smile-full-bold.webp \
	  --compose-dark-svg-out  $(SQ_SVG)/square-smile-full-dark-bold.svg \
	  --compose-dark-png-out  $(SQ_PNG)/square-smile-full-dark-bold.png \
	  --compose-dark-webp-out $(SQ_PNG)/square-smile-full-dark-bold.webp

_SQ_FULL_OUTPUTS := \
  $(SQ_SVG)/square-smile-full.svg $(SQ_PNG)/square-smile-full.png $(SQ_PNG)/square-smile-full.webp \
  $(SQ_SVG)/square-smile-full-dark.svg $(SQ_PNG)/square-smile-full-dark.png $(SQ_PNG)/square-smile-full-dark.webp \
  $(SQ_SVG)/square-smile-full-bold.svg $(SQ_PNG)/square-smile-full-bold.png $(SQ_PNG)/square-smile-full-bold.webp \
  $(SQ_SVG)/square-smile-full-dark-bold.svg $(SQ_PNG)/square-smile-full-dark-bold.png $(SQ_PNG)/square-smile-full-dark-bold.webp

ALL_SQ_OUTPUTS := $(foreach s,$(SQ_STEMS),$(SQ_SVG)/$(s).svg $(SQ_PNG)/$(s).png $(SQ_PNG)/$(s).webp) $(_SQ_FULL_OUTPUTS)
ALL_HZ_OUTPUTS := $(foreach s,$(HZ_STEMS), \
  $(HZ_SVG)/$(s).svg $(HZ_PNG)/$(s).png $(HZ_PNG)/$(s).webp \
  $(HZ_SVG)/$(s)-full.svg $(HZ_PNG)/$(s)-full.png $(HZ_PNG)/$(s)-full.webp \
  $(HZ_SVG)/$(s)-full-dark.svg $(HZ_PNG)/$(s)-full-dark.png $(HZ_PNG)/$(s)-full-dark.webp \
  $(HZ_SVG)/$(s)-full-bold.svg $(HZ_PNG)/$(s)-full-bold.png $(HZ_PNG)/$(s)-full-bold.webp \
  $(HZ_SVG)/$(s)-full-dark-bold.svg $(HZ_PNG)/$(s)-full-dark-bold.png $(HZ_PNG)/$(s)-full-dark-bold.webp)

# ── blay-animate: PNG frames -> animated GIF + WebP ──────────────────────────

_ANIMATE = $(CABAL) run --offline blay-animate --
# Yellow-face stems only — bw variants are excluded from the animation
_SQ_ANIM_STEMS   := square-smile square-laugh square-blink square-basic
_SQ_FRAMES       := $(foreach s,$(_SQ_ANIM_STEMS),$(SQ_PNG)/$(s).png)
_HZ_SKIN_STEMS   := horizontal horizontal-rot1 horizontal-rot2 horizontal-rot3
_RB_STEMS        := horizontal-rainbow horizontal-rainbow-rot1 horizontal-rainbow-rot2 horizontal-rainbow-rot3 horizontal-rainbow-rot4 horizontal-rainbow-rot5 horizontal-rainbow-rot6
_SC_STEMS        := horizontal-skintone horizontal-skintone-rot1 horizontal-skintone-rot2 horizontal-skintone-rot3
_HZ_FRAMES           := $(foreach s,$(_HZ_SKIN_STEMS),$(HZ_PNG)/$(s).png)
_HZ_FULL_FRAMES      := $(foreach s,$(_HZ_SKIN_STEMS),$(HZ_PNG)/$(s)-full.png)
_HZ_DARK_FRAMES      := $(foreach s,$(_HZ_SKIN_STEMS),$(HZ_PNG)/$(s)-full-dark.png)
_HZ_BOLD_FRAMES      := $(foreach s,$(_HZ_SKIN_STEMS),$(HZ_PNG)/$(s)-full-bold.png)
_HZ_DARK_BOLD_FRAMES := $(foreach s,$(_HZ_SKIN_STEMS),$(HZ_PNG)/$(s)-full-dark-bold.png)
_RB_FRAMES       := $(foreach s,$(_RB_STEMS),$(HZ_PNG)/$(s).png)
_RB_FULL_FRAMES  := $(foreach s,$(_RB_STEMS),$(HZ_PNG)/$(s)-full.png)
_RB_DARK_FRAMES  := $(foreach s,$(_RB_STEMS),$(HZ_PNG)/$(s)-full-dark.png)
_SC_FRAMES       := $(foreach s,$(_SC_STEMS),$(HZ_PNG)/$(s).png)
_SC_FULL_FRAMES  := $(foreach s,$(_SC_STEMS),$(HZ_PNG)/$(s)-full.png)
_SC_DARK_FRAMES  := $(foreach s,$(_SC_STEMS),$(HZ_PNG)/$(s)-full-dark.png)

$(SQ_PNG)/square-animated.gif $(SQ_PNG)/square-animated.webp &: $(_SQ_FRAMES) | build
	@mkdir -p $(SQ_PNG)
	$(_ANIMATE) $(foreach f,$(_SQ_FRAMES),--input $(f)) --gif-out $(SQ_PNG)/square-animated.gif --webp-out $(SQ_PNG)/square-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-animated.gif $(HZ_PNG)/horizontal-animated.webp &: $(_HZ_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_HZ_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-animated.gif --webp-out $(HZ_PNG)/horizontal-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-full-animated.gif $(HZ_PNG)/horizontal-full-animated.webp &: $(_HZ_FULL_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_HZ_FULL_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-full-animated.gif --webp-out $(HZ_PNG)/horizontal-full-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-full-dark-animated.gif $(HZ_PNG)/horizontal-full-dark-animated.webp &: $(_HZ_DARK_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_HZ_DARK_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-full-dark-animated.gif --webp-out $(HZ_PNG)/horizontal-full-dark-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-full-bold-animated.gif $(HZ_PNG)/horizontal-full-bold-animated.webp &: $(_HZ_BOLD_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_HZ_BOLD_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-full-bold-animated.gif --webp-out $(HZ_PNG)/horizontal-full-bold-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-full-dark-bold-animated.gif $(HZ_PNG)/horizontal-full-dark-bold-animated.webp &: $(_HZ_DARK_BOLD_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_HZ_DARK_BOLD_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-full-dark-bold-animated.gif --webp-out $(HZ_PNG)/horizontal-full-dark-bold-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-rainbow-animated.gif $(HZ_PNG)/horizontal-rainbow-animated.webp &: $(_RB_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_RB_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-rainbow-animated.gif --webp-out $(HZ_PNG)/horizontal-rainbow-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-rainbow-full-animated.gif $(HZ_PNG)/horizontal-rainbow-full-animated.webp &: $(_RB_FULL_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_RB_FULL_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-rainbow-full-animated.gif --webp-out $(HZ_PNG)/horizontal-rainbow-full-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-rainbow-full-dark-animated.gif $(HZ_PNG)/horizontal-rainbow-full-dark-animated.webp &: $(_RB_DARK_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_RB_DARK_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-rainbow-full-dark-animated.gif --webp-out $(HZ_PNG)/horizontal-rainbow-full-dark-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-skintone-animated.gif $(HZ_PNG)/horizontal-skintone-animated.webp &: $(_SC_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_SC_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-skintone-animated.gif --webp-out $(HZ_PNG)/horizontal-skintone-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-skintone-full-animated.gif $(HZ_PNG)/horizontal-skintone-full-animated.webp &: $(_SC_FULL_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_SC_FULL_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-skintone-full-animated.gif --webp-out $(HZ_PNG)/horizontal-skintone-full-animated.webp --anim-ms $(ANIM_MS)

$(HZ_PNG)/horizontal-skintone-full-dark-animated.gif $(HZ_PNG)/horizontal-skintone-full-dark-animated.webp &: $(_SC_DARK_FRAMES) | build
	@mkdir -p $(HZ_PNG)
	$(_ANIMATE) $(foreach f,$(_SC_DARK_FRAMES),--input $(f)) --gif-out $(HZ_PNG)/horizontal-skintone-full-dark-animated.gif --webp-out $(HZ_PNG)/horizontal-skintone-full-dark-animated.webp --anim-ms $(ANIM_MS)


ALL_ANIMATIONS := \
  $(SQ_PNG)/square-animated.gif $(SQ_PNG)/square-animated.webp \
  $(HZ_PNG)/horizontal-animated.gif $(HZ_PNG)/horizontal-animated.webp \
  $(HZ_PNG)/horizontal-full-animated.gif $(HZ_PNG)/horizontal-full-animated.webp \
  $(HZ_PNG)/horizontal-full-dark-animated.gif $(HZ_PNG)/horizontal-full-dark-animated.webp \
  $(HZ_PNG)/horizontal-full-bold-animated.gif $(HZ_PNG)/horizontal-full-bold-animated.webp \
  $(HZ_PNG)/horizontal-full-dark-bold-animated.gif $(HZ_PNG)/horizontal-full-dark-bold-animated.webp \
  $(HZ_PNG)/horizontal-rainbow-animated.gif $(HZ_PNG)/horizontal-rainbow-animated.webp \
  $(HZ_PNG)/horizontal-rainbow-full-animated.gif $(HZ_PNG)/horizontal-rainbow-full-animated.webp \
  $(HZ_PNG)/horizontal-rainbow-full-dark-animated.gif $(HZ_PNG)/horizontal-rainbow-full-dark-animated.webp \
  $(HZ_PNG)/horizontal-skintone-animated.gif $(HZ_PNG)/horizontal-skintone-animated.webp \
  $(HZ_PNG)/horizontal-skintone-full-animated.gif $(HZ_PNG)/horizontal-skintone-full-animated.webp \
  $(HZ_PNG)/horizontal-skintone-full-dark-animated.gif $(HZ_PNG)/horizontal-skintone-full-dark-animated.webp

# ── Text outlining (post-process full composed SVGs) ─────────────────────────
ALL_FULL_SVGS := $(foreach s,$(HZ_STEMS),$(HZ_SVG)/$(s)-full.svg $(HZ_SVG)/$(s)-full-dark.svg $(HZ_SVG)/$(s)-full-bold.svg $(HZ_SVG)/$(s)-full-dark-bold.svg) \
  $(SQ_SVG)/square-smile-full.svg $(SQ_SVG)/square-smile-full-dark.svg \
  $(SQ_SVG)/square-smile-full-bold.svg $(SQ_SVG)/square-smile-full-dark-bold.svg \
  $(OG_SVG)

.PHONY: outline-text
outline-text: $(ALL_FULL_SVGS) ## Outline subtitle text in composed horizontal SVGs
	python3 scripts/text_to_path.py '$(FONT_PATH)' $(ALL_FULL_SVGS)

# ── render: all static logo assets ───────────────────────────────────────────

dist: $(ALL_SQ_OUTPUTS) $(ALL_HZ_OUTPUTS) $(ALL_ANIMATIONS) $(WEB_ICON_OUTPUTS) $(OG_IMAGE_OUTPUTS) ## Render all .blay files to dist/

all: dist

# ── Testing & linting ─────────────────────────────────────────────────────────

.PHONY: test
test: ## Run Haskell test suite and hlint
	$(CABAL) test --offline
	$(MAKE) check

.PHONY: check
check: ## Run hlint static analysis
	hlint src tests

.PHONY: cabal-check
cabal-check: ## Check the package for common errors
	$(CABAL) check

.PHONY: format
format: ## Auto-format Haskell source files
	find src -name '*.hs' | xargs fourmolu --mode inplace

# ── Watching ──────────────────────────────────────────────────────────────────

.PHONY: watch
watch: ## Re-run dist on .hs/.cabal/.blay changes (requires entr)
	{ find src app tests \( -name '*.hs' -o -name '*.cabal' \); find layouts -name '*.blay'; } | entr -r $(MAKE) dist

# ── REPL ──────────────────────────────────────────────────────────────────────

.PHONY: repl
repl: ## Open GHCi REPL
	$(CABAL) repl --offline

# ── Cleanup ───────────────────────────────────────────────────────────────────

.PHONY: clean
clean: ## Remove all generated files and build artifacts
	$(CABAL) clean
	rm -rf dist/ __pycache__

# ── Devenv ────────────────────────────────────────────────────────────────────

.PHONY: develop
develop: devenv.local.nix devenv.local.yaml ## Bootstrap devenv shell + VS Code
	devenv shell --profile=devcontainer -- code .

.PHONY: shell
shell: ## Enter devenv shell
	devenv shell

devenv.local.nix:
	cp devenv.local.nix.example devenv.local.nix

devenv.local.yaml:
	cp devenv.local.yaml.example devenv.local.yaml
