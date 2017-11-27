all: clean_all data_all doc test paper readme

#CLEANING
#remove any intermediate files
clean:
	rm -f README.md

clean_all: clean

#TESTS
test:




#DOCUMENTATION
#document the package
doc:
	R -e 'devtools::document()'

check:
	R -e 'devtools::check()'

build:
	R -e 'devtools::build()'

#Project README
readme: README.Rmd
	#R -e "knitr::knit('README.Rmd')"
	R -e "rmarkdown::render('$(<F)')"

#R PACKAGE
#build and install the package
install: doc readme
	R -e 'devtools::check()'
	R -e 'devtools::install()'
