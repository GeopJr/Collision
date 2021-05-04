export const manifest = {
	appDir: "_app",
	assets: new Set(["favicons/android-chrome-192x192.png","favicons/android-chrome-512x512.png","favicons/apple-touch-icon.png","favicons/browserconfig.xml","favicons/favicon-16x16.png","favicons/favicon-32x32.png","favicons/favicon.ico","favicons/mstile-144x144.png","favicons/mstile-150x150.png","favicons/mstile-310x150.png","favicons/mstile-310x310.png","favicons/mstile-70x70.png","favicons/safari-pinned-tab.svg","favicons/site.webmanifest","headers/code-dark.png","headers/code-light.png","headers/web-dark.png","headers/web-light.png","logos/code.png","logos/collision.png","logos/error.png","logos/web.png","screenshots/code-dark.jpg","screenshots/code-light.jpg","screenshots/collision-dark.png","screenshots/collision-light.png","screenshots/error.png","screenshots/secondary-dark.jpg","screenshots/secondary-light.jpg","screenshots/web-dark.jpg","screenshots/web-light.jpg","wallpapers/adwaita-d.jpg","wallpapers/adwaita-l.jpg"]),
	_: {
		mime: {".png":"image/png",".xml":"application/xml",".ico":"image/vnd.microsoft.icon",".svg":"image/svg+xml",".webmanifest":"application/manifest+json",".jpg":"image/jpeg"},
		entry: {"file":"start-521db728.js","js":["start-521db728.js","chunks/vendor-a98ea335.js"],"css":[]},
		nodes: [
			() => import('./nodes/0.js'),
			() => import('./nodes/1.js'),
			() => import('./nodes/2.js'),
			() => import('./nodes/3.js'),
			() => import('./nodes/4.js')
		],
		routes: [
			{
				type: 'page',
				key: "",
				pattern: /^\/$/,
				params: null,
				path: "/",
				shadow: null,
				a: [0,2],
				b: [1]
			},
			{
				type: 'page',
				key: "install",
				pattern: /^\/install\/?$/,
				params: null,
				path: "/install",
				shadow: null,
				a: [0,3],
				b: [1]
			},
			{
				type: 'page',
				key: "code",
				pattern: /^\/code\/?$/,
				params: null,
				path: "/code",
				shadow: null,
				a: [0,4],
				b: [1]
			}
		]
	}
};
