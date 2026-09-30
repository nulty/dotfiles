-- stdpath("data") is a symlink into /usr/local/.local/data/nvim, shared by
-- every user in the devs group (see setup.sh). setgid and default ACLs keep new
-- files group-writable, but installers that pass an explicit mode (mkdir 0755)
-- or build elsewhere and move the result in slip past them, leaving files the
-- next user can't update. Tools that do that hand their output back here.
local M = {}

-- The real path, so nothing stored in the shared dir routes through one
-- user's home directory.
M.dir = vim.fn.resolve(vim.fn.stdpath("data"))

-- Give what the current user owns under `path` to devs, group-writable.
-- Runs in the background; does nothing for users outside devs.
function M.share_with_devs(path)
  vim.system({
    "sh", "-c",
    'id -nG | grep -qw devs && find "$1" -user "$(id -un)" ! -type l'
      .. ' -exec chgrp devs {} + -exec chmod g+rwX {} +',
    "sh", path,
  })
end

return M
