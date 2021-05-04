<script>
	import Searchbar from '$lib/Layout/searchbar.svelte';
	import Navbar from '$lib/Layout/navbar.svelte';
	import SpaceSwitcher from '$lib/Layout/space-switcher.svelte';
	import SecondWorkspace from '$lib/Layout/second-workspace.svelte';
	import Container from '$lib/Layout/container.svelte';
	import Dash from '$lib/Layout/dash.svelte';
	import { onMount } from 'svelte';
	import { darkMode } from '../stores';
	import { page } from '$app/stores';
	onMount(() => {
		darkMode.set(matchMedia('(prefers-color-scheme: dark)').matches);
	});

	let switcher = true;
	let rightWorkspace = false;

	$: path = $page.url.pathname === '/' ? 'Collision' : $page.url.pathname.slice(1);
	$: capitalizedPath = path.charAt(0).toUpperCase() + path.slice(1);
	$: searchText =
		capitalizedPath.length > 30 ? capitalizedPath.substring(0, 33) + '...' : capitalizedPath;
</script>

<Navbar bind:switcher />
<Searchbar bind:text={searchText} />
<SpaceSwitcher />
<Container bind:switcher>
	<slot />
</Container>
<SecondWorkspace {switcher} bind:right={rightWorkspace} />
<Dash {switcher} />

<style lang="scss">
	:global(html) {
		background-color: #282828;
		overflow: hidden;
		max-width: 100vw;
		max-height: 100vh;
	}
</style>
