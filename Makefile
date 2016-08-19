# =============================================================================
# PYTHON MODULE MAKEFILE
# -----------------------------------------------------------------------------
# Updated: 2016-08-16
# Created: 2016-08-16
# License: MIT License
# =============================================================================

SRC=src
DIST=dist

SOURCES_XSL_PAML=$(wildcard src/*.xsl.paml)
DIST_FILES      =$(SOURCES_XSL_PAML:$(SRC)/%.xsl.paml=$(DIST)/%.xsl) README.md

TEXTO              = texto
LITTERATE          = litterate
PAMELA             = pamela
XSLTPROC           = xsltproc

DEV_REQUIREMENTS   = texto litterate pamela
BUILD_REQUIREMENTS = xsltproc

# COLORS
YELLOW           =`tput setaf 11`
GREEN            =`tput setaf 10`
CYAN             =`tput setaf 14`
RED              =`tput setaf 1`
GRAY             =`tput setaf 7`
RESET            =`tput sgr0`


.PHONY: dist

# -----------------------------------------------------------------------------
#
# MAIN RULES
# 
# -----------------------------------------------------------------------------

dist: $(DIST_FILES)
	
clean:
	@echo "$(RED)♻  Cleaning $(words $(DIST_FILES)) files $(RESET)"
	@echo $(DIST_FILES) | xargs rm -f;  true

# -----------------------------------------------------------------------------
#
# BUILD FILES
# 
# -----------------------------------------------------------------------------

dist/%.xsl: src/%.xsl.paml
	@echo "$(GREEN)📝  $@$(RESET)"
	@mkdir -p `dirname $@`
	@$(PAMELA) $< > $@

README.md: src/jsxml.xsl.paml
	@echo "$(GREEN)📝  $@$(RESET)"
	@touch $@
	@chmod +w $@
	@$(LITTERATE) $< | $(TEXTO) -Omarkdown -xtools/apidoc.py - $@
	@chmod -w $@

# -----------------------------------------------------------------------------
#
# HELPERS
# 
# -----------------------------------------------------------------------------

print-%:
	@echo $*=$($*) | xargs -n1 echo

FORCE:

# EOF
