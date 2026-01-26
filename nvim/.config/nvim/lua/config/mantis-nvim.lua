return {
  view_issues = {
    default_filter = "assigned",
    limit = 100,
  },
  hosts = {
    {
      name = "williamhleucka.com",
      url = "https://mantis.williamhleucka.com",
      env = "MANTIS_WH",
    },
    {
      name = "chainlogic",
      url = "https://mantis.chainlogic.it",
      env = "MANTIS_CL",
    }
  },
}
