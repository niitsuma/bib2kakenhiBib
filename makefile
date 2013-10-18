.PHONY: all

all : mypub.tex

mypub.tex : list.bbl
	mv list.bbl mypub.tex

list.bbl: list.tex list_cite.tex bunken-KLbibtem.bst
	rm -f list.bbl
	platex list
	platex list
	pbibtex list



.PHONY: clean

clean:
	rm -f *.pdf *.dvi *.log *.vrb *.out *.toc *.nav *.snm *.aux *.blg 
