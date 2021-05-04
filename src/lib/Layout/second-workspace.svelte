<script>
	export let switcher;
	export let right;

	import { darkMode } from '../../stores';
</script>

<div class="c-second-workspace" class:switcher class:right style={`background-image: url('/wallpapers/adwaita-${$darkMode ? "d" : "l"}.jpg')`}/>

<style lang="scss">
	.c-second-workspace {
		display: block;
		top: 28px;
		right: -110vw;
		position: fixed;
		width: 100vw;
		height: calc(100vh - 28px);
		background-size: cover;
		background-position: center center;
		transition-duration: 200ms;
		z-index: -50;
		&.right {
			left: -110vw;
		}
		&.switcher {
			&.right {
				left: -75vw;
			}
			right: -75vw;
			transform: scale(0.65, 0.65);
			border-radius: 30px;
			filter: drop-shadow(0px 0px 15px #222);
			@media only screen and (max-device-width: 768px) {
				transform: scale(0.55, 0.55);
				top: 0;
				&.right {
					left: -65vw;
				}
				right: -65vw;
			}
		}
	}
</style>
