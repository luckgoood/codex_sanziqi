$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceFile = Join-Path $ProjectRoot "src\main.f90"
$BuildDir = Join-Path $ProjectRoot "build"
$OutputFile = Join-Path $BuildDir "tic_tac_toe.exe"

$GFortran = Get-Command gfortran -ErrorAction SilentlyContinue
if (-not $GFortran) {
    $Fallback = "D:\msys64\ucrt64\bin\gfortran.exe"
    if (Test-Path $Fallback) {
        $GFortran = $Fallback
        $env:Path = "$(Split-Path -Parent $Fallback);$env:Path"
    }
    else {
        throw "未找到 gfortran。请把 D:\msys64\ucrt64\bin 加入 Path，或确认 gfortran 已安装。"
    }
}
else {
    $GFortran = $GFortran.Source
    $env:Path = "$(Split-Path -Parent $GFortran);$env:Path"
}

New-Item -ItemType Directory -Force $BuildDir | Out-Null

& $GFortran $SourceFile -Wall -Wextra -o $OutputFile

Write-Host "编译成功：$OutputFile"
