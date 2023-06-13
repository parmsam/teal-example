# Sys.setenv(GITHUB_PAT = "your_access_token_here")

# install necessary packages
if (!require("remotes")) install.packages("remotes")
remotes::install_github("insightsengineering/teal@*release")
remotes::install_github("insightsengineering/scda@*release")
remotes::install_github("insightsengineering/teal.modules.general@*release")