# Verification

Before launching Neovim or a plugin, inspect the relevant startup and build hooks for writes and network access; choose a safe, appropriately isolated scenario. Do not run blanket Lazy syncs or updates, or restart existing sessions, as a verification shortcut.

Exercise the narrow changed behaviour with disposable fixtures and preserve the user's data. Do not use the user's clipboard; use a generated, non-sensitive fixture when clipboard functionality must be exercised. Choose checks appropriate to the risk and distinguish source inspection or configuration evidence from observed runtime behaviour. Report the actual evidence and any unavailable or unexercised checks; do not claim end-to-end behaviour from a successful load alone.
