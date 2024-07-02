import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

export default defineConfig({
  plugins: [svelte()],
  build: {
    rollupOptions: {
      input: {
        main: "main.jsx",
      },
      output: {
        entryFileNames: "bundle.js",
      },
    },
  },
});
