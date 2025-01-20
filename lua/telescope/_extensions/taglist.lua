local extension = require("telescope-taglist.extension")

return require "telescope".register_extension {
  setup = function (config)
    extension.config = config
  end,
  exports = { taglist = extension.picker },
}
