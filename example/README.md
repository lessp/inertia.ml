## Inertia + OCaml Example

This is an example using Inertia.ml with Dream (server side) and Svelte (client
side).

## Getting started

```
# Install JS dependencies
cd js
bun install
bun run build

# Install OCaml dependencies
cd ..
dune b && dune exec ./main.exe
```

Assets are bundled with `dune` from `js/dist` folder. See [`asset_loader`](./app.ml).
