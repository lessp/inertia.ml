# Inertia.ml - Inertia.js for OCaml

A simple library to help you build Inertia.js applications with OCaml.

# Usage

1. Creating a root view
   Before being able to render with Inertia, you need to create a root view. This is a simple function that takes a page object and returns a string. How you do this is up to you, but here is an example using Dream + Dream templates:

```ocaml
(* root_template.eml.ml *)
let render page_object =
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My OCaml + Inertia App</title>
  </head>
  <body>
  <div id="app" data-page='<%s page_object %>'></div>
    <script type="module" src="/assets/bundle.js"></script>
  </body>
</html>
```

```ocaml
(* app.ml *)
Inertia.set_root_view (fun (p: Inertia.Page_object.t) ->
  Root_template.render (Inertia.Page_object.serialize p))
```

2. Calling Inertia

Now you can call Inertia to render your page. Here is an example:

```ocaml
(* app.ml *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun request ->
           Inertia.render ~request ~component:"Welcome" ~props:[])
       ; Dream.get "/assets/**" (Dream.static ~loader:asset_loader "")
       ]
;;
```

See [example](example) for a full example.

# TODO

- [x] Custom root view
- [x] Full template render with passed page object
- [x] "Inertia" render i.e. sending only the data and let the client handle the rendering
- [] Versioning
- [] Partial reloads
- [] Allow other web frameworks to be used (currently coupled with Dream)
