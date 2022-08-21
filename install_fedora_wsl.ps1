Param(
    [Parameter(Mandatory = $True)]
    [String] $Name,

    [Parameter(Mandatory = $True)]
    [String] $DistroInstallDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function CheckLastExitCode([int[]] $SuccessCodes = @(0)) {
    if ($SuccessCodes -notcontains $LastExitCode) {
        $msg = @"
EXE RETURNED EXIT CODE $LastExitCode
CALLSTACK:$(Get-PSCallStack | Out-String)
"@
        throw $msg
    }
}

$ContainerName = "docker_to_wsl_$Name"
docker build -t $ContainerName --progress plain .; CheckLastExitCode

try {
    docker run -it --name "$ContainerName" "$ContainerName"; CheckLastExitCode
    $TarFile = Join-Path $DistroInstallDir "wsl_distro.tar"
    docker export -o "$TarFile" "$ContainerName"; CheckLastExitCode
}
finally {
    docker rm "$ContainerName"; CheckLastExitCode
}

wsl --import "$Name" "$DistroInstallDir" "$TarFile"; CheckLastExitCode
