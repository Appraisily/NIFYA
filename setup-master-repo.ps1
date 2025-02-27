# PowerShell script to set up the NIFYA-Master repository with submodules
# This script will prompt for GitHub URLs for each service repository

# Function to prompt for URL with a default value
function Get-RepoUrl {
    param (
        [string]$serviceName,
        [string]$defaultOrg = "nifyacorp"
    )
    
    $defaultUrl = "https://github.com/$defaultOrg/$serviceName.git"
    $promptMessage = "Enter GitHub URL for $serviceName [default: $defaultUrl]"
    
    $url = Read-Host -Prompt $promptMessage
    
    if ([string]::IsNullOrWhiteSpace($url)) {
        return $defaultUrl
    }
    
    return $url
}

# Make sure we're in the workspace root
cd $PSScriptRoot

# Check if NIFYA-Master exists and is a git repo
if (-not (Test-Path -Path "NIFYA-Master/.git")) {
    Write-Host "Setting up NIFYA-Master repository..."
    
    # Create NIFYA-Master if it doesn't exist
    if (-not (Test-Path -Path "NIFYA-Master")) {
        mkdir NIFYA-Master
    }
    
    # Initialize Git repository
    cd NIFYA-Master
    git init
    
    # Create a README.md
    @"
# NIFYA Master Repository

This is a master repository that contains all NIFYA services as Git submodules.

## Services

The following services are included as submodules:

- Authentication-Service
- email-notification
- doga-parser
- boe-parser
- backend
- subscription-worker

## Working with Submodules

To clone this repository with all submodules:

```bash
git clone --recursive <repository-url>
```

To update all submodules:

```bash
git submodule update --remote --merge
```

To learn more about Git submodules, visit [Git's documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
"@ | Out-File -FilePath "README.md" -Encoding utf8
    
    # Commit the README
    git add README.md
    git commit -m "Initial commit with README"
    
    # Return to workspace root
    cd ..
}
else {
    Write-Host "NIFYA-Master repository already exists"
}

# Change to NIFYA-Master directory
cd NIFYA-Master

# Service names
$services = @(
    "Authentication-Service",
    "email-notification",
    "doga-parser",
    "boe-parser",
    "backend",
    "subscription-worker"
)

# Add each service as a submodule
foreach ($service in $services) {
    Write-Host "`n========================================"
    Write-Host "Setting up $service"
    Write-Host "========================================`n"
    
    if (-not (Test-Path -Path "$service")) {
        $repoUrl = Get-RepoUrl -serviceName $service
        
        Write-Host "Adding $service as a submodule from $repoUrl"
        git submodule add $repoUrl $service
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Warning: Failed to add $service as a submodule. You may need to add it manually later."
        }
    }
    else {
        Write-Host "$service directory already exists, skipping"
    }
}

# Commit the .gitmodules file if submodules were added
if (Test-Path -Path ".gitmodules") {
    git add .gitmodules
    git commit -m "Add service submodules"
}

Write-Host "`n========================================"
Write-Host "Setup complete!"
Write-Host "========================================`n"

Write-Host "Next steps:"
Write-Host "1. Push the NIFYA-Master repository to GitHub"
Write-Host "2. Clone it on other machines using: git clone --recursive <repository-url>"
Write-Host "3. When you need to update submodules, run: git submodule update --remote --merge" 