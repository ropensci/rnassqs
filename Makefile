all: clean_all doc test readme

#CLEANING
#remove any intermediate files
clean:
	rm -f README.md

clean_all: clean


#Project README
readme: README.Rmd
	R -e "rmarkdown::render('$(<F)')"

#Project Paper
paper: paper.Rmd
	R -e "rmarkdown::render('$(<F)')"

#R PACKAGE
codemeta:
	R -e 'codemetar::write_codemeta()'

pkgdown:
	R -e 'pkgdown::build_site()'

test:
	R -e 'devtools::test()'

doc:
	R -e 'devtools::document()'

check:
	R -e 'devtools::check()'

build:
	R -e 'devtools::build()'

install: doc readme
	R -e 'devtools::check()'
	R -e 'devtools::install()'
