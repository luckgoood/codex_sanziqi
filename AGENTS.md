# 项目协作说明

## 固定协作要求

- 后续每次修改代码，都自动提交到 GitHub 上。
- 每一次回复的末尾都加上固定后缀：`:FFFFFF~`

## 项目概览

- 项目名称：`codex_sanziqi`
- 项目类型：Fortran 终端三子棋游戏。
- 当前玩法：玩家对电脑。
- 玩家符号：`△`
- 电脑符号：`O`
- 主程序入口：`src/main.f90`
- 构建脚本：`build.ps1`
- 远程仓库：`https://github.com/luckgoood/codex_sanziqi.git`
- 主分支：`main`

## 当前目录结构

```text
.
├── .codex/
│   ├── hooks.json
│   ├── hooks/
│   └── skills/
│       └── planning-with-files/
├── AGENTS.md
├── README.md
├── build.ps1
├── .gitignore
└── src/
    └── main.f90
```

## 构建和运行

- 推荐在 PowerShell 中运行构建脚本：

```powershell
.\build.ps1
```

- 构建成功后会生成：

```text
build\tic_tac_toe.exe
```

- 运行游戏：

```powershell
.\build\tic_tac_toe.exe
```

- 如果 PowerShell 禁止运行脚本，可以先执行：

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

## gfortran 环境

- 构建脚本会优先查找环境变量 `Path` 中的 `gfortran`。
- 如果找不到，会尝试使用固定路径：

```text
D:\msys64\ucrt64\bin\gfortran.exe
```

- 如果用户手动配置环境变量，通常需要把下面这个目录加入 `Path`：

```text
D:\msys64\ucrt64\bin
```

- 构建脚本会在当前 PowerShell 进程中临时把 gfortran 所在目录加入 `Path`，这样编译时能找到相关运行库。

## 游戏逻辑

- 棋盘使用 1 到 9 表示落子位置。
- 玩家输入数字选择位置。
- 输入不是数字、超出 1 到 9、或者位置已有棋子时，程序会提示重新输入。
- 电脑会先寻找自己能立即获胜的位置。
- 如果电脑不能立即获胜，会寻找玩家 `△` 的获胜位置并阻挡。
- 如果没有必须处理的位置，电脑按优先级选择空位：

```text
5, 1, 3, 7, 9, 2, 4, 6, 8
```

- 任意一方连成三子后结束游戏。
- 9 步走满且无人获胜时判定为平局。

## Fortran 实现注意事项

- 因为玩家符号 `△` 是 UTF-8 字符，棋盘数组使用 `character(len=3)`。
- `winner` 和 `check_winner` 也使用 `character(len=3)`，避免三角符号被截断。
- `find_winning_move` 的 `player` 参数使用 `character(len=*)`，兼容 `'O'` 和 `'△'`。
- 修改棋子符号时，要同步检查棋盘字符长度、胜负判断和电脑阻挡逻辑。

## Git 和提交习惯

- 生成物不提交到仓库。
- `.gitignore` 已排除 `build/`、`*.exe`、目标文件、模块文件、编辑器目录和临时文件。
- 代码或项目说明有修改后，按当前协作要求提交并推送到 GitHub。
- 常用流程：

```powershell
git status --short
git add <文件>
git commit -m "<提交说明>"
git push
```

## 项目级 Codex Skill

- 本项目已安装项目级 skill：`planning-with-files`。
- 安装位置：`.codex/skills/planning-with-files/`
- 配套 hooks 位置：`.codex/hooks/`
- hooks 配置文件：`.codex/hooks.json`
- 这个 skill 是复制到当前仓库中的，不是安装到全局 `C:\Users\li\.codex\skills`。
- 作用范围应限制在当前项目；在其他项目中不会自动生效，除非那些项目也复制同样的 `.codex` 配置。
- 该 skill 用于复杂任务时把计划、发现和进度保存为文件，例如 `task_plan.md`、`findings.md`、`progress.md` 或 `.planning/` 下的计划文件。

## 已知项

- README 当前仍写着“玩家使用 `X`”，但源码中实际玩家符号是 `△`。以后更新 README 时应同步修正。
- 当前项目是玩家对电脑模式；曾经切换为双人模式，但之后已经通过 `git revert` 回退。
