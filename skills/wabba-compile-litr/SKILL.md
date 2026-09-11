---
name: wabba-compile-litr
description: Compile (and optionally publish) the "Life in the Ruins" Fallout 4 modlist with the wabbajack-linux-cli fork. Use when the user wants to recompile LitR, rebuild the LitR wabbajack file, or publish/upload a new LitR release.
---

# Compile Life in the Ruins

Recompiles the LitR modlist with the Linux Wabbajack CLI fork and, only on explicit
go-ahead, publishes it. Read the whole Caveats section before running — three of them
have already caused a real failed compile and a wiped Nexus token in past runs.

## Paths

- MO2 install (compile input): `/home/wayne/Games/FO4/LitR`
- CLI repo: `/home/wayne/Games/FO4/project-wabbajack-cli/wabbajack-linux-cli`
- Compiled output dir: `/home/wayne/Games/FO4/compiled-output`
- Nexus token store: `~/.local/share/Wabbajack/encrypted/nexus-oauth-info`

## Steps

1. **Build.**
   ```
   cd /home/wayne/Games/FO4/project-wabbajack-cli/wabbajack-linux-cli/Wabbajack.CLI
   dotnet build -c Release
   ```
   Binary lands at `bin/Release/net9.0/wabbajack-cli` — lowercase, hyphenated. There is
   no `Wabbajack.CLI.dll`; the assembly name is `wabbajack-cli` (set in the csproj), not
   the project name.

2. **Compile.**
   ```
   cd bin/Release/net9.0
   ./wabbajack-cli compile -i "/home/wayne/Games/FO4/LitR" -o "/home/wayne/Games/FO4/compiled-output"
   ```
   Run this in the background and tail the log — a clean run takes 1-2 minutes once
   Nexus auth is healthy. Watch for `Compiler Step: <name>` progress lines and treat any
   `WARN`/`Resolution failed`/`Unhandled exception`/`CompilerException` as a stop signal,
   not noise — see Caveats. A healthy run shows zero `Resolution failed` lines during the
   "Cleaning Invalid Archives" step.

3. **Publish — only with explicit, in-this-conversation go-ahead.** `compiler_settings.json`
   for LitR sets `MachineUrl: wj-featured/life_in_the_ruins` — this is the real, public,
   official Wabbajack featured-modlist repo and CDN. `--publish` pushes a live update to
   both, under the author key for `WhiskyTangoFawks`. Do not treat a past approval as
   standing authorization for a later run; confirm each time. Once approved, re-run step 2
   with `-p`/`--publish` appended (compile writes the required `.meta.json` itself, so a
   single `compile --publish` invocation is enough — no separate publish step needed).

## Caveats

- **Nexus auth must be live before compiling.** If the token is expired/missing, every
  Nexus-hosted archive fails verification during "Cleaning Invalid Archives" — most
  archives get silently dropped from the compile index, and only mods needing archive
  reconstruction (e.g. BSA rebuilds) hard-fail, deep in the run and hard to trace back to
  auth. If you see a wall of `Resolution failed for: (...)` warnings, stop and re-auth
  (below) rather than chasing the downstream failure.

- **`nexus-login` is interactive and needs a fifo, not plain Bash.** It prints a prompt,
  waits for Enter, opens the browser via `xdg-open`, then waits for the user to paste the
  redirect URL — Bash tool calls aren't interactive, so drive it through a named pipe:
  ```
  rm -f /tmp/nl_stdin; mkfifo /tmp/nl_stdin
  ( exec 3<>/tmp/nl_stdin; ./wabbajack-cli nexus-login <&3 > /tmp/nexus_login.log 2>&1; echo "EXIT:$?" >> /tmp/nexus_login.log ) &
  disown
  # once the log shows "Press Enter to open your browser...":
  printf '\n' > /tmp/nl_stdin
  # once the log shows "Paste the redirect URL:", relay that ask to the user, then on their reply:
  printf '%s\n' '<url the user pastes>' > /tmp/nl_stdin
  # confirm the log ends with "Nexus Mods login successful"
  rm -f /tmp/nl_stdin
  ```

- **A failed compile run can burn your Nexus IP rate limit fast.** ~750 archives get
  verified per compile; if the token is expired going in, that's ~750 near-simultaneous
  refresh attempts. This has tripped Nexus's DDoS-protection IP suspension (10 min ban)
  in the past. The refresh-stampede and a related bug (a failed refresh was overwriting —
  wiping — the still-valid stored token) were fixed in `Wabbajack.Networking.NexusApi/NexusApi.cs`
  during the session that created this skill; confirm that fix is still present
  (`git log`/`grep RefreshFailureCooldown` in that file) before assuming a bad token can't
  recur. If it's missing, re-apply it before doing anything else — don't just retry
  compiling into a live ban.

- **Unfixed, still-live risk:** `ACompiler.CleanInvalidArchivesAndFillState` (in
  `Wabbajack.Compiler/ACompiler.cs`) drops an archive from the compile entirely on *any*
  exception during its network verification — not just a genuine "file no longer hosted"
  result. A transient network blip or a fresh rate-limit mid-run can still silently drop
  an otherwise-fine archive, surfacing later as an unrelated-looking `CompilerException`
  (e.g. a BSA reconstruction failing because its source archive vanished from the index).
  This was the root cause of the first failed compile in that session and was never
  patched — only the auth-refresh bugs were. If a compile fails with a "`File required for
  BSA ... doesn't exist ... No Match in Stack`"-shaped error, suspect this, not the mod
  files themselves.
