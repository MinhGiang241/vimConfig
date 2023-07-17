local opts = {
  settings = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
<<<<<<< HEAD
      schemas = {
        kubernetes = {
          "daemon.{yml,yaml}",
          "manager.{yml,yaml}",
          "restapi.{yml,yaml}",
          "role.{yml,yaml}",
          "role_binding.{yml,yaml}",
          "*onfigma*.{yml,yaml}",
          "*ngres*.{yml,yaml}",
          "*ecre*.{yml,yaml}",
          "*eployment*.{yml,yaml}",
          "*ervic*.{yml,yaml}",
          "kubectl-edit*.yaml",
        },
      },
=======
      schemas = require("schemastore").yaml.schemas(),
>>>>>>> 14b0878 (upgrade new lunar vim)
    },
  },
}

return opts
