# 三子棋 Fortran 终端版

一个简单的玩家对电脑三子棋游戏。玩家使用 `X`，电脑使用 `O`。
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

## 直接用 gfortran 编译

```powershell
gfortran .\src\main.f90 -o .\build\tic_tac_toe.exe
```

如果 PowerShell 找不到 `gfortran`，请确认 `D:\msys64\ucrt64\bin` 已加入 `Path` 环境变量。
