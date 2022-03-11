SHELL := /bin/bash


#CLEANING
#remove any intermediate files
clean:
	rm -f README.md
	rm rnassqs_*.tar.gz
	rm -r rnassqs.Rcheck

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

spell_check:
	R -e 'devtools::spell_check()'

doc:
	R -e 'devtools::document()'

check:
	R -e 'devtools::check()'

check_cmd:
	R CMD build . && R CMD check $$(ls -t . | head -n1)

check_rhub:
	R -e 'devtools::check_rhub()'

check_revdep:
	R -e 'usethis::use_revdep()'

check_win:
	R -e 'devtools::check_win_release()'

test:
	R -e 'devtools::test()'

release:
	R -e 'devtools::release()'

.FORCE:


docs: readme doc pkgdown codemeta

checks: spell_check check check_cmd check_rhub check_revdep

build:
	R -e 'devtools::build()'

install: docs check_cmd
	R -e 'devtools::install()'
	

all: clean_all docs test checks build install

