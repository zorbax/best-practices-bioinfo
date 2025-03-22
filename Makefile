default: build

all: build pdf

build:
	@rm -rf .virtual_documents/
	@jupyter-book build book/
	@cp -r book/content/static/data/ book/_build/html/content

pdf:
	@jupyter-book build book/ --builder pdflatex
	@mv book/_build/latex/book.pdf book/_build/html/content
	@rm -rf book/_build/latex

clean:
	@jupyter-book clean book/ --all
