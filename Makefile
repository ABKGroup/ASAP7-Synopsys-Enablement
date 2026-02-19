ifndef DESIGN
  $(error DESIGN is not defined)
endif

ifndef PEX_TOOL1
  $(error PEX_TOOL1 is not defined)
endif

ifndef CC1
  $(error CC1 is not defined)
endif

ifndef SI1
  $(error SI1 is not defined)
endif

ifndef PEX_TOOL2
  $(error PEX_TOOL2 is not defined)
endif

ifndef CC2
  $(error CC2 is not defined)
endif

ifndef SI2
  $(error SI2 is not defined)
endif

CASE ?= 1
NWORST ?= 1
STA_TOOL1 ?=
STA_TOOL2 ?=
STA1_TOOL ?=
STA2_TOOL ?=

HOME_DIR = $(dir $(lastword $(MAKEFILE_LIST)))
DESIGN_DIR = $(HOME_DIR)/benchmark
UTIL_DIR = $(HOME_DIR)/scripts/util
DONE_DIR = $(DESIGN_DIR)/$(DESIGN)/done
OSTRICH_RUNNER = $(UTIL_DIR)/run_ostrich_nowin.sh
RUN_OSTRICH ?= 1


define get_pex_abbr
$(shell arg=$$(echo "$1" | sed 's/^ *//; s/ *$$//'); \
       if [ "$$arg" = "innovus" ]; then echo "INVS"; \
       elif [ "$$arg" = "quantus" ]; then echo "QTS"; \
       elif [ "$$arg" = "fusion_compiler" ]; then echo "FC"; \
       elif [ "$$arg" = "starRC" ]; then echo "STRC"; \
       elif [ "$$arg" = "none" ]; then echo "NONE"; \
       else echo "Error: Invalid PEX_TOOL value: $$arg" >&2; exit 1; fi)
endef

define get_sta_abbr
$(shell arg=$$(echo "$1" | sed 's/^ *//; s/ *$$//' | tr '[:upper:]' '[:lower:]'); \
       if [ "$$arg" = "innovus" ]; then echo "INVS"; \
       elif [ "$$arg" = "tempus" ]; then echo "TPS"; \
       elif [ "$$arg" = "fusion_compiler" ]; then echo "FC"; \
       elif [ "$$arg" = "primetime" ]; then echo "PT"; \
       else echo "Error: Invalid STA_TOOL value: $$arg" >&2; exit 1; fi)
endef

define infer_sta_tool
$(shell arg=$$(echo "$1" | sed 's/^ *//; s/ *$$//' | tr '[:upper:]' '[:lower:]'); \
       if [ "$$arg" = "innovus" ] || [ "$$arg" = "quantus" ]; then echo "tempus"; \
       else echo "primetime"; fi)
endef

define canon_sta_tool
$(shell arg=$$(echo "$1" | sed 's/^ *//; s/ *$$//' | tr '[:upper:]' '[:lower:]'); \
       if [ -z "$$arg" ]; then echo ""; \
       elif [ "$$arg" = "innovus" ] || [ "$$arg" = "tempus" ] || [ "$$arg" = "fusion_compiler" ] || [ "$$arg" = "primetime" ]; then echo "$$arg"; \
       else echo "$$arg"; fi)
endef

STA_TOOL1_INPUT := $(strip $(if $(STA_TOOL1),$(STA_TOOL1),$(STA1_TOOL)))
STA_TOOL2_INPUT := $(strip $(if $(STA_TOOL2),$(STA_TOOL2),$(STA2_TOOL)))
STA_TOOLS_MISSING := $(if $(or $(STA_TOOL1_INPUT),$(STA_TOOL2_INPUT)),0,1)
RUN_STA := $(if $(STA_TOOLS_MISSING),0,1)
override STA_TOOL1 := $(if $(STA_TOOL1_INPUT),$(call canon_sta_tool,$(STA_TOOL1_INPUT)),$(call infer_sta_tool,$(PEX_TOOL1)))
override STA_TOOL2 := $(if $(STA_TOOL2_INPUT),$(call canon_sta_tool,$(STA_TOOL2_INPUT)),$(call infer_sta_tool,$(PEX_TOOL2)))


