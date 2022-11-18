local status, db = pcall(require, "dashboard")
if (not status) then return end

-- db.default_banner = {
--     '',
--     '',
--     ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
--     ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
--     ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
--     ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
--     ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
--     ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
--     '',
--     ' [ TIP: To exit Neovim, just power off your computer. ] ',
--     '',
-- }

db.default_banner = {
    '',
    '  __       __          __       __',
    '  \\ \\      \\ \\        / /      / /',
    '  \\ \\ _____\\ \\      / /_____ / /',
    '  \\ \\______\\ \\    / /______/ /',
    '  \\ \\      \\ \\  / /      / /',
    '  \\_\\      \\_\\/_/      /_/',
    '',
}


db.custom_center = {
    { icon = '  ',
        desc = 'Find recent files                       ',
        action = 'Telescope oldfiles',
        shortcut = ';o' },
    { icon = '  ',
        desc = 'Find buffer files                       ',
        action = 'Telescope buffers',
        shortcut = ';b' },
    { icon = '  ',
        desc = 'Find files                              ',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
        shortcut = ';f' },
    { icon = '  ',
        desc = 'File browser                            ',
        action = 'Telescope file_browser',
        shortcut = 'sf' },
    { icon = '  ',
        desc = 'Find word                               ',
        action = 'Telescope live_grep',
        shortcut = ';r' },
}
db.session_directory = "/home/dt/.config/nvim/session"

-- -- Command
--
-- DashboardNewFile  -- if you like use `enew` to create file,Please use this command,it's wrap enew and restore the statsuline and tabline
-- SessionSave,SessionLoad
