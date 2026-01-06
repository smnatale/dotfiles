local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("swagger", {
		t("// @Summary "),
		i(1, "Brief description"),
		t({ "", "// @Description " }),
		i(2, "Detailed description"),
		t({ "", "// @Tags " }),
		i(3, "tag"),
		t({ "", "// @Accept json" }),
		t({ "", "// @Produce json" }),
		t({ "", "// @Param " }),
		i(4, "param"),
		t(" "),
		i(5, "query"),
		t(" "),
		i(6, "type"),
		t(" "),
		i(7, "true"),
		t(' "'),
		i(8, "description"),
		t('"'),
		t({ "", "// @Success 200 {object} " }),
		i(9, "ResponseType"),
		t({ "", "// @Failure 400 {object} " }),
		i(10, "ErrorType"),
		t({ "", "// @Router /" }),
		i(11, "endpoint"),
		t(" ["),
		i(12, "get"),
		t("]"),
		i(0),
	}),
}
