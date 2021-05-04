import { c as create_ssr_component, a as subscribe, b as add_attribute, e as escape } from "./index-0ec74a11.js";
import { d as darkMode } from "./stores-50073149.js";
var appWindow_svelte_svelte_type_style_lang = "";
const css = {
  code: ".switcher>#transition>.c-app-window.svelte-lswyss>.window.svelte-lswyss>.svelte-lswyss{pointer-events:none}.switcher>#transition>.c-app-window.svelte-lswyss>.c-icon.svelte-lswyss.svelte-lswyss{display:block;transform:scale(1, 1);transition-duration:200ms}.switcher>#transition>.c-app-window.svelte-lswyss:hover>.window.svelte-lswyss.svelte-lswyss{transition-duration:200ms;transform:scale(1.05, 1.05)}.switcher>#transition>.c-app-window.svelte-lswyss:hover>.c-icon.svelte-lswyss.svelte-lswyss{bottom:5px}.c-app-window.svelte-lswyss>.c-icon.svelte-lswyss.svelte-lswyss{bottom:20px;transition-duration:200ms;position:fixed;transform:scale(0, 0);width:128px;filter:drop-shadow(0px 0px 1px #222)}.c-app-window.svelte-lswyss.svelte-lswyss.svelte-lswyss{display:flex;align-items:center;justify-content:center}.window.svelte-lswyss.svelte-lswyss.svelte-lswyss{filter:drop-shadow(0px 0px 1px #000);transition-duration:200ms}.header.svelte-lswyss.svelte-lswyss.svelte-lswyss{width:60vw;position:relative}@media only screen and (max-device-width: 768px){.header.svelte-lswyss.svelte-lswyss.svelte-lswyss{width:100vw}}iframe.svelte-lswyss.svelte-lswyss.svelte-lswyss{width:60vw;height:80vh;border:1px solid #dfdcd9;border-top-width:0px}@media only screen and (max-device-width: 768px){iframe.svelte-lswyss.svelte-lswyss.svelte-lswyss{width:100vw;height:90vh}}",
  map: null
};
const App_window = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let header;
  let borderColor;
  let $darkMode, $$unsubscribe_darkMode;
  $$unsubscribe_darkMode = subscribe(darkMode, (value) => $darkMode = value);
  let { type } = $$props;
  let { url } = $$props;
  let { title } = $$props;
  let headerImage = type.toLowerCase();
  if ($$props.type === void 0 && $$bindings.type && type !== void 0)
    $$bindings.type(type);
  if ($$props.url === void 0 && $$bindings.url && url !== void 0)
    $$bindings.url(url);
  if ($$props.title === void 0 && $$bindings.title && title !== void 0)
    $$bindings.title(title);
  $$result.css.add(css);
  header = $darkMode ? `/headers/${headerImage}-dark.png` : `/headers/${headerImage}-light.png`;
  borderColor = $darkMode ? "#292929" : "#dfdcd9";
  $$unsubscribe_darkMode();
  return `<div class="${"c-app-window svelte-lswyss"}"><div class="${"window svelte-lswyss"}"><img draggable="${"false"}" alt="${""}" role="${"presentation"}" class="${"header svelte-lswyss"}"${add_attribute("src", header, 0)}>
		<iframe${add_attribute("src", url, 0)} allowtransparency="${"true"}"${add_attribute("title", title, 0)} referrerpolicy="${"no-referrer"}" sandbox="${"allow-scripts allow-downloads allow-modals allow-popups allow-popups-to-escape-sandbox allow-same-origin"}"${add_attribute("style", `border-color: ${borderColor}; background-color: ${borderColor}`, 0)} class="${"svelte-lswyss"}">Your browser does not support inline frames. This iframe would link to
			${escape(url)}.</iframe></div>
	<img draggable="${"false"}"${add_attribute("alt", type.toLowerCase() + " icon", 0)} class="${"c-icon svelte-lswyss"}"${add_attribute("src", `/logos/${type.toLowerCase()}.png`, 0)}>
</div>`;
});
export { App_window as A };
