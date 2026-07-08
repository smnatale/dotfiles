return {
	settings = {
		gopls = {
			hints = {
				rangeVariableTypes = true,
				parameterNames = true,
				constantValues = true,
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				functionTypeParameters = true,
			},
			codelenses = {
				references = true,
				implementations = true,
				gc_details = true,
				run_govulncheck = true,
				test = true,
				generate = true,
			},
			completeUnimported = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
}
