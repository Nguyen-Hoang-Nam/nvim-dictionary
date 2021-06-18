# Nvim-Dictionary

📖 Find definition of words in nvim

![Main](https://raw.githubusercontent.com/Nguyen-Hoang-Nam/readme-image/main/nvim-dictionary.png)

## Usage

Firstly, mapping ```get_dictionary()``` function in visual mode.

```lua
vim.api.nvim_set_keymap('v', '<M-d>', [[<Cmd>lua require('nvim-dictionary').get_dictionary()<CR>]], options)
```

Then, change mode to visual, select word, and press keys to call function

## Setup

```lua
local dictionary = require('nvim-dictionary')

dictionary.setup({
	part_of_speech = '#5AF78E',
	phonetic = '#57C7FF',
})
```

## TODO

- [ ] Support normal mode
- [ ] Cache
- [ ] Strictly validate word
- [ ] Mapping in config
- [ ] Float window

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Credit

This project uses free dictionary API from [freeDictionaryAPI](https://github.com/meetDeveloper/freeDictionaryAPI). You can support them by donating.
