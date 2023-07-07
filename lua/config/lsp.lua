-- Define signs
-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " "(❌) }
local signs = { Error = "🔥", Warn = "⚠️ ", Hint = "🇦", Info = "ℹ️" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=orange ]])

-- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=#5f0a0a guibg=#1f2335]])
-- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder2 guifg=red ]])
-- local border = {
-- 	{ "▛", "FloatBorder" },
--
-- 	{ "▀", "FloatBorder" },
-- 	{ "▜", "FloatBorder" },
--
-- 	{ "▐", "FloatBorder" },
-- 	{ "▟", "FloatBorder" },
--
-- 	{ "▄", "FloatBorder" },
--
-- 	{ "▙", "FloatBorder" },
-- 	{ "▌", "FloatBorder" },
-- }
-- local border = "double"

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- lsp massage
-- table from lsp severity to vim severity.
-- local severity = {
-- 	"error",
-- 	"warn",
-- 	"info",
-- 	"info", -- map both hint and info to info?
-- }
-- vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
-- 	vim.notify(method.message, severity[params.type])
-- end

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
-- 	border = border,
-- 	focus = false,
-- 	width = 50,
-- })
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
-- 	underline = true,
-- })
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- List of LSP I Need to add
-- clangd, sumneko_lua, rust_analyzer, ltex, bashls, diagnosticls,
-- texlab, vimls, pyls, Changd, tsserver, jedi_language_server

local servers = {
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--clang-tidy-checks=*",
			"--header-insertion=iwyu",
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	},
	bashls = {},
	vimls = {},
	pylsp = {},
	cmake = {},
	texlab = {
		settings = {
			texlab = {
				--auxDirectory = "/tmp/.",
				--bibtexFormatter = "texlab",
				build = {
					--args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f", "-pv" },
					--args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
					-- executable = "tectonic",
					args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
					forwardSearchAfter = true,
					onSave = true,
					isContinuous = true,
				},
				chktex = {
					onEdit = true,
					onOpenAndSave = true,
				},
				diagnosticsDelay = 10,
				formatterLineLength = 80,
				forwardSearch = {
					-- executable = "okular",
					-- args = { "--unique", "--noraise", "file:%p#src:%l%f" },
					-- executable = "zathura",
					-- args = { "--synctex-forward", "%l:1:%f", "%p" },
					executable = "evince-synctex",
					args = { "-f", "%l", "%p", '"code -g %f:%l"' },
					onSave = true,
				},
				latexFormatter = "latexindent",
				latexindent = {
					modifyLineBreaks = true,
				},
			},
		},
	},
	grammarly = { filetypes = { "markdown", "tex", "text", "org", "latex" } },
	textlsp = {
		settings = {
			textLSP = {
				analysers = {
					languagetool = {
						enabled = true,
						check_text = {
							on_open = true,
							on_save = true,
							on_change = true,
						},
					},
					gramformer = {
						-- gramformer dependency needs to be installed manually
						enabled = true,
						gpu = true,
						check_text = {
							on_open = true,
							on_save = true,
							on_change = true,
						},
					},
					openai = {
						enabled = true,
						api_key = "<MY_API_KEY>",
						check_text = {
							on_open = false,
							on_save = false,
							on_change = false,
						},
						-- model = 'text-ada-001',
						model = "text-babbage-001",
						-- model = 'text-curie-001',
						-- model = 'text-davinci-003',
						edit_model = "text-davinci-edit-001",
						max_token = 16,
					},
					grammarbot = {
						enabled = false,
						api_key = "<MY_API_KEY>",
						-- longer texts are split, this parameter sets the maximum number of splits per analysis
						input_max_requests = 1,
						check_text = {
							on_open = false,
							on_save = false,
							on_change = false,
						},
					},
				},
				documents = {
					org = {
						org_todo_keywords = {
							"TODO",
							"IN_PROGRESS",
							"DONE",
						},
					},
				},
			},
		},
	},
	-- pyright = {},
}
local lspconfig = require("lspconfig")
for name, config in pairs(servers) do
	--lspconfig[lsp].setup {
	-- on_attach = my_custom_on_attach,
	-- capabilities = capabilities,
	--}
	-- This is for Coq complication
	lspconfig[name].setup(require("coq").lsp_ensure_capabilities(config))
