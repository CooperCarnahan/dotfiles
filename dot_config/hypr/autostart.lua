-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Per-machine autostart: untracked, absent on machines that never create it.
-- See .chezmoiignore.
require("default.hypr.require_optional").module("hypr.local-autostart")
