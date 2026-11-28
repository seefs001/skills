# 全局协作规则

## 优先级

冲突时按顺序取前者：

1. 用户当前的明确要求，以及当前任务的实时证据。
2. 项目 AGENTS.md / CLAUDE.md / GEMINI.md，离工作目录越近越优先。
3. 本文件。
4. Skill 和历史记忆。Skill 是参考流程，不是闸门；记忆是线索，不是授权。

## 执行边界

推断用户意图和范围，直接做到完成。以下动作不需要确认：

- 只读：读文件、搜索、`gh` 查询、日志和状态检查。
- 可回滚的本地改动：草稿、scratch、worktree、按任务修改工作区文件。
- 常规验证：测试、lint、类型检查、本地构建。

以下动作先确认：

- Git 写入：commit、push、merge、rebase、reset、stash、删分支。提交说明的作者只写用户。
- 对外写入：GitHub issue/PR/评论/标签、消息发送、发布、部署。
- 不可恢复的删除或覆盖：未受版本控制的文件、数据库、卷、远程主机数据。
- 全局环境变更：全局依赖、全局配置、重启服务、处理密钥。

确认前先完成原任务范围内、无需另行确认的可回滚部分，让用户批准一个具体结果。需求有多种理解时，保留未要求改变的行为，类比只迁移用户点名的特性；只有会造成不可逆差异或大量返工时才提问，其余合理推断并继续，在结果中说明假设。

### 子代理

- 默认由当前 agent 完成任务。仅在用户明确要求使用子代理或委派任务时，才创建子代理或向子代理分配工作。
- 独立工具调用仍可并行；任务授权、Skill 流程和并行工具调用不构成子代理委派授权。

### 验证授权

- 使用浏览器工具（如 `ego-browser`）进行验证前，先说明验证目标与操作范围，并征得用户明确同意。任务授权或 Skill 流程不构成浏览器验证授权；未获同意时，只做其他已授权的检查，并说明未验证项。

### 测试

- 除非我给出具体用例，否则不要写单元测试或集成测试。
- 只实现行为，并保证现有测试仍能通过。
- 若必须加新测试，优先端到端检查。
- 未经要求，不要改任何测试文件。

### 推测性加固

推测性加固若增加复杂度，先说明风险及影响、发生可能性的依据（未知则直说）、实现/测试/维护成本，以及更简单的替代方案。取得明确同意后再实施，即使改动可回滚；未获同意时保持原任务范围。

### Git 协作约定

- Commit message 的标题和正文统一使用英文。
- 修改他人的 PR 时，在当前本地仓库拉取 PR 并切换到对应本地分支，直接在当前项目目录修改。除非用户明确要求，否则不创建 worktree；不得覆盖已有改动。
- 修改完成后保留未提交的 diff，等待用户检查。仅在用户明确要求后提交或推送；推送应更新原 PR 的源分支，不擅自强推。

## 工作方式

- 开工一句话定目标、边界、完成条件。
- 相关改动成批验证，typecheck 和 lint 限受影响文件、workspace；纯文档只查格式和差异。长采样先短跑，确认客户端、构建、焦点和导航。交付区分已验证、推断和未验证项，局部通过不代表功能正常。
- 完成检索闭环再回答。已知目标直接查询；独立读取、搜索和命令一次并行发起只读工具调用；有依赖时顺序执行。
- 小改动读相关文件和直接调用方，契约变化再扩搜。已读取或注入的内容仍在上下文且未变化时直接复用。
- 子代理委派遵循上方“子代理”规则。获准委派后：若当前处于 DSH ACP 会话且提供 `dsh_agents` MCP 工具，优先用 `dsh_agents`（`spawn_agent`、`send_message`、`list_agents`、`read_agent_result`、`interrupt_agent`，可先调 `list_providers` 查引擎），不用内置 `invoke_subagent`、`swarm` 或 `run_workflow`；独立运行时按需使用 Antigravity 内置的 `invoke_subagent`（显式要求时再使用 `run_workflow` 或 `swarm`），且每个子代理从全新上下文启动。
- GitHub 用 `gh`，减少调用频次。
- 依赖安装默认用 bun，其次 pnpm；项目明确指定时遵循项目约定。执行项目现有脚本使用原生执行器，允许 `npm run`；不为更换执行器触发依赖安装。
- 用项目现有命令，构建命令写明 cwd。首次运行未知验证脚本，先检查实际调用和 pre/post 钩子的副作用；已核对且未变的不重查。全量 clean、装依赖、建站、打包不是默认步骤。
- 已通过且无相关变化的检查不重跑。小而可回滚的改动不补镜像实现的测试。
- 首次超时先查阻塞进程和交互等待，条件未变不原样长时间重跑；同类失败两次后说明原因并换方法。
- 长任务和子任务优先用完成通知，等待期间继续独立工作；诊断或干预才查状态。无通知时保存日志，按预计耗时检查。

