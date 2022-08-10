#Set-ExecutionPolicy RemoteSigned

[string]$project_name = $( Convert-Path . | Split-Path -Leaf )
[string]$docker_image = "local/infra_builder:$project_name"

function prep
{
    if (-not(Test-Path -LiteralPath ./.home))
    {
        try
        {
            New-Item -Path "./.home" -ItemType Directory -ErrorAction Stop | Out-Null
            Write-Host -Message "Created .home directory. Run command to continue"
            exit
        }
        catch
        {
            Write-Error -Message "Unable to create directory './.home'. Error was: $_" -ErrorAction Stop
        }
    }
}

function build
{
    Push-Location ./tools
    docker build -t "$docker_image" .
    Pop-Location
}

function run_docker
{
    if ($args.Length -gt 0)
    {
        $cmd = $( $args[0..$args.Count] ) -join " "
    }
    else
    {
        $cmd = "bash"
    }
    [string]$ipaddr = (Get-NetIPAddress -AddressFamily IPV4 | Where-Object { ($_.AddressState -ne 'tentative') -and ($_.PrefixOrigin -ne 'WellKnown') } | Sort-Object -Property $_.InterfaceIndex | Select-Object -First 1).IPAddress
    [string]$exe = "docker run --rm -it --hostname $project_name -e HOSTIP=${ipaddr} -e ANSIBLE_CONFIG=./ansible.cfg -v ${PWD}:/mnt -p 8000-9000:8000-9000 $docker_image $cmd"
    Invoke-Expression $exe
}

$ErrorActionPreference = "Stop"
(prep | Out-Null); (build | Out-Null); run_docker $args