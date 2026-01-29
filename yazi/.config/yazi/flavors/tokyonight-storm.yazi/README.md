<div align="center">
  <img src="https://github.com/sxyazi/yazi/blob/main/assets/logo.png?raw=true" alt="Yazi logo" width="20%">
</div>

<h3 align="center">
    	<a href="https://github.com/folke/tokyonight.nvim">tokyonight.nvim</a> theme for yazi
</h3>

## Preview

<img src="preview_storm.png" width="300" />

## Installation

```sh
ya pkg add ojas-bhagavath/tokyonight:tokyonight-storm
```

## Usage
Add this to `~/.config/yazi/themes.toml` (on UNIX-like systems) or `%AppData%\yazi\config\themes.toml` on Windows:
```toml
[flavor]
dark = "tokyonight-storm"
```

Make sure your `theme.toml` doesn't contain anything other than `[flavor]`, unless you want to override certain styles of this flavor.

See the [Yazi flavor documentation](https://yazi-rs.github.io/docs/flavors/overview) for more details.

## License

Check the [LICENSE](LICENSE) and [LICENSE-tmtheme](LICENSE-tmtheme) file for more details.

## Credits

This flavor is an exact copy of theme files in the extras section of [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim). This repo only exists because the yazi package manager `ya` does not support downloading packages that are deeply nested in a repository. Once support for that is added, I will submit a PR to include these flavors in [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim).
