<script>
	export let text;
</script>

<div class="c-searchbar">{text}</div>

<style lang="scss">
	.c-searchbar {
		width: 320px;
		height: 36px;
		position: relative;
		top: 47px;
		left: 0;
		right: 0;
		margin-left: auto;
		margin-right: auto;
		border-radius: 18px;
		color: #b5b5b4;
		background-color: #353535;
		padding: 7px 9px;
		border: 1px solid #202020;
		padding-left: 15px;
		&:hover {
			background-color: #424242;
		}
	}
</style>