PEX1 := $(call get_pex_abbr, $(PEX_TOOL1))
STA1 := $(call get_sta_abbr, $(STA_TOOL1))

PEX2 := $(call get_pex_abbr, $(PEX_TOOL2))
STA2 := $(call get_sta_abbr, $(STA_TOOL2))


CAP_DONE_FILE = $(DONE_DIR)/cap_$(DESIGN)_$(PEX1)_$(CC1)_$(PEX2)_$(CC2)
CAP_FEATURE_DONE_FILE = $(DONE_DIR)/cap_feature_$(DESIGN)_$(PEX1)_$(CC1)_$(PEX2)_$(CC2)
PATH_DONE_FILE = $(DONE_DIR)/path_$(DESIGN)_$(PEX1)_$(STA1)_$(CC1)_$(SI1)_$(PEX2)_$(STA2)_$(CC2)_$(SI2)
TIMING_DONE_FILE = $(DONE_DIR)/timing_$(DESIGN)_$(PEX1)_$(STA1)_$(CC1)_$(SI1)_$(PEX2)_$(STA2)_$(CC2)_$(SI2)_$(CASE)
OSTRICH_OUT_DIR = $(DESIGN_DIR)/$(DESIGN)/plot/net_cap_net_from_ostrich/$(PEX1)_CC_$(CC1)_vs_$(PEX2)_CC_$(CC2)
OSTRICH_DONE_FILE = $(DONE_DIR)/ostrich_$(DESIGN)_$(PEX1)_$(CC1)_$(PEX2)_$(CC2)

.PHONY: all gen cap sta path timing ostrich

all: gen ostrich cap

ifneq ($(STA_TOOLS_MISSING),1)
all: sta path timing
endif

gen: 
	$(MAKE) -C scripts DESIGN=$(DESIGN) PEX_TOOL=$(PEX_TOOL1) STA_TOOL=$(STA_TOOL1) CC=$(CC1) SI=$(SI1) pex
	$(MAKE) -C scripts DESIGN=$(DESIGN) PEX_TOOL=$(PEX_TOOL2) STA_TOOL=$(STA_TOOL2) CC=$(CC2) SI=$(SI2) pex
	@echo "Successfully generated design data."

ifeq ($(RUN_OSTRICH),1)
ifneq ($(PEX_TOOL1),none)
ifneq ($(PEX_TOOL2),none)
ostrich: $(OSTRICH_DONE_FILE)
	@echo "Successfully generated Ostrich comparison outputs."
$(OSTRICH_DONE_FILE):
	@mkdir -p $(DONE_DIR)
	@SPEF1="$(DESIGN_DIR)/$(DESIGN)/$(DESIGN)_$(PEX1)_CC_$(CC1).spef"; \
	SPEF2="$(DESIGN_DIR)/$(DESIGN)/$(DESIGN)_$(PEX2)_CC_$(CC2).spef"; \
	OST_BIN="$${OSTRICH_BIN:-ostrich}"; \
	if [ "$$SPEF1" = "$$SPEF2" ]; then \
		echo "Skip Ostrich: identical SPEF inputs ($$SPEF1)"; \
	elif [ "$${OST_BIN#*/}" != "$$OST_BIN" ] && [ ! -x "$$OST_BIN" ]; then \
		echo "Warning: skip Ostrich because OSTRICH_BIN is not executable ($$OST_BIN)"; \
	elif [ "$${OST_BIN#*/}" = "$$OST_BIN" ] && ! command -v "$$OST_BIN" >/dev/null 2>&1; then \
		echo "Warning: skip Ostrich because '$$OST_BIN' is not found in PATH"; \
	else \
		$(OSTRICH_RUNNER) "$$SPEF1" "$$SPEF2" "$(OSTRICH_OUT_DIR)" "$(PEX1)" "$(PEX2)"; \
	fi
	@touch $@
else
ostrich:
	@echo "Skip Ostrich: PEX_TOOL2 is none."
endif
else
ostrich:
	@echo "Skip Ostrich: PEX_TOOL1 is none."
