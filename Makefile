OCAMLC = ocamlc
OCAMLOPT = ocamlopt

AR = ocamlmklib

INTERFACES = pretty_types.mli pretty.mli
IMPLEMENTATIONS = pretty.ml

pretty: $(INTERFACES) $(IMPLEMENTATIONS)
	$(AR) -o $@ $^

clean:
	rm -f *.{a,cm*,o,out}
