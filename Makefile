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
	cd rpkg; R -e 'devtools::document()'


#Project README
readme: README.Rmd
	#R -e "knitr::knit('README.Rmd')"
	R -e "rmarkdown::render('$(<F)')"

#R PACKAGE
#build and install the package
install: doc
	R CMD check .
	R CMD INSTALL .