endif
else
ostrich:
	@echo "Skip Ostrich: RUN_OSTRICH=$(RUN_OSTRICH)"
endif

ifeq ($(STA_TOOLS_MISSING),1)
sta:
	@echo "Skip STA: STA_TOOL1/STA_TOOL2 were not explicitly provided."
else
sta:
	$(MAKE) -C scripts DESIGN=$(DESIGN) PEX_TOOL=$(PEX_TOOL1) STA_TOOL=$(STA_TOOL1) CC=$(CC1) SI=$(SI1) sta
	$(MAKE) -C scripts DESIGN=$(DESIGN) PEX_TOOL=$(PEX_TOOL2) STA_TOOL=$(STA_TOOL2) CC=$(CC2) SI=$(SI2) sta
	@echo "Successfully generated STA data."
endif

ifneq ($(PEX_TOOL1),none)
ifneq ($(PEX_TOOL2),none)
cap: $(CAP_DONE_FILE) $(CAP_FEATURE_DONE_FILE)
	@echo "Successfully generated net capacitance plot and summary."
$(CAP_DONE_FILE): sta
	@SPEF1="$(DESIGN_DIR)/$(DESIGN)/$(DESIGN)_$(PEX1)_CC_$(CC1).spef"; \
	SPEF2="$(DESIGN_DIR)/$(DESIGN)/$(DESIGN)_$(PEX2)_CC_$(CC2).spef"; \
	if [ "$$SPEF1" = "$$SPEF2" ]; then \
		echo "Skip cap comparison: identical SPEF inputs ($$SPEF1)"; \
		mkdir -p $(DONE_DIR); \
		touch $@; \
	else \
		cd $(UTIL_DIR) && python3 get_cap_data.py --DESIGN=$(DESIGN) --PEX1=$(PEX1) --PEX2=$(PEX2) --CC1=$(CC1) --CC2=$(CC2); \
	fi
$(CAP_FEATURE_DONE_FILE):
	@mkdir -p $(DONE_DIR)
	@M1="$(DESIGN_DIR)/$(DESIGN)/net_capacitance/$(PEX1)/CC_$(CC1)/net_metal_lengths.csv"; \
	V1="$(DESIGN_DIR)/$(DESIGN)/net_capacitance/$(PEX1)/CC_$(CC1)/net_via_counts.csv"; \
	M2="$(DESIGN_DIR)/$(DESIGN)/net_capacitance/$(PEX2)/CC_$(CC2)/net_metal_lengths.csv"; \
	V2="$(DESIGN_DIR)/$(DESIGN)/net_capacitance/$(PEX2)/CC_$(CC2)/net_via_counts.csv"; \
	MISSING=""; \
	for f in "$$M1" "$$V1" "$$M2" "$$V2"; do \
		if [ ! -f "$$f" ]; then MISSING="$$MISSING $$f"; fi; \
	done; \
	if [ -n "$$MISSING" ]; then \
		echo "Warning: cap feature files missing:$$MISSING"; \
		echo "status=missing"; \
	else \
		echo "status=ok"; \
	fi > $@
endif
endif


path: $(PATH_DONE_FILE)
	@echo "Successfully generated matching path data summary."

timing: $(TIMING_DONE_FILE)
	@echo "Successfully generated matching timing details plot and summary."

$(PATH_DONE_FILE):
	@cd $(UTIL_DIR) && python3 get_path_data.py --DESIGN=$(DESIGN) --PEX1=$(PEX1) --STA1=$(STA1) --CC1=$(CC1) --SI1=$(SI1) --PEX2=$(PEX2) --STA2=$(STA2) --CC2=$(CC2) --SI2=$(SI2) 

$(TIMING_DONE_FILE):
	@cd $(UTIL_DIR) && python3 get_timing_data.py --DESIGN=$(DESIGN) --PEX1=$(PEX1) --STA1=$(STA1) --CC1=$(CC1) --SI1=$(SI1) --PEX2=$(PEX2) --STA2=$(STA2) --CC2=$(CC2) --SI2=$(SI2) --CASE=$(CASE)
