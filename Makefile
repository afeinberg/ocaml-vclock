FILES= \
	versioned.cmi vectorClock.cmi conflictResolver.cmi \
	vclock.cma vclock.cmxa vclock.a

BFILES=$(addprefix _build/lib/,$(FILES))

.PHONY: all
all:
	ocamlbuild lib/vclock.cma lib/vclock.cmxa

test:
	ocamlbuild lib_test/basic.native
	./basic.native; echo

.PHONY: all
doc:
	ocamlbuild -no-links lib/doc.docdir/index.html

.PHONY: install
install:
	ocamlfind install vclock lib/META $(BFILES)

.PHONY: uninstall
uninstall:
	ocamlfind remove vclock

.PHONY: reinstall
reinstall: all uninstall install

.PHONY: clean
clean:
	ocamlbuild -clean
