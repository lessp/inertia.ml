import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
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
