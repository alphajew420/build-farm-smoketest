$ErrorActionPreference='Continue'
$L=@()
$L+="### Illuminati build image probe - Windows"
$os=Get-CimInstance Win32_OperatingSystem
$L+="## OS"; $L+=($os.Caption+" ("+$os.Version+")")
$tools='git','node','npm','npx','pnpm','yarn','corepack','python','pip','go','rustc','cargo','rustup','dotnet','java','javac','msbuild','cmake','7z','curl','tar','choco','winget'
$L+="## Tools"
foreach($t in $tools){
  $c=Get-Command $t -ErrorAction SilentlyContinue
  if($c){ try{$v=(& $t --version 2>&1 | Select-Object -First 1)}catch{$v='(present)'}; $L+=('{0,-10} {1}' -f $t,$v) }
  else { $L+=('{0,-10} ABSENT' -f $t) }
}
$L+="## Visual Studio / MSVC build tools (Rust msvc target, C/C++, native node modules need these)"
$vw="${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if(Test-Path $vw){
  $name=& $vw -latest -property displayName 2>$null
  $ver=& $vw -latest -property installationVersion 2>$null
  $vc=& $vw -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null
  $L+=("Visual Studio: "+$(if($name){$name}else{'(present)'})+"  "+$ver)
  $L+=("C++ build tools (cl.exe + linker): "+$(if($vc){'INSTALLED'}else{'NOT installed'}))
} else { $L+="vswhere not found - no Visual Studio / MSVC build tools installed" }
$L+="## Package managers"
$L+=("choco:  "+$(if(Get-Command choco -ErrorAction SilentlyContinue){'present - choco install ... works'}else{'ABSENT'}))
$L+=("winget: "+$(if(Get-Command winget -ErrorAction SilentlyContinue){'present'}else{'ABSENT'}))
$L -join "`r`n" | Out-File -Encoding utf8 probe.txt
Get-Content probe.txt
exit 0
