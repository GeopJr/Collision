<script>
	import Window from '$lib/Routes/app-window.svelte';
	import PageTransitions from '$lib/page-transitions.svelte';
</script>

<svelte:head>
	<title>Collision - Install</title>
	<meta name="og:title" content="Collision - Install" />
</svelte:head>

<PageTransitions>
	<Window
		title={'Flathub - Collision'}
		url={'https://flathub.org/apps/details/dev.geopjr.Collision'}
		type={'web'}
	/>
</PageTransitions>
