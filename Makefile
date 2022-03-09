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

pkgdown: .FORCE
	R -e 'pkgdown::build_site(override = list(template = list(package = "rotemplate")))'

.FORCE:

test:
	R -e 'devtools::test()'

doc:
	R -e 'devtools::document()'

spell_check:
	R -e 'devtools::spell_check()'

check:
	R -e 'devtools::check()'

check_all:
	R -e 'devtools::spell_check(); devtools::check(); devtools::check_rhub(); usethis::use_revdep()'
#	R -e 'devtools::check_win_release()'

build:
	R -e 'devtools::build()'

install: doc readme
	R -e 'devtools::check()'
	R -e 'devtools::install()'