end

--------------------------------------
local rightAlignFormatFunction = function(diagnostic) -- luacheck: ignore
	return string.format("%s\r🔥", diagnostic.message)
end

vim.diagnostic.config({
	underline = true,
	signs = true,
	virtual_text = true,
	-- virtual_text = { source = true, prefix = "", format = rightAlignFormatFunction, spacing = 0 },
	float = {
		show_header = true,
		source = true,
		border = border,
		focus = false,
		scope = "line",
		-- width = 60,
		max_height = 5,
		max_width = 60,
		-- pos=15,
	},
	update_in_insert = true, -- default to false
	severity_sort = true, -- default to false
})
--
vim.o.updatetime = 10
-- Code lens
-- vim.cmd[[ autocmd BufEnter,CursorHold,InsertLeave * lua vim.lsp.codelens.refresh()]]
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once

-- vim.api.nvim_command([[autocmd CursorHold,CursorHoldI *
--     lua vim.diagnostic.open_float({scope="line",pos=2}, {focus=false})]])
-- vim.cmd[[autocmd CursorHold * lua vim.lsp.buf.code_action()]]
vim.api.nvim_command([[autocmd CursorHold * silent! lua vim.lsp.buf.hover()]])
-- vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])

vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.open_float(nil,{})]])
-- vim.cmd([[autocmd DiagnosticChanged * lua vim.diagnostic.setqflist() ]])
vim.api.nvim_command([[autocmd BufWritePre * lua vim.lsp.buf.format({ })]])

-- vim.api.nvim_command([[autocmd BufWritePre * lua vim.lsp.buf.formatting({ })]])
vim.api.nvim_command([[autocmd CursorHold *tex  silent! TexlabForward]])
-- vim.api.nvim_command([[autocmd BufWritePre * lua vim.lsp.buf.format({ async = true  })]])
-- vim.api.nvim_command([[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]])
-- vim.cmd([[autocmd CursorHold * silent! lua vim.lsp.buf.signature_help()]])
-- vim.cmd([[autocmd CursorHold,CursorHoldI * silent! lua vim.lsp.buf.document_highlight()]])
-- telescope-config.lua
-- Maps
--------------------------------------------------
local null_ls = require("null-ls")
local sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.cmake_format,
	-- null_ls.builtins.formatting.yapf,
	-- null_ls.builtins.formatting.astyle,
	-- null_ls.builtins.formatting.clang_format,
	-- null_ls.builtins.formatting.latexindent,
	-- null_ls.builtins.formatting.uncrustify,
	--null_ls.builtins.formatting.prettier,
	null_ls.builtins.completion.spell,
	null_ls.builtins.code_actions.gitsigns,
	--null_ls.builtins.diagnostics.mypy,
	null_ls.builtins.diagnostics.chktex,
	-- null_ls.builtins.diagnostics.cppcheck,
	-- null_ls.builtins.diagnostics.flake8,
	null_ls.builtins.diagnostics.luacheck,
	-- null_ls.builtins.diagnostics.misspell,
	-- null_ls.builtins.diagnostics.proselint,
	-- null_ls.builtins.diagnostics.alex,
	-- null_ls.builtins.diagnostics.checkmake,
	null_ls.builtins.diagnostics.codespell,
	-- null_ls.builtins.diagnostics.markdownlint,
	null_ls.builtins.diagnostics.shellcheck,
	--null_ls.builtins.diagnostics.textlint,
	-- null_ls.builtins.diagnostics.write_good,
	null_ls.builtins.diagnostics.vale,
	null_ls.builtins.hover.dictionary,
	--null_ls.builtins.diagnostics.gccdiag,
	--[[ null_ls.builtins.completion.luasnip, ]]
	null_ls.builtins.completion.spell,
	null_ls.builtins.completion.tags,
}

require("null-ls").setup({
	on_init = function(new_client, _)
		new_client.offset_encoding = "utf-8"
	end,
	sources = sources,
	update_in_insert = true,
})
