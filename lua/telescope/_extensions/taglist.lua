return require "telescope".register_extension {
  exports = { taglist = require("telescope-taglist.picker") },
}
