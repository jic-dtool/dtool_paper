all: dtool.pdf

dtool.pdf: dtool.tex
	pdflatex dtool
	pdflatex -interaction=batchmode dtool

dtool.tex: manuscript.rst references.bib 
	~/.cabal/bin/pandoc -s manuscript.rst -t latex -o dtool.tex  --filter pandoc-citeproc --bibliography=./references.bib

clean:
	rm dtool.*
