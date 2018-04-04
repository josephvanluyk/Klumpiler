# Klumpiler

Klumpiler is a project to create a compiler for the Klump programming language. Sample klump files can be found throughout the repository, indicated by **.klump** extensions.

To compile a new version of klumpiler, navigate to the klumpile directory
`cd klump/klumpile/`

And compile using g++
`g++ klumpile.cpp -o klumpile`

The previous command will create an executable named klumpile in the current directory. From there, you can add it to your system path as appropriate for your operating system. On Ubuntu this can be done by running `cp klumpile ~/bin/`. If `~/bin/` does not exist, create it first with `mkdir ~/bin/`.

To compile a *.klump* file using this compiler use the command `klumpile <klump program> [-o output executable] [-s output assembly]`

By default, it will create an executable named `a.out` in your current directory. The -o flag changes the name of this executable. If the -s flag is used, it will also keep the assembly output in the desired file name.

As an example `klumpile test.klump -o test -s output.asm` will compile the program located in `test.klump`. The generated assembly will be in `output.asm` and the executable will be named `test`.

To manually assemble and link a generated assembly file, use the following commands

`nasm -felf32 <assembly file> -o <object file name>`
`gcc -m32 <object file name> -o <executable name>`
