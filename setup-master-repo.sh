#!/bin/bash
# Bash script to set up the NIFYA-Master repository with submodules
# This script will prompt for GitHub URLs for each service repository

# Function to prompt for URL with a default value
get_repo_url() {
    service_name=$1
    default_org="nifyacorp"
    
    default_url="https://github.com/$default_org/$service_name.git"
    echo "Enter GitHub URL for $service_name [default: $default_url]"
    read url
    
    if [ -z "$url" ]; then
        echo $default_url
    else
        echo $url
    fi
}

# Make sure we're in the workspace root
cd "$(dirname "$0")"

# Check if NIFYA-Master exists and is a git repo
if [ ! -d "NIFYA-Master/.git" ]; then
    echo "Setting up NIFYA-Master repository..."
    
    # Create NIFYA-Master if it doesn't exist
    if [ ! -d "NIFYA-Master" ]; then
        mkdir NIFYA-Master
    fi
    
    # Initialize Git repository
    cd NIFYA-Master
    git init
    
    # Create a README.md
    cat > README.md << 'EOF'
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
EOF
    
    # Commit the README
    git add README.md
    git commit -m "Initial commit with README"
    
    # Return to workspace root
    cd ..
else
    echo "NIFYA-Master repository already exists"
fi

# Change to NIFYA-Master directory
cd NIFYA-Master

# Service names
services=(
    "Authentication-Service"
    "email-notification"
    "doga-parser"
    "boe-parser"
    "backend"
    "subscription-worker"
)

# Add each service as a submodule
for service in "${services[@]}"; do
    echo -e "\n========================================"
    echo "Setting up $service"
    echo -e "========================================\n"
    
    if [ ! -d "$service" ]; then
        repo_url=$(get_repo_url "$service")
        
        echo "Adding $service as a submodule from $repo_url"
        git submodule add "$repo_url" "$service"
        
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to add $service as a submodule. You may need to add it manually later."
        fi
    else
        echo "$service directory already exists, skipping"
    fi
done

# Commit the .gitmodules file if submodules were added
if [ -f ".gitmodules" ]; then
    git add .gitmodules
    git commit -m "Add service submodules"
fi

echo -e "\n========================================"
echo "Setup complete!"
echo -e "========================================\n"

echo "Next steps:"
echo "1. Push the NIFYA-Master repository to GitHub"
echo "2. Clone it on other machines using: git clone --recursive <repository-url>"
echo "3. When you need to update submodules, run: git submodule update --remote --merge" 