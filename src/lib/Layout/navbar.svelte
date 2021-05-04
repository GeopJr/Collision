<script>
	export let switcher;

	import { onMount } from 'svelte';
	let date = new Date();

	$: clock = date.toLocaleString('en-US', {
		hour: 'numeric',
		hour12: true,
		minute: 'numeric'
	});

	$: month = date.toLocaleString('en-US', {
		month: 'short',
		day: 'numeric'
	});

	onMount(() => {
		setInterval(() => {
			date = new Date();
		}, 1000);
	});

	function handleKeyEvent(event) {
		if (event && event.key !== 'Enter' && event.key !== ' ') return;
		switcher = !switcher;
	}
</script>

<div class="c-navbar" class:switcher>
	<div
		tabIndex="0"
		class="c-nav-item"
		on:click={() => handleKeyEvent()}
		on:keydown={(e) => handleKeyEvent(e)}
		class:active={switcher}
	>
		Activities
	</div>
	<div class="c-nav-item">
		<div style="display:inline;margin-right:3px">{month}</div>
		{clock}
	</div>
	<a
		class="c-nav-item"
		tabIndex="0"
		target="_blank"
		rel="noreferrer"
		alt="Collision's GitHub repo"
		href="https://github.com/GeopJr/Collision">❤️ 🌟 🏴‍☠️</a
	>
</div>

<style lang="scss">
	.c-nav-item {
		font-weight: 700;
		padding: 0 12px;
		outline: 2px solid transparent;
		outline-offset: 2px;
		border-radius: 99px;
		transition-duration: 150ms;
		border: 3px solid transparent;
		text-decoration: none;
		&:hover,
		&:active,
		&:focus,
		&:visited,
		&.active {
			box-shadow: inset 0 0 0 100px rgba(255, 255, 255, 0.22);
			text-decoration: none;
		}
	}

	.c-navbar {
		background-color: #000000;
		height: 28px;
		z-index: 50;
		position: absolute;
		top: 0;
		right: 0;
		width: 100vw;
		display: flex;
		flex-wrap: nowrap;
		justify-content: space-between;
		justify-items: center;
		color: #ffffff;
		user-select: none;
		font-size: 0.875rem;
		line-height: 1.25rem;
		transition-duration: 200ms;
		&::before {
			content: '';
			position: absolute;

			transition-duration: 200ms;
			background-color: transparent;
			bottom: -50px;
			height: 50px;
			width: 100%;
			border-top-left-radius: 9px;
			border-top-right-radius: 9px;
			box-shadow: 0 -25px 0 0 #000000;
			z-index: -1;
		}
		&.switcher {
			background-color: transparent;
			&::before {
				content: '';
				transition-duration: 200ms;
				background-color: transparent;
				box-shadow: none;
				bottom: -20px;
				height: 20px;
			}
		}
	}
</style>
