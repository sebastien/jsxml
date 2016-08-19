# =============================================================================
# PYTHON MODULE MAKEFILE
# -----------------------------------------------------------------------------
# Updated: 2016-08-16
# Created: 2016-08-16
# License: MIT License
# =============================================================================

SRC=src
DIST=dist

SOURCES_XSL_PAML   = $(wildcard src/*.xsl.paml)
EXAMPLES_XML_PAML  = $(wildcard examples/*.xml.paml)
DIST_FILES         = $(SOURCES_XSL_PAML:$(SRC)/%.xsl.paml=$(DIST)/%.xsl) \
                     $(EXAMPLES_XML_PAML:%.xml.paml=$(DIST)/%.xml) \
                     $(EXAMPLES_XML_PAML:%.xml.paml=$(DIST)/%.js)  \
                     README.md
BUILD_ID     ?=$(shell git rev-parse --verify HEAD)

TEXTO              = texto
LITTERATE          = litterate
PAMELA             = pamela
XSLTPROC           = xsltproc
PRETTY_JS          = pretty-js

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

dist/%.xml: %.xml.paml
	@echo "$(GREEN)📝  $@$(RESET)"
	@mkdir -p `dirname $@`
	@$(PAMELA) $< | sed -e 's|../src/xsl/||g' > $@

dist/%.js: dist/%.xml dist/jsxml.xsl
	@echo "$(GREEN)📝  $@$(RESET)"
	@mkdir -p `dirname $@`
	@$(XSLTPROC) dist/jsxml.xsl $< | $(PRETTY_JS) > $@

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

push: dist
	@echo "$(CYAN)→ Pushing changes $@$(RESET)"
	@git commit -a -m "Building dist files for $(BUILD_ID)"
	@git push --all

FORCE:

# EOF
