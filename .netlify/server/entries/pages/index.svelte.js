import { c as create_ssr_component, a as subscribe, v as validate_component } from "../../chunks/index-0ec74a11.js";
import { d as darkMode } from "../../chunks/stores-50073149.js";
import { P as Page_transitions } from "../../chunks/page-transitions-8d078565.js";
var index_svelte_svelte_type_style_lang = "";
const css = {
  code: ".c-window.svelte-1wyn4gj>.c-screenshot.svelte-1wyn4gj{transition-duration:200ms}.switcher>#transition>.c-window.svelte-1wyn4gj>.svelte-1wyn4gj{pointer-events:none}.switcher>#transition>.c-window.svelte-1wyn4gj>.c-icon.svelte-1wyn4gj{display:block;transform:scale(1, 1);transition-duration:200ms}.switcher>#transition>.c-window.svelte-1wyn4gj:hover>.c-screenshot.svelte-1wyn4gj{transition-duration:200ms;transform:scale(1.05, 1.05)}.switcher>#transition>.c-window.svelte-1wyn4gj:hover>.c-icon.svelte-1wyn4gj{bottom:175px}.c-window.svelte-1wyn4gj>.c-icon.svelte-1wyn4gj{bottom:190px;transition-duration:200ms;position:fixed;transform:scale(0, 0);width:128px;filter:drop-shadow(0px 0px 1px #222)}.c-window.svelte-1wyn4gj.svelte-1wyn4gj{display:flex;align-items:center;justify-content:center}",
  map: null
};
const Routes = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $darkMode, $$unsubscribe_darkMode;
  $$unsubscribe_darkMode = subscribe(darkMode, (value) => $darkMode = value);
  $$result.css.add(css);
  $$unsubscribe_darkMode();
  return `${validate_component(Page_transitions, "PageTransitions").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="${"c-window svelte-1wyn4gj"}">${$darkMode ? `<img draggable="${"false"}" alt="${"Collision Screenshot"}" class="${"c-screenshot svelte-1wyn4gj"}" src="${"/screenshots/collision-dark.png"}">` : `<img draggable="${"false"}" alt="${"Collision Screenshot"}" class="${"c-screenshot svelte-1wyn4gj"}" src="${"/screenshots/collision-light.png"}">`}
		<img draggable="${"false"}" alt="${"Collision Icon"}" class="${"c-icon svelte-1wyn4gj"}" src="${"/logos/collision.png"}"></div>`;
    }
  })}`;
});
export { Routes as default };
