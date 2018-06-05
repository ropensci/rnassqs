all: clean_all doc test readme

#CLEANING
#remove any intermediate files
clean:
	rm -f README.md

clean_all: clean


#Project README
readme: README.Rmd
	#R -e "knitr::knit('README.Rmd')"
	R -e "rmarkdown::render('$(<F)')"

#R PACKAGE
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
