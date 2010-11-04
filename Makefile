FILES=\
	versioned.cma versioned.cmxa versioned.a \
	versioned.mli versioned.cmi \
	vectorClock.cma vectorClock.cmxa vectorClock.a \
	conflictResolver.cma conflictRsolver.cmxa conflictResolver.a

BFILES=$(addprefix _build/lib/,$(FILES))

.PHONY: all
all:
	ocamlbuild -I lib versioned.cma versioned.cmxa
	ocamlbuild -I lib vectorClock.cma vectorClock.cmxa
	ocamlbuild -I lib conflictResolver.cma conflictResolver.cmxa

test:
	ocamlbuild -I lib lib_test/basic.native
	./basic.native; echo

.PHONY: all
doc:
	ocamlbuild -no-links lib/doc.docdir/index.html

.PHONY: install
install:
	ocamlfind install versioned lib/META $(BFILES)
	ocamlfind install vectorClock lib/META $(BFILES)
	ocamlfind install conflictResolver lib/META $(BFILES)

.PHONY: uninstall
uninstall:
	ocamlfind remove versioned
	ocamlfind remove vectorClock
	ocamlfind remove conflictResolver

.PHONY: reinstall
reinstall: all uninstall install

.PHONY: clean
clean:
	ocamlbuild -clean
