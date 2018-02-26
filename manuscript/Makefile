all: dtool.pdf

dtool.pdf: dtool.tex
	pdflatex dtool
	pdflatex -interaction=batchmode dtool

dtool.tex: manuscript.md references.bib 
	~/.cabal/bin/pandoc -s manuscript.md -t latex -o dtool.tex --filter pandoc-citeproc --bibliography=./references.bib --template=mytemplate.tex

clean:
	rm dtool.*
