# telescope-taglist

A [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) extension to display tags.

It differs from the built-in `tags` picker because it uses the `taglist` function (`:h taglist`) to generate the entries.  
Additionally, it allows applying an initial filter and displaying extra fields.

![out](https://github.com/user-attachments/assets/e78d7fd4-d115-484f-a2c2-3e65d9df76ee)



## Setup

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "alanoliveira/telescope-taglist",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = true,
}
```

## Usage

Showing all tags
```
:Telescope taglist
```

Filtering
```
:Telescope taglist search=SomeRegexp
```

Creating a shortcut to search the tag under the cursor
```
:nnoremap gd :Telescope taglist search=<C-R><C-W><cr>
```

### Options

Besides the options common to all pickers, the following options control which fields are displayed:

- `show_kind` (boolean): Determines whether to show the tag kind
- `show_scope` (boolean): Determines whether to show the tag value for any additional field such as **class**, 
**module**, etc...

Read about tags format at https://man.archlinux.org/man/tags.5#Proposal
