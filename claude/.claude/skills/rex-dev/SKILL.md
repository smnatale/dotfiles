---
name: rex-dev
description: Start, check or stop a long-running process (dev server, bundler like Metro or Expo, watcher, emulator log) in its own Rex tab so I can see and use it. Use whenever something needs to keep running, instead of a background Bash command.
---

Long-running processes always go in a named Rex tab in my session, never in a background Bash command. That way I can watch it and type into it myself (reload, open the dev menu, press `i` for iOS...).

1. Work out the command. A "Dev servers" section in the project's CLAUDE.md wins. Otherwise read `package.json`:
   - `expo` in dependencies: `npx expo start --port <port>`
   - `react-native` without `expo`: `npx react-native start --port <port>`
   - otherwise the `dev` script, then `start`, passing the port the way that tool expects (`--port <port>` for Vite and Next, or `PORT=<port>`)
   - use the package manager the lockfile points to (`pnpm-lock.yaml`, `yarn.lock`, `bun.lock`, `package-lock.json`). Only npm needs `--` before script args (`npm run dev -- --port <port>`). pnpm passes a literal `--` through to the script, so use `pnpm dev --port <port>`, and the same for yarn and bun.
2. Work out the port:
   - mobile bundlers (Expo, React Native) always use 8081. Bare React Native apps have the port built in, and only one app runs on the simulator at a time anyway.
   - everything else uses `wt port`, a fixed port per branch, so worktrees can run side by side.
3. Check the port is free: `lsof -nP -iTCP:<port> -sTCP:LISTEN`. If it's taken, find out who has it (`lsof -a -p <pid> -d cwd` gives the worktree) and tell me. Ask before stopping it - it may be another worktree's session.
4. Reuse a tab rather than open a duplicate. `rex window ls -s "$REX_SESSION"` - if a tab with the same label exists and its process is still running, use it. Label tabs by role: `metro`, `web`, `api`, `storybook`...
5. Open the tab without taking focus, in the worktree:
   ```sh
   rex window new -s "$REX_SESSION" metro -c "$PWD" --focus=false --keep-open --json -- npx expo start --port 8081
   ```
   Keep the block ID from the JSON.
6. Verify with `rex capture -s "$REX_SESSION" -b <block> --trim`. Wait until it says it's ready (a URL, "Waiting on", "ready in"...) or shows an error. Check again after making changes rather than assuming it reloaded.
7. Tell me the tab name and the URL or port.

To restart, send `ctrl+c` with `rex send-key`, check with a capture, then start it again in the same tab with `rex send` and `rex send-key enter`. Don't close tabs I might be using - ask first.
