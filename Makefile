RSCRIPT = Rscript --no-init-file

all: move rmd2md

move:
	cd inst/stuff;\
	cp local_setup.md ../../vignettes;\
	cp search.md ../../vignettes;\
	cp document_management.md ../../vignettes;\
	cp cores_collections.md ../../vignettes

rmd2md:
	cd vignettes;\
	mv search.md search.Rmd;\
	mv local_setup.md local_setup.Rmd;\
	mv document_management.md document_management.Rmd;\
	mv cores_collections.md cores_collections.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

codemeta:
	${RSCRIPT} -e "codemetar::write_codemeta()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

test:
	${RSCRIPT} -e 'devtools::test()'

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"
