# -*- coding: utf-8 -*-
# Generyczny, automatyczny Makefile, dla LATEXa.

DOCUMENTS   := $(strip $(shell cat PROJECT | sed -n 's/^[ ]*DOCS[ ]*=[ ]*\(.*\)/\1/p'))

PDFDOCS	    := $(subst .tex,.pdf,$(DOCUMENTS))
PDFDOCSRC   := $(subst .pdf,.tex,$(PDFDOCS))

ifneq ($(strip $(PDFDOCSRC)),)
   PDFDOCS1 := $(subst .tex,.pdf,$(shell egrep -l '^\\bibliography\{' $(PDFDOCSRC)))
else
   PDFDOCS1 :=
endif
PDFDOCS0 := $(filter-out $(PDFDOCS1),$(PDFDOCS))


all: $(PDFDOCS0) $(PDFDOCS1)

$(PDFDOCS0) : %.pdf : %.tex
	pdflatex $<
	pdflatex $<
	pdflatex $<

$(PDFDOCS1) : %.pdf : %.tex references.bib
	pdflatex $<
	bibtex $(subst .pdf,,$@)
	pdflatex $<
	pdflatex $<

clean:
	-rm -f $(PDFDOCS) $(subst .pdf,.aux,$(PDFDOCS)) $(subst .pdf,.log,$(PDFDOCS)) $(subst .pdf,.toc,$(PDFDOCS)) $(subst .pdf,.bbl,$(PDFDOCS)) $(subst .pdf,.blg,$(PDFDOCS)) $(subst .pdf,.out,$(PDFDOCS)) $(subst .pdf,.maf,$(PDFDOCS)) $(subst .pdf,.mtc,$(PDFDOCS)) $(subst .pdf,.mtc0,$(PDFDOCS)) cmds.aux

ifneq ($(wildcard Makefile-include),)
include Makefile-include
endif
