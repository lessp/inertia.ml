import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob("./pages/**/*.jsx", { eager: true });
    console.log("Pages", pages);
    console.log("Name", name);
    const returnedPage = pages[`./pages/${name}.jsx`];
    console.log("Returned Page", returnedPage);
    return returnedPage;
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />);
  },
});
