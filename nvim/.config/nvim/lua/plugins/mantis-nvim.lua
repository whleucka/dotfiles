return {
  enabled = false,
  dir = "/home/whleucka/Projects/mantis.nvim",
  name = "mantis.nvim",
  config = function()
    require("mantis.config").setup({
      url = "https://mantis.williamhleucka.com",
      token = "TjmmrfGkagJXZXlu9UDXDqaIpyT-fjtB"
    })


    -- Register the MantisGetIssue command
    vim.api.nvim_create_user_command('MantisGetIssue', function(args)
      local mantis = require("mantis")
      local id = args.fargs[1]
      if not id then
        vim.notify('MantisGetIssue: Please provide an issue ID.', vim.log.levels.ERROR)
        return
      end
      local client = mantis.new() -- Create a new client instance
      local issue = client:get_issue(id)
      if issue then
        vim.pretty_print(issue)
      else
        vim.notify('MantisGetIssue: Failed to retrieve issue ' .. id, vim.log.levels.ERROR)
      end
    end, {
      nargs = 1,
      desc = 'Get a Mantis issue by ID',
    })
  end
}
