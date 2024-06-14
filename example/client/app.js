import { createApp, h } from "vue";
// import { createInertiaApp } from "@inertiajs/vue3";

// console.log("app.js");

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob("./Pages/**/*.vue", { eager: true });
    return pages[`./Pages/${name}.vue`];
  },
  title: (title) => (title ? `${title} - Ping CRM` : "Ping CRM"),
  setup({ el, App, props, plugin }) {
    console.log("app.js setup");
    createApp({ render: () => h(App, props) })
      .use(plugin)
      .mount(el);
  },
});
