> WIP, API will most definitely change!

# Inertia.ml - Inertia.js for OCaml

A simple library to help you build [Inertia.js](https://inertiajs.com/) applications with OCaml.

# TODO

- [x] Custom root view
- [x] Full template render with passed page object
- [x] "Inertia" render i.e. sending only the data and let the client handle the rendering
- [-] Versioning - untested
- [ ] Partial reloads
- [ ] Allow other web frameworks to be used (currently coupled with Dream)

# Usage

1. Creating a root view

Before being able to render with Inertia, you need to create a root view. This is a simple function that takes a page object and returns a string. How you do this is up to you, but in the simplest case you can use a string template.

```ocaml
(* app.ml *)
Inertia.set_root_view (fun page_object -> Printf.sprintf {|
<!DOCTYPE html>
<html>
<head>
    <title>My App</title>
</head>
<body>
    <div id="app" data-page='%s'></div>
    <script type="module" src="/assets/bundle.js"></script>
</body>
</html>
|} (Inertia.PO.serialize page_object))
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
           Inertia.render ~request ~component:"Welcome" ~props:[]
        )
       ; Dream.get "/assets/**" (Dream.static ~loader:asset_loader "")
       ]
;;
```

See [example](./example) for a full example.
