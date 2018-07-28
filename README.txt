You will need to have OCaml and opam installed. If you do not, please follow the [instructions here](http://www.cs.cornell.edu/courses/cs3110/2018sp/install.html).

If you are using a Mac, you will likely need to install X11/XQuartz for Graphics support. If you installed ocaml with homebrew, it can be done by running
```
brew install Caskroom/cask/xquartz
brew reinstall ocaml --with-x11
```

Then, map opam to use the system installation instead of the currently bound one: opam switch sys. Then run eval `opam config env` as instructed.

You might also need to install the Graphics module. It can be done by running
```
opam install graphics
```

After successfully installing the external libraries, you will be able to run
```
make play
```
to launch the game.
