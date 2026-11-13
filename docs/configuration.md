# Configuration changes

Preserve unrelated customisations, mappings, plugins and integrations. Follow the existing layout in the [README](../README.md#architecture), and inspect the affected plugin's loading and setup lifecycle before changing its spec. Prefer `opts` when Lazy's normal setup is sufficient; use explicit configuration only when the lifecycle requires it.

For every plugin version constraint added, removed or changed, state the concrete compatibility requirement or user-selected release policy and what releases will be selectable in future. Update only the affected lock entries; do not impose an arbitrary pin or silently broaden a chosen policy.

Keep machine-specific values and secrets in the ignored `lua/config/local.lua` or environment, with tracked examples containing placeholders only. An absent optional setting is acceptable; a present but broken optional configuration or a missing required credential should produce a clear error, not be silently ignored or trigger a fallback to another provider. The existing startup uses `pcall` for the local module, so do not assume it currently reports errors inside a present file.

Use inexpensive local aliases only for repeatedly used, stable functions, preserving the original binding and behaviour. Do not assume a speed gain from an alias.
