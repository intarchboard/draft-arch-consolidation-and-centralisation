
MD_FILES= draft-iab-arch-consolidation-and-centralisation.md

base:	draft-iab-arch-consolidation-and-centralisation.txt

draft-iab-arch-consolidation-and-centralisation.txt:	$(MD_FILES)

LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

cleantrash:
	rm -f draft-iab-arch-consolidation-and-centralisation.txt
	rm -f *~

workingcompile:
	cat draft-iab-arch-consolidation-and-centralisation.md  | kramdown-rfc2629 | lib/add-note.py | xml2rfc -q --cache=/home/jar/.cache/xml2rfc --v2v3 /dev/stdin -o draft-iab-arch-consolidation-and-centralisation.xml
	xml2rfc draft-iab-arch-consolidation-and-centralisation.xml

JARISERVER=jar@levy3.arkko.eu
jaricompile:	draft-iab-arch-consolidation-and-centralisation.md \
		Makefile
	rm -rf	lib .refcache .targets.mk
	ssh	$(JARISERVER) rm -rf arch-consolidation-and-centralisation
	ssh	$(JARISERVER) mkdir arch-consolidation-and-centralisation
	scp	-rp * .??* $(JARISERVER):arch-consolidation-and-centralisation
	ssh	$(JARISERVER) 'cd arch-consolidation-and-centralisation; make workingcompile'
	scp	$(JARISERVER):arch-consolidation-and-centralisation/draft-iab-arch-consolidation-and-centralisation.txt .

jaricopy:	draft-iab-arch-consolidation-and-centralisation.txt \
		Makefile
	scp 	draft-iab-arch-consolidation-and-centralisation.txt \
		root@cloud3.arkko.eu:/var/www/www.arkko.com/html/ietf/iab
