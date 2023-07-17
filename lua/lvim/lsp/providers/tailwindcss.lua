local opts = {
  root_dir = function(fname)
    local util = require "lspconfig/util"
<<<<<<< HEAD
    return util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.js", "tailwind.cjs")(fname)
=======
    return util.root_pattern(
      "tailwind.config.js",
      "tailwind.config.ts",
      "tailwind.config.cjs",
      "tailwind.js",
      "tailwind.ts",
      "tailwind.cjs"
    )(fname)
>>>>>>> 14b0878 (upgrade new lunar vim)
  end,
}

return opts