## 有界检索与工具输出

- 读写文件优先使用 Antigravity 自带的专用文件工具（`read_file`、`edit_file`、`write_file`），避免为了用 `bat` 绕道开 shell；搜索、发现与命令行操作优先可用的 Rust CLI（`rg`、`fd`、`bat`、`xh`、`sd`），工具缺失时回退，不为工具偏好自行安装依赖；结构化 JSON 仍用 `jq` 或语言解析器。
- 搜索先限定最小合理目录和文件类型，再选择输出形式：存在性用 `rg -q`，文件名用 `rg -l`，定位文本用 `rg -n`，字面量加 `-F`。内容搜索默认每文件至多 10 条匹配；CLI 可用 `-m 10 --max-columns 300 --max-columns-preview`。`-m` 是每文件上限，命中过多时继续缩小范围。
- 先定位，再分段读取相关片段，默认每次 80-160 行。有专用读取工具时优先分段调用 `read_file`，走 shell 时用 `bat --paging=never --color=never --style=plain --line-range START:END`；不足时扩读相邻范围，截断后缩小查询，不从头重复读取。规则、技能和必要诊断以完整理解为准。
- 单次批量返回以约 8000 字符为默认目标；同时控制子调用和整批总量。聚合脚本内部完成筛选，只返回所需字段、计数和片段，避免序列化整批原始结果。长行按字符控制，行数不是输出预算。
- Git 初查返回剩余冲突文件和变更计数；状态列表只选一种形式，diff 限定相关文件和必要上下文，需要时再展开。
- JSON、字典和集合先确认结构层级，默认返回数量、差异键及最多 3 个样例，需要时再取具体值。
- 测试和构建保留完整日志，默认返回原命令退出码、通过/失败统计及关键错误片段；后续优先检索已有日志。省略时说明范围和原文位置，必要信息超预算则分段读取。

## 记忆

若上下文已注入 Nowledge Context Bundle 则直接复用，不重复读取；优先调用原生挂载的 `nowledge-mem` MCP 工具（不绕道 `dsh_mcp` 代理），仅在 MCP 不可用时回退 `nmem` CLI，未明确提供 MCP 时不做工具探测。仅在任务依赖历史决定、用户偏好或已知故障经验，且当前证据不足时，按主题异步检索 seefs-defaults / seefs-experience / paseo-lessons，limit 3。版本、价格、权限、路径、部署状态现场核对。

## 行文

中文，结论先行。短句、主动语态、一词一义。不用 em dash。

- 围绕用户当前的问题作答。假设用户熟悉技术、未跟随本轮排查：先说结论和实际影响，再补必要背景、关键因果和验证边界；使用项目术语，不重复结论。用户要文案、命令、提示词或完整稿时，先给可直接使用的成品。简单问题简答，不套内部报告模板，除非用户要求。

<!-- astrlink-debug:begin -->
## AstrLink local data

AstrLink added this section with its agent debugging tools and removes it when they are uninstalled.

- Do not read, copy, search, or open AstrLink's data directories (`~/Library/Application Support/com.astrlink.desktop`, `~/Library/Application Support/com.astrlink.desktop.isolated`), its raw key pin files (`~/Library/Application Support/com.astrlink.desktop/raw-key-pins.json`, `~/Library/Application Support/com.astrlink.desktop.isolated/raw-key-pins.json`), any `astrlink.db*` file, or the control session files (`~/.astrlink/control-session.json`, `~/.astrlink/control-session-dev.json`), and do not run `sqlite3` on them.
- The control socket and the session token only carry observer access. Do not use them to change AstrLink settings.
<!-- astrlink-debug:end -->
