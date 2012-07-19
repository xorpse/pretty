OCAMLC = ocamlc
OCAMLOPT = ocamlopt

INTERFACES = pretty_types.cmi pretty.cmi
OPT_IMPLS = pretty.cmx
BYTE_IMPLS = pretty.cmo

%.cmi: %.mli
	$(OCAMLC) -o $@ -c $<

%.cmo: %.ml
	$(OCAMLC) -o $@ -c $<

%.cmx: %.ml
	$(OCAMLOPT) -o $@ -c $<

byte: $(INTERFACES) $(BYTE_IMPLS)
	$(OCAMLC) -a -o pretty.cma unix.cma $(BYTE_IMPLS)

opt: $(INTERFACES) $(OPT_IMPLS)
	$(OCAMLOPT) -a -o pretty.cmxa unix.cmxa $(OPT_IMPLS)

clean:
	rm -f *.{a,cm*,o,out}
