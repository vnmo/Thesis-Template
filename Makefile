DOCNAME := MAIN

SOURCES := $(DOCNAME).tex \
	$(wildcard ./body/*.tex) $(wildcard ./body/**/*.tex) \
	$(wildcard ./publications/*.tex) $(wildcard ./publications/**/*) $(wildcard ./publications/**/**/*) \
	$(wildcard ./Figs/*) $(wildcard ./Figs/**/*) \
	$(wildcard ./bibliography/*.bib)

PDFTEX := pdflatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape

.PHONY : clean $(DOCNAME).pdf update-biblatex

all : clean $(DOCNAME).pdf

$(DOCNAME).pdf : $(SOURCES)
	$(PDFTEX) $<
	biber $(DOCNAME)
	makeglossaries $(DOCNAME)
	$(PDFTEX) $<
	$(PDFTEX) $<

clean :
	rm -f *.pdf *.aux *-blx.bib *.bbl *.blg *.dvi *.log *.out *.run.xml *.synctex.gz *.toc *.bcf *.glg *.glo *.gls *.ist *.xdy
	rm -f body/*.aux
	rm -f body/**/*.aux
	rm -f publications/*.aux
	rm -f publications/**/*.aux

update-biblatex :
	# tlmgr init-usertree
	# mkdir -p  /Users/molguin/texmf/tlpkg/backups
	tlmgr --usermode update --self
	tlmgr --usermode update biblatex
