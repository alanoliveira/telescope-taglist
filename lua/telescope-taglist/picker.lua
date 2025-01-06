local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local entry_display = require "telescope.pickers.entry_display"
local pickers = require "telescope.pickers"
local utils = require "telescope.utils"

local static_keys = { "cmd", "filename", "kind", "name", "static" }

local function extract_tag_scope(tag)
  local scope_keys = vim.tbl_filter(function(k)
    return not vim.tbl_contains(static_keys, k)
  end, vim.tbl_keys(tag))

  if #scope_keys == 0 then
    return ""
  end

  local scopes = vim.tbl_map(function(scope_key)
    return vim.tbl_get(tag, scope_key)
  end, scope_keys)
  return table.concat(scopes)
end

local function entry_maker(opts)
  opts.show_scope = vim.F.if_nil(opts.show_scope, true)

  local display_items = {
    { width = 16 },
  }

  if opts.show_kind then
    table.insert(display_items, { width = 3 })
  end

  if opts.show_scope then
    table.insert(display_items, { width = 20 })
  end

  local hidden = utils.is_path_hidden(opts)
  if not hidden then
    if opts.fname_width then
      table.insert(display_items, { width = opts.fname_width })
    else
      table.insert(display_items, { remaining = true })
    end
  end

  local displayer = entry_display.create {
    separator = " │ ",
    items = display_items,
  }

  local make_display = function(entry)
    local display_entry = { entry.name }

    if opts.show_scope then
      table.insert(display_entry, entry.scope)
    end

    if opts.show_kind then
      table.insert(display_entry, entry.kind)
    end

    if not hidden then
      local display_path, path_style = utils.transform_path(opts, entry.filename)
      table.insert(display_entry, {
        display_path,
        function()
          return path_style
        end,
      })
    end

    return displayer(display_entry)
  end

  return function(tag)
    local tag_entry = tag

    tag_entry.scope = extract_tag_scope(tag)
    tag_entry.ordinal = tag.name .. ": " .. tag.filename
    tag_entry.scode = tag.cmd:match("/^(.*)$?/")
    tag_entry.display = make_display
    return tag_entry
  end
end

return function(opts)
  opts = opts or {}
  opts.search = opts.search or ".*"

  pickers
      .new(opts, {
        prompt_title = "taglist",
        finder = finders.new_table {
          results = vim.fn.taglist(opts.search),
          entry_maker = opts.entry_maker or entry_maker(opts),
        },
        previewer = previewers.ctags.new(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function()
          action_set.select:enhance {
            post = function()
              local selection = action_state.get_selected_entry()
              if not selection then
                return
              end

              -- escape special characters
              local scode = selection.scode:gsub("[%]~*]", function(ch)
                return "\\" .. ch
              end)

              vim.cmd "keepjumps norm! gg"
              vim.fn.search(scode)
              vim.cmd "norm! zz"
            end,
          }
          return true
        end,
      })
      :find()
end
