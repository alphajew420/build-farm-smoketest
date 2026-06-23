$ErrorActionPreference='Continue'
function secs($a,$b){ '{0:n0}s' -f ($b-$a).TotalSeconds }
$L=@(); $t0=Get-Date
$L+="[t0] download rustup-init"
curl.exe -sSfL https://win.rustup.rs/x86_64 -o rustup-init.exe
$t1=Get-Date
$L+="[t1] install rust (gnu, minimal profile)"
.\rustup-init.exe -y --default-host x86_64-pc-windows-gnu --default-toolchain stable --profile minimal *> rustup.log
$t2=Get-Date
$env:Path="$env:USERPROFILE\.cargo\bin;$env:Path"
$L+="[t2] cargo new + build a trivial crate (cold compile)"
cargo new hello *> cargonew.log
Push-Location hello
cargo build --release *> ..\cargobuild.log
$ok=$LASTEXITCODE
Pop-Location
$t3=Get-Date
$L+=""
$L+=("rustup download : "+(secs $t0 $t1))
$L+=("rust install    : "+(secs $t1 $t2))
$L+=("trivial cargo build (cold): "+(secs $t2 $t3)+"  exit=$ok")
$L+=("TOTAL added to a build: "+(secs $t0 $t3))
$L+=""
$L+="cargo: "+((& cargo --version) 2>&1)
$L+="--- cargo build tail (did it link without MSVC/mingw?) ---"
$L+=(Get-Content ..\cargobuild.log -ErrorAction SilentlyContinue -Tail 8)
$L -join "`r`n" | Out-File -Encoding utf8 timing.txt
Get-Content timing.txt
exit 0
