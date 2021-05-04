<script>
	export let switcher;

	import { darkMode } from '../../stores';

	function handleKeyEvent(event) {
		if (event && event.key !== 'Enter' && event.key !== ' ') return;
		switcher = false;
	}
</script>

<main
	tabindex="0"
	class="c-container"
	class:switcher
	on:click={() => handleKeyEvent()}
	on:keydown={(e) => handleKeyEvent(e)}
	style={`background-image: url('/wallpapers/adwaita-${$darkMode ? 'd' : 'l'}.jpg')`}
>
	<slot />
</main>

<style lang="scss">
	.c-container {
		top: 28px;
		position: absolute;
		width: 100vw;
		height: calc(100vh - 28px);
		background-size: cover;
		background-position: center center;
		transition-duration: 200ms;
		display: flex;
		align-items: center;
		justify-content: center;
		&:focus {
			outline: 3px solid #2185ff;
		}
		&.switcher {
			transform: scale(0.7, 0.7);
			border-radius: 30px;
			filter: drop-shadow(0px 0px 15px #222);
			@media only screen and (max-device-width: 768px) {
				transform: scale(0.6, 0.6);
				top: 0;
			}
		}
	}
</style>
