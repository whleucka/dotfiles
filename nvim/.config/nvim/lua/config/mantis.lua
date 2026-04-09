return {
  view_issues = {
    default_filter = "assigned",
    limit = 250,
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
