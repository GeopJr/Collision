import { c as create_ssr_component, v as validate_component, e as escape } from "../../chunks/index-0ec74a11.js";
import { P as Page_transitions } from "../../chunks/page-transitions-8d078565.js";
var __error_svelte_svelte_type_style_lang = "";
const css = {
  code: ".c-window.svelte-b4g4gu>.c-screenshot.svelte-b4g4gu{transition-duration:200ms}.switcher>#transition>.c-window.svelte-b4g4gu>.svelte-b4g4gu{pointer-events:none}.switcher>#transition>.c-window.svelte-b4g4gu>.c-icon.svelte-b4g4gu{display:block;transform:scale(1, 1);transition-duration:200ms}.switcher>#transition>.c-window.svelte-b4g4gu:hover>.c-error.svelte-b4g4gu{transition-duration:200ms;transform:scale(1.1, 1.1)}.switcher>#transition>.c-window.svelte-b4g4gu:hover>.c-screenshot.svelte-b4g4gu{transition-duration:200ms;transform:scale(1.05, 1.05)}.switcher>#transition>.c-window.svelte-b4g4gu:hover>.c-icon.svelte-b4g4gu{bottom:0px}@media only screen and (max-device-width: 768px){.switcher>#transition>.c-window.svelte-b4g4gu:hover>.c-icon.svelte-b4g4gu{bottom:200px}}.c-window.svelte-b4g4gu>.c-icon.svelte-b4g4gu{bottom:15px;transition-duration:200ms;position:fixed;transform:scale(0, 0);width:128px;filter:drop-shadow(0px 0px 1px #222)}@media only screen and (max-device-width: 768px){.c-window.svelte-b4g4gu>.c-icon.svelte-b4g4gu{bottom:215px}}.c-window.svelte-b4g4gu.svelte-b4g4gu{display:flex;align-items:center;justify-content:center}.c-error.svelte-b4g4gu.svelte-b4g4gu{position:absolute;font-weight:bold;font-size:5vw;transition-duration:200ms;z-index:55;background-color:black;color:white;padding:0 30px;white-space:nowrap;transform:rotate(-5deg)}",
  map: null
};
function load({ error, status }) {
  return {
    props: { title: `${status}: ${error.message}` }
  };
}
const _error = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let error;
  let { title } = $$props;
  console.log(title);
  if ($$props.title === void 0 && $$bindings.title && title !== void 0)
    $$bindings.title(title);
  $$result.css.add(css);
  error = title.length > 30 ? title.substring(0, 33) + "..." : title;
  return `${$$result.head += `${$$result.title = `<title>Collision - Error</title>`, ""}<meta name="${"og:title"}" content="${"Collision - Error"}" data-svelte="svelte-1wliczd">`, ""}

${validate_component(Page_transitions, "PageTransitions").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="${"c-window svelte-b4g4gu"}"><h1 class="${"c-error svelte-b4g4gu"}">${escape(error)}</h1>
		<img draggable="${"false"}" alt="${"Eye of GNOME screenshot"}" class="${"c-screenshot svelte-b4g4gu"}" src="${"/screenshots/error.png"}">
		<img draggable="${"false"}" alt="${"Eye of GNOME icon"}" class="${"c-icon svelte-b4g4gu"}" src="${"/logos/error.png"}"></div>`;
    }
  })}`;
});
export { _error as default, load };
