# 三子棋 Fortran 终端版

一个简单的 Fortran 终端三子棋游戏。启动后可选择“玩家对电脑”或“双人对战”模式。
玩家 1 使用 `△`，电脑或玩家 2 使用 `O`。
这个仓库也用于测试利用 Codex 进行 Git 项目管理。

## 项目结构

```text
.
├── src/
│   └── main.f90
├── build.ps1
├── .gitignore
└── README.md
```

## 编译

在 PowerShell 中运行：

```powershell
.\build.ps1
```

编译成功后会生成：

```text
build\tic_tac_toe.exe
```

## 运行

```powershell
.\build\tic_tac_toe.exe
```

启动后输入：

```text
1  选择玩家对电脑
2  选择双人对战
```

棋盘位置使用 1 到 9 表示；双人模式由玩家 1 先手。

## 直接用 gfortran 编译

```powershell
gfortran .\src\main.f90 -o .\build\tic_tac_toe.exe
```

如果 PowerShell 找不到 `gfortran`，请确认 `D:\msys64\ucrt64\bin` 已加入 `Path` 环境变量。
