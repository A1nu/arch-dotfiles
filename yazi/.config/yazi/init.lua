require("yaziline"):setup({

	-- Git-related file states
	modified_files_color = "yellow",
	added_files_color = "green",
	deleted_files_color = "red",
	renamed_files_color = "blue",
	untracked_files_color = "magenta",

	-- Visual style
	separator_style = "angly",

	-- File name truncation
	filename_max_length = 28,
	filename_truncate_length = 6,
	filename_truncate_separator = "...",
})
