all: dtool.pdf

dtool.pdf: dtool.tex dataset_creation_sequence_diagram.png
	pdflatex dtool
	pdflatex -interaction=batchmode dtool

dtool.tex: manuscript.md references.bib 
	~/.cabal/bin/pandoc -s manuscript.md -t latex -o dtool.tex --filter pandoc-citeproc --bibliography=./references.bib --csl=./peerj.csl --template=mytemplate.tex

dataset_creation_sequence_diagram.png: dataset_creation_sequence_diagram.mmd mermaid_style.css
	mmdc -i dataset_creation_sequence_diagram.mmd -o dataset_creation_sequence_diagram.png -C mermaid_style.css

clean:
	rm dtool.*
	rm dataset_creation_sequence_diagram.png
