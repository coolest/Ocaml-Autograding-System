#!/bin/bash

# Update and install OPAM
apt-get update && apt-get install -y opam

# Initialize OPAM
opam init --disable-sandboxing --yes

# Set up OPAM environment
eval $(opam env)

# Install OCaml, Dune, and Yojson
opam install ocaml dune yojson --yes

# Create a Dune project file
cat << EOF > /autograder/source/dune-project
(lang dune 2.9)
(name autograder)
(package
 (name autograder)
 (depends yojson))
EOF

# 2 Executables:
#   1) check_hw_definitions,    this ensures the hw submission has expected definitions for the autograder to use
#   2) autograder,              this performs the actual autograding
cat << EOF > /autograder/source/dune
(library
 (name hw2types)
 (modules hw2types)
 (flags (:standard -w -a)))

(library
 (name hw2)
 (modules hw2)
 (libraries hw2types)
 (flags (:standard -w -a)))

(library
 (name solution)
 (modules solution)
 (libraries hw2 hw2types)
 (flags (:standard -w -a)))

(library
 (name generator)
 (modules generator)
 (libraries hw2types)
 (flags (:standard -w -a)))

(library
 (name definitions)
 (modules definitions)
 (libraries solution hw2 hw2types generator)
 (flags (:standard -w -a)))

(library
 (name config)
 (modules config)
 (libraries yojson)
 (flags (:standard -w -a)))

(executable
 (name autograder)
 (modules autograder)
 (libraries yojson definitions config)
 (flags (:standard -w -a)))

(executable
 (name check_hw_definitions)
 (modules check_hw_definitions)
 (libraries hw2 hw2types)
 (flags (:standard -w -a)))
EOF

# Ensure OPAM environment is loaded in .bashrc
echo 'eval $(opam env)' >> ~/.bashrc

# Get JQ so easy error handling in bash
apt-get install -y jq