local colorFile = vim.fn.expand('~/.vimrc.color')

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end


local function reload() 
        vim.cmd("source ".. colorFile)
end

local w = vim.loop.new_fs_event()
local on_change
local function watch_file(fname)
	w:start(fname, {}, vim.schedule_wrap(on_change))
end
on_change = function()
	reload()
	-- Debounce: stop/start.
	w:stop()
	watch_file(colorFile)
end

-- reload vim config when background changes
if file_exists(colorFile) then
    watch_file(colorFile)
    reload()
else
    print("Color file not found: " .. colorFile .. "  [Not watching the file]")
    vim.cmd("set background=dark")
    vim.cmd("colorscheme monokai")
end

