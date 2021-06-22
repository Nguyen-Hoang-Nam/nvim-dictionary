local curl = require('plenary.curl')
local M = {}

M.hl_part_of_speech = 'highlight PartOfSpeech guifg=#5AF78E'
M.hl_phonetic = 'highlight Phonetic guifg=#57C7FF'

function M.setup(configs)
	if configs.part_of_speech ~= nil then
		M.hl_part_of_speech = 'highlight PartOfSpeech guifg=' .. configs.part_of_speech
	end

	if configs.phonetic ~= nil then
		M.hl_phonetic = 'highlight Phonetic guifg=' .. configs.phonetic
	end
end

local function check_word(text)
    if text == nil or s == '' then
        return '', 'Empty string'
    elseif text:find(" ", 1, true) then
        return '', 'Select only one word'
    elseif not text:find("[^%d]") then
        return '', 'Invalid word'
    else
        return text, nil
    end
end

function M.get_word()
    local vim_mode = vim.api.nvim_eval('mode()')
    local word = ''
		local err

    if vim_mode == "n" then
        print('not implement yet')
        return nil
    elseif vim_mode == "v" then
        local start_position = vim.api.nvim_eval('getpos(\"v\")')
        local end_position = vim.api.nvim_eval('getpos(\".\")')

        if start_position[2] ~= end_position[2] then
            print('Select only one word')
            return nil
        else
            local line = vim.api.nvim_eval(
                             'getline(' .. start_position[2] .. ', ' ..
                                 end_position[2] .. ')')
            if line[1] ~= nil then
                word = string.sub(line[1], start_position[3], end_position[3])
            end
        end
    end

    word, err = check_word(word)
    if err ~= nil then print(err) end

    return word
end

function M.display_dictionary(word, phonetics, definitions)
	local string_phonetics = phonetics[1]
	for i = 2, #phonetics do
		string_phonetics = string_phonetics .. ' ' .. phonetics[i]
	end

	vim.api.nvim_exec(M.hl_part_of_speech, true)
	vim.api.nvim_exec(M.hl_phonetic, true)

	vim.cmd('echon ' .. '\'' .. word .. ' (\'')
	vim.cmd('echohl Phonetic | ' .. 'echon \'' .. string_phonetics .. '\' | ' .. 'echohl NONE', true)
	vim.cmd('echon \')\'')

	for _, definition in pairs(definitions) do
		vim.cmd('echohl PartOfSpeech | ' .. 'echo ' .. '\'(' .. definition["part"] .. ')\' | ' .. 'echohl NONE', true)
		print('    _ ' .. definition["definition"])
	end
end

function M.fetch_dictionary(word)
	local res = curl["get"]({
		method = 'get',
		url = 'https://api.dictionaryapi.dev/api/v2/entries/en_US/' .. word,
	})

	local body = res.body

	local phonetics = {}
	for raw_phonetic in string.gmatch(body, "text\":\"/.-/\"") do
		phonetic = string.match(raw_phonetic, "/.-/")
		phonetics[#phonetics + 1] = phonetic
	end

	local definitions = {}
	for raw_definition in string.gmatch(body, "partOfSpeech\":\".-%[{\"definition\":\".-\"") do
		definition = {}

		part_of_speech = string.match(raw_definition, ":\".-\",")
		definition["part"] = string.sub(part_of_speech, 3, string.len(part_of_speech) - 2)

		string_definition = string.match(raw_definition, "definition\":\".-\"")
		definition["definition"] = string.sub(string_definition, 14, string.len(string_definition) - 1)

		definitions[#definitions + 1] = definition
	end

	M.display_dictionary(word, phonetics, definitions)
end

function M.get_dictionary()
	local word = M.get_word()

	if word ~= '' then
		M.fetch_dictionary(word)

-- 		file = io.open("words.txt", "a+")
-- 		io.input(file)
-- 		exist_words = io.read()

-- 		is_existed = false
-- 		if exist_words ~= nil then
-- 			for token in string.gmatch(exist_words, "[^,]+") do
-- 				if word == token then
-- 					is_existed = true
-- 					print('existed')
-- 					break
-- 				end
-- 			end
-- 		end

-- 		if not is_existed then
-- 			print('not existed')
-- 			io.output(file)

-- 			if exist_words == nil then
-- 				io.write(word)
-- 			else
-- 				io.write(',' .. word)
-- 			end
-- 		end

-- 		io.close(file)
	end


end

return M
