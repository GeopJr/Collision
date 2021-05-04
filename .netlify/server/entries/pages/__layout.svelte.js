import { c as create_ssr_component, e as escape, g as getContext, a as subscribe, b as add_attribute, v as validate_component } from "../../chunks/index-0ec74a11.js";
import { d as darkMode } from "../../chunks/stores-50073149.js";
var searchbar_svelte_svelte_type_style_lang = "";
const css$6 = {
  code: ".c-searchbar.svelte-fd5539{width:320px;height:36px;position:relative;top:47px;left:0;right:0;margin-left:auto;margin-right:auto;border-radius:18px;color:#b5b5b4;background-color:#353535;padding:7px 9px;border:1px solid #202020;padding-left:15px}.c-searchbar.svelte-fd5539:hover{background-color:#424242}",
  map: null
};
const Searchbar = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { text } = $$props;
  if ($$props.text === void 0 && $$bindings.text && text !== void 0)
    $$bindings.text(text);
  $$result.css.add(css$6);
  return `<div class="${"c-searchbar svelte-fd5539"}">${escape(text)}</div>`;
});
var navbar_svelte_svelte_type_style_lang = "";
const css$5 = {
  code: '.c-nav-item.svelte-1w5c8y3{font-weight:700;padding:0 12px;outline:2px solid transparent;outline-offset:2px;border-radius:99px;transition-duration:150ms;border:3px solid transparent;text-decoration:none}.c-nav-item.svelte-1w5c8y3:hover,.c-nav-item.svelte-1w5c8y3:active,.c-nav-item.svelte-1w5c8y3:focus,.c-nav-item.svelte-1w5c8y3:visited,.c-nav-item.active.svelte-1w5c8y3{box-shadow:inset 0 0 0 100px rgba(255, 255, 255, 0.22);text-decoration:none}.c-navbar.svelte-1w5c8y3{background-color:#000000;height:28px;z-index:50;position:absolute;top:0;right:0;width:100vw;display:flex;flex-wrap:nowrap;justify-content:space-between;justify-items:center;color:#ffffff;user-select:none;font-size:0.875rem;line-height:1.25rem;transition-duration:200ms}.c-navbar.svelte-1w5c8y3::before{content:"";position:absolute;transition-duration:200ms;background-color:transparent;bottom:-50px;height:50px;width:100%;border-top-left-radius:9px;border-top-right-radius:9px;box-shadow:0 -25px 0 0 #000000;z-index:-1}.c-navbar.switcher.svelte-1w5c8y3{background-color:transparent}.c-navbar.switcher.svelte-1w5c8y3::before{content:"";transition-duration:200ms;background-color:transparent;box-shadow:none;bottom:-20px;height:20px}',
  map: null
};
const Navbar = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let clock;
  let month;
  let { switcher } = $$props;
  let date = new Date();
  if ($$props.switcher === void 0 && $$bindings.switcher && switcher !== void 0)
    $$bindings.switcher(switcher);
  $$result.css.add(css$5);
  clock = date.toLocaleString("en-US", {
    hour: "numeric",
    hour12: true,
    minute: "numeric"
  });
  month = date.toLocaleString("en-US", { month: "short", day: "numeric" });
  return `<div class="${["c-navbar svelte-1w5c8y3", switcher ? "switcher" : ""].join(" ").trim()}"><div tabindex="${"0"}" class="${["c-nav-item svelte-1w5c8y3", switcher ? "active" : ""].join(" ").trim()}">Activities
	</div>
	<div class="${"c-nav-item svelte-1w5c8y3"}"><div style="${"display:inline;margin-right:3px"}">${escape(month)}</div>
		${escape(clock)}</div>
	<a class="${"c-nav-item svelte-1w5c8y3"}" tabindex="${"0"}" target="${"_blank"}" rel="${"noreferrer"}" alt="${"Collision's GitHub repo"}" href="${"https://github.com/GeopJr/Collision"}">\u2764\uFE0F \u{1F31F} \u{1F3F4}\u200D\u2620\uFE0F</a>
</div>`;
});
const getStores = () => {
  const stores = getContext("__svelte__");
  return {
    page: {
      subscribe: stores.page.subscribe
    },
    navigating: {
      subscribe: stores.navigating.subscribe
    },
    get preloading() {
      console.error("stores.preloading is deprecated; use stores.navigating instead");
      return {
        subscribe: stores.navigating.subscribe
      };
    },
    session: stores.session,
    updated: stores.updated
  };
};
const page = {
  subscribe(fn) {
    const store = getStores().page;
    return store.subscribe(fn);
  }
};
var spaceSwitcher_svelte_svelte_type_style_lang = "";
const css$4 = {
  code: ".c-space-switcher.svelte-ntjwhf.svelte-ntjwhf{position:absolute;top:103px;left:50%;transform:translate(-50%, 0);z-index:-50;display:inline-flex;align-items:center;justify-content:space-between;width:230px}.c-space-switcher.svelte-ntjwhf>.c-space-item.svelte-ntjwhf{display:flex;align-items:center;justify-content:center;position:relative;width:73px;background-color:#3b3b3b;height:40px;border-radius:3px}.c-space-switcher.svelte-ntjwhf>.c-space-item .c-workspace-screenshot.svelte-ntjwhf{width:60%}.c-space-switcher.svelte-ntjwhf>.c-space-item.active.svelte-ntjwhf{outline:2px solid #3584e4;border:1px solid #3584e4}",
  map: null
};
const Space_switcher = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let type;
  let screenshot;
  let secondary;
  let $darkMode, $$unsubscribe_darkMode;
  let $page, $$unsubscribe_page;
  $$unsubscribe_darkMode = subscribe(darkMode, (value) => $darkMode = value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  const screenshots = {
    "/": "collision",
    "/install": "web",
    "/code": "code"
  };
  let pngs = ["collision", "error"];
  $$result.css.add(css$4);
  type = screenshots[$page.url.pathname.toLowerCase()] ?? "error";
  screenshot = type === "error" ? "/screenshots/error.png" : `/screenshots/${type}-${$darkMode ? "dark" : "light"}.${pngs.includes(type) ? "png" : "jpg"}`;
  secondary = `/screenshots/secondary-${$darkMode ? "dark" : "light"}.jpg`;
  $$unsubscribe_darkMode();
  $$unsubscribe_page();
  return `<div class="${"c-space-switcher svelte-ntjwhf"}"><div class="${"c-space-item active svelte-ntjwhf"}"><img draggable="${"false"}" role="${"presentation"}" alt="${""}" class="${"c-workspace-screenshot svelte-ntjwhf"}"${add_attribute("src", screenshot, 0)}></div>
	<div class="${"c-space-item svelte-ntjwhf"}"><img draggable="${"false"}" role="${"presentation"}" alt="${""}" class="${"c-workspace-screenshot svelte-ntjwhf"}"${add_attribute("src", secondary, 0)}></div>
	<div class="${"c-space-item svelte-ntjwhf"}"></div>
</div>`;
});
var secondWorkspace_svelte_svelte_type_style_lang = "";
const css$3 = {
  code: ".c-second-workspace.svelte-1b5avvc{display:block;top:28px;right:-110vw;position:fixed;width:100vw;height:calc(100vh - 28px);background-size:cover;background-position:center center;transition-duration:200ms;z-index:-50}.c-second-workspace.right.svelte-1b5avvc{left:-110vw}.c-second-workspace.switcher.svelte-1b5avvc{right:-75vw;transform:scale(0.65, 0.65);border-radius:30px;filter:drop-shadow(0px 0px 15px #222)}.c-second-workspace.switcher.right.svelte-1b5avvc{left:-75vw}@media only screen and (max-device-width: 768px){.c-second-workspace.switcher.svelte-1b5avvc{transform:scale(0.55, 0.55);top:0;right:-65vw}.c-second-workspace.switcher.right.svelte-1b5avvc{left:-65vw}}",
  map: null
};
const Second_workspace = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $darkMode, $$unsubscribe_darkMode;
  $$unsubscribe_darkMode = subscribe(darkMode, (value) => $darkMode = value);
  let { switcher } = $$props;
  let { right } = $$props;
  if ($$props.switcher === void 0 && $$bindings.switcher && switcher !== void 0)
    $$bindings.switcher(switcher);
  if ($$props.right === void 0 && $$bindings.right && right !== void 0)
    $$bindings.right(right);
  $$result.css.add(css$3);
  $$unsubscribe_darkMode();
  return `<div class="${[
    "c-second-workspace svelte-1b5avvc",
    (switcher ? "switcher" : "") + " " + (right ? "right" : "")
  ].join(" ").trim()}"${add_attribute("style", `background-image: url('/wallpapers/adwaita-${$darkMode ? "d" : "l"}.jpg')`, 0)}></div>`;
});
var container_svelte_svelte_type_style_lang = "";
const css$2 = {
  code: ".c-container.svelte-g8dydu{top:28px;position:absolute;width:100vw;height:calc(100vh - 28px);background-size:cover;background-position:center center;transition-duration:200ms;display:flex;align-items:center;justify-content:center}.c-container.svelte-g8dydu:focus{outline:3px solid #2185ff}.c-container.switcher.svelte-g8dydu{transform:scale(0.7, 0.7);border-radius:30px;filter:drop-shadow(0px 0px 15px #222)}@media only screen and (max-device-width: 768px){.c-container.switcher.svelte-g8dydu{transform:scale(0.6, 0.6);top:0}}",
  map: null
};
const Container = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $darkMode, $$unsubscribe_darkMode;
  $$unsubscribe_darkMode = subscribe(darkMode, (value) => $darkMode = value);
  let { switcher } = $$props;
  if ($$props.switcher === void 0 && $$bindings.switcher && switcher !== void 0)
    $$bindings.switcher(switcher);
  $$result.css.add(css$2);
  $$unsubscribe_darkMode();
  return `<main tabindex="${"0"}" class="${["c-container svelte-g8dydu", switcher ? "switcher" : ""].join(" ").trim()}"${add_attribute("style", `background-image: url('/wallpapers/adwaita-${$darkMode ? "d" : "l"}.jpg')`, 0)}>${slots.default ? slots.default({}) : ``}
</main>`;
});
var dash_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: '.c-dash.svelte-9gmrin.svelte-9gmrin.svelte-9gmrin{background-color:#3b3b3b;height:98px;position:absolute;bottom:0;padding:10px;margin-bottom:16px;margin-top:12px;border-radius:24px;width:60vw;left:0;right:0;margin-left:auto;margin-right:auto;z-index:-50;display:flex;justify-content:space-between}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin.svelte-9gmrin{transition-duration:75ms;padding:4px 5px 1px;align-self:center}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin.svelte-9gmrin:focus{background-color:#232323;border-radius:12px}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin>.c-tooltip.svelte-9gmrin{transition-duration:75ms;position:fixed;opacity:0%;bottom:110px;transform:translate(-20%, 0);text-align:center;color:white;background-color:#010101b2;border-radius:99px;padding:3px 12px;pointer-events:none}@media only screen and (max-device-width: 768px){.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin>.c-tooltip.svelte-9gmrin{display:none}}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin>img.svelte-9gmrin{width:70px}.c-dash.svelte-9gmrin>.c-dash-item.active.svelte-9gmrin.svelte-9gmrin::after{content:"";position:relative;padding:3px;background-color:#eeeeee;border-radius:100%;left:calc(50% - 3px);height:3px;width:3px;display:block}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin.svelte-9gmrin:not(.active)::after{content:"";position:relative;padding:3px;height:3px;width:3px;display:block}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin.svelte-9gmrin:hover{background-color:#4e4e4e;border-radius:12px;transition-duration:75ms}.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin:hover>.c-tooltip.svelte-9gmrin{opacity:100%;transition-duration:700ms;display:block}@media only screen and (max-device-width: 768px){.c-dash.svelte-9gmrin>.c-dash-item.svelte-9gmrin:hover>.c-tooltip.svelte-9gmrin{display:none}}',
  map: null
};
const Dash = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let shouldTab;
  let currentPage;
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let { switcher } = $$props;
  if ($$props.switcher === void 0 && $$bindings.switcher && switcher !== void 0)
    $$bindings.switcher(switcher);
  $$result.css.add(css$1);
  shouldTab = switcher ? "0" : "-1";
  currentPage = $page.url.pathname.toLowerCase();
  $$unsubscribe_page();
  return `<div class="${"c-dash svelte-9gmrin"}"><a${add_attribute("tabindex", shouldTab, 0)} class="${["c-dash-item svelte-9gmrin", currentPage === "/" ? "active" : ""].join(" ").trim()}" sveltekit:prefetch href="${"/"}" alt="${"Home"}"><img draggable="${"false"}" alt="${"Collision icon"}" src="${"/logos/collision.png"}" class="${"svelte-9gmrin"}">
		<span class="${"c-tooltip svelte-9gmrin"}">Collision</span></a>
	<a${add_attribute("tabindex", shouldTab, 0)} class="${["c-dash-item svelte-9gmrin", currentPage === "/install" ? "active" : ""].join(" ").trim()}" sveltekit:prefetch href="${"/install"}" alt="${"Collision's flathub page"}"><img draggable="${"false"}" alt="${"GNOME Web icon"}" src="${"/logos/web.png"}" class="${"svelte-9gmrin"}">
		<span class="${"c-tooltip svelte-9gmrin"}">Web - Install</span></a>
	<a${add_attribute("tabindex", shouldTab, 0)} class="${["c-dash-item svelte-9gmrin", currentPage === "/code" ? "active" : ""].join(" ").trim()}" sveltekit:prefetch href="${"/code"}" alt="${"Collision's code using github1s.com"}"><img draggable="${"false"}" alt="${"VSCodium icon"}" src="${"/logos/code.png"}" class="${"svelte-9gmrin"}">
		<span class="${"c-tooltip svelte-9gmrin"}">Code - Source</span></a>
</div>`;
});
var __layout_svelte_svelte_type_style_lang = "";
const css = {
  code: "html{background-color:#282828;overflow:hidden;max-width:100vw;max-height:100vh}",
  map: null
};
const _layout = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let path;
  let capitalizedPath;
  let searchText;
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let switcher = true;
  let rightWorkspace = false;
  $$result.css.add(css);
  let $$settled;
  let $$rendered;
  do {
    $$settled = true;
    path = $page.url.pathname === "/" ? "Collision" : $page.url.pathname.slice(1);
    capitalizedPath = path.charAt(0).toUpperCase() + path.slice(1);
    searchText = capitalizedPath.length > 30 ? capitalizedPath.substring(0, 33) + "..." : capitalizedPath;
    $$rendered = `${validate_component(Navbar, "Navbar").$$render($$result, { switcher }, {
      switcher: ($$value) => {
        switcher = $$value;
        $$settled = false;
      }
    }, {})}
${validate_component(Searchbar, "Searchbar").$$render($$result, { text: searchText }, {
      text: ($$value) => {
        searchText = $$value;
        $$settled = false;
      }
    }, {})}
${validate_component(Space_switcher, "SpaceSwitcher").$$render($$result, {}, {}, {})}
${validate_component(Container, "Container").$$render($$result, { switcher }, {
      switcher: ($$value) => {
        switcher = $$value;
        $$settled = false;
      }
    }, {
      default: () => {
        return `${slots.default ? slots.default({}) : ``}`;
      }
    })}
${validate_component(Second_workspace, "SecondWorkspace").$$render($$result, { switcher, right: rightWorkspace }, {
      right: ($$value) => {
        rightWorkspace = $$value;
        $$settled = false;
      }
    }, {})}
${validate_component(Dash, "Dash").$$render($$result, { switcher }, {}, {})}`;
  } while (!$$settled);
  $$unsubscribe_page();
  return $$rendered;
});
export { _layout as default };
