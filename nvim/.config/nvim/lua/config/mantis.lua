return {
  view_issues = {
    layout = 'split',
    split_position = 'bottom',
    split_size = 0.25,
    default_filter = "assigned",
    limit = 500,
  },
  hosts = {
    {
      name = "chainlogic",
      url = "https://mantis.chainlogic.it",
      env = "MANTIS_CL",
    },
    {
      name = "williamhleucka",
      url = "https://mantis.williamhleucka.com",
      env = "MANTIS_WH",
    }
  },
}
