# template/Makefile.common
LATEX = pdflatex
LATEX_FLAGS = -pdf -interaction=nonstopmode -halt-on-error -file-line-error

notes.pdf: notes.tex
	$(LATEX) $(LATEX_FLAGS) $<

clean:
	$(LATEX) -C
