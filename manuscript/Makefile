all: dtool.pdf supplementary_material.pdf

dtool.pdf: dtool.tex dataset_creation_sequence_diagram.png
	pdflatex dtool
	pdflatex -interaction=batchmode dtool

dtool.tex: manuscript.md references.bib 
	~/.cabal/bin/pandoc -s manuscript.md -t latex -o dtool.tex --filter pandoc-citeproc --bibliography=./references.bib --csl=./peerj.csl --template=mytemplate.tex

dataset_creation_sequence_diagram.png: dataset_creation_sequence_diagram.mmd mermaid_style.css
	mmdc -i dataset_creation_sequence_diagram.mmd -o dataset_creation_sequence_diagram.png -C mermaid_style.css

supplementary_material.pdf: supplementary_material.md
	~/.cabal/bin/pandoc -s supplementary_material.md -t latex -o supplementary_material.pdf

clean:
	rm dtool.*
	rm supplementary_material.pdf
	rm dataset_creation_sequence_diagram.png
