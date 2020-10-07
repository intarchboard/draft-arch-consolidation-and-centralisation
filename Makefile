
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
	    -b master https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

cleantrash:
	rm -f draft-arkko-farrell-arch-model-t.txt
	rm -f draft-arkko-farrell-arch-model-t-3552-additions.txt
	rm -f draft-arkko-farrell-arch-model-t-7258-additions.txt
	rm -f *~

OLD=draft-arkko-farrell-arch-model-t-03.txt

jaricopy:	draft-iab-arch-consolidation-and-centralisation.txt \
		Makefile
	scp 	draft-iab-arch-consolidation-and-centralisation.txt \
		root@cloud3.arkko.eu:/var/www/www.arkko.com/html/ietf/iab
