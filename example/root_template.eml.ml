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
