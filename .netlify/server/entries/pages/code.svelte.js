import { c as create_ssr_component, v as validate_component } from "../../chunks/index-0ec74a11.js";
import { A as App_window } from "../../chunks/app-window-5936bdaa.js";
import { P as Page_transitions } from "../../chunks/page-transitions-8d078565.js";
import "../../chunks/stores-50073149.js";
const Code = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${$$result.head += `${$$result.title = `<title>Collision - Code</title>`, ""}<meta name="${"og:title"}" content="${"Collision - Code"}" data-svelte="svelte-1ld1a3j">`, ""}

${validate_component(Page_transitions, "PageTransitions").$$render($$result, {}, {}, {
    default: () => {
      return `${validate_component(App_window, "Window").$$render($$result, {
        title: "github1s - Collision",
        url: "https://github1s.com/GeopJr/Collision",
        type: "code"
      }, {}, {})}`;
    }
  })}`;
});
export { Code as default };
