(lang dune 3.15)
(name inertia_ml)
(generate_opam_files true)
(source
 (github lessp/inertia.ml))
(authors "lessp")
(maintainers "lessp")
(license LICENSE)
(documentation https://github.com/lessp/inertia.ml)

(package
 (name inertia_ml)
 (synopsis "Inertia.js adapter for OCaml")
 (description "Inertia.js adapter for OCaml")
 (depends 
   ocaml 
   dune

   dream
   yojson)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
