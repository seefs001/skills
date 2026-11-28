## 子代理

- 默认由当前 agent 完成任务。仅在用户明确要求使用子代理或委派任务时，才创建子代理或向子代理分配工作。
- 独立工具调用仍可并行；任务授权、Skill 流程和并行工具调用不构成子代理委派授权。

## 验证授权

- 使用浏览器工具（如 `ego-browser`）进行验证前，先说明验证目标与操作范围，并征得用户明确同意。任务授权或 Skill 流程不构成浏览器验证授权；未获同意时，只做其他已授权的检查，并说明未验证项。

<!-- astrlink-debug:begin -->
## AstrLink local data

AstrLink added this section with its agent debugging tools and removes it when they are uninstalled.

- Do not read, copy, search, or open AstrLink's data directories (`~/Library/Application Support/com.astrlink.desktop`, `~/Library/Application Support/com.astrlink.desktop.isolated`), its raw key pin files (`~/Library/Application Support/com.astrlink.desktop/raw-key-pins.json`, `~/Library/Application Support/com.astrlink.desktop.isolated/raw-key-pins.json`), any `astrlink.db*` file, or the control session files (`~/.astrlink/control-session.json`, `~/.astrlink/control-session-dev.json`), and do not run `sqlite3` on them.
- The control socket and the session token only carry observer access. Do not use them to change AstrLink settings.
<!-- astrlink-debug:end -->
