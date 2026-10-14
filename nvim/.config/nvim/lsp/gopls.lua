-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  -- go.work before go.mod, so a workspace opens as one server rather than one
  -- per module.
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      -- gopls has gofumpt built in, so formatting needs no separate binary.
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      semanticTokens = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
        shadow = true,
      },
      codelenses = {
        generate = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        gc_details = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
