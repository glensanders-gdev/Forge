> ⚠️ Forge defaults not found — reinstall from project template if needed.

## Project-Specific Patterns

*Extracted from codebase by /push-standards — 2026-06-01*

---

### PowerShell over cmd for Windows shell operations

**Rule:** When `install.sh` or any Forge script needs to execute Windows-specific operations, invoke `powershell.exe -Command "..."` rather than `cmd.exe /c`.

**Reason:** PowerShell handles paths with spaces, returns meaningful exit codes, and is available on all modern Windows systems without elevation. `cmd.exe` `mklink` requires elevation for symlinks and has poor error output.

**Example:**
```bash
# Creating a junction
powershell.exe -Command "New-Item -ItemType Junction -Path '$target' -Value '$source'" > /dev/null 2>&1

# Not this
cmd.exe /c mklink /J "$target" "$source"
```

---

### ReparsePoint attribute check for junction detection

**Rule:** To test whether a Windows path is a junction (not a real directory), check for the `ReparsePoint` attribute via PowerShell. Do not rely on `test -d` alone — it returns true for both real dirs and junctions.

**Reason:** Bash's `test -d` cannot distinguish a junction from a real directory on Windows. The `ReparsePoint` attribute is the authoritative Windows signal that a directory is a junction or symlink.

**Example:**
```bash
is_junction() {
    powershell.exe -Command \
      "if ((Get-Item '$1' -Force -ErrorAction SilentlyContinue).Attributes -match 'ReparsePoint') { exit 0 } else { exit 1 }" \
      2>/dev/null
}
```
