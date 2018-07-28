test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte -runner sequential

play:
	ocamlbuild -use-ocamlfind main.byte && ./main.byte

state:
	ocamlbuild -use-ocamlfind state.byte && ./state.byte

ai:
	ocamlbuild -use-ocamlfind ai.byte && ./ai.byte

clean:
	ocamlbuild -clean
