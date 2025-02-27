# NIFYA-Master Approach Guide

This guide explains how to work with the NIFYA-Master repository, which uses Git submodules to manage multiple service repositories.

## Setting Up NIFYA-Master

We've provided two scripts to help you set up the NIFYA-Master repository:

- `setup-master-repo.ps1` - For Windows users (PowerShell)
- `setup-master-repo.sh` - For Linux/Mac users (Bash)

### Running the Setup Script

#### On Windows:
```powershell
.\setup-master-repo.ps1
```

#### On Linux/Mac:
```bash
chmod +x setup-master-repo.sh
./setup-master-repo.sh
```

The script will:
1. Create a NIFYA-Master directory if it doesn't exist
2. Initialize it as a Git repository
3. Create a README.md file
4. Prompt you for the GitHub URL for each service
5. Add each service as a submodule
6. Commit the changes

## Understanding Git Submodules

Git submodules allow you to include other Git repositories within your repository. This means:

- Each service maintains its own complete Git history
- Changes to one service don't affect the others
- The master repository only tracks which commit of each service to use

## Common Submodule Operations

### Cloning a Repository with Submodules

When you clone the NIFYA-Master repository for the first time, use:

```bash
git clone --recursive https://github.com/nifyacorp/NIFYA-Master.git
```

This will clone the main repository and all submodules.

### If You Already Cloned Without `--recursive`

If you already cloned the repository without the `--recursive` flag:

```bash
git submodule init
git submodule update
```

### Updating All Submodules

To update all submodules to their latest versions:

```bash
git submodule update --remote --merge
```

### Working on a Submodule

To work on a specific service:

1. Navigate to the submodule directory:
   ```bash
   cd Authentication-Service
   ```

2. Make your changes, commit, and push:
   ```bash
   git add .
   git commit -m "Your commit message"
   git push
   ```

3. Return to the master repository and update it to use the new commit:
   ```bash
   cd ..
   git add Authentication-Service
   git commit -m "Update Authentication-Service to latest version"
   git push
   ```

### Adding a New Submodule

To add a new service:

```bash
git submodule add https://github.com/nifyacorp/new-service.git new-service
git add .gitmodules new-service
git commit -m "Add new-service as submodule"
git push
```

### Removing a Submodule

To remove a service:

1. Remove the submodule from the configuration:
   ```bash
   git submodule deinit -f -- service-to-remove
   ```

2. Remove the submodule from the repository:
   ```bash
   git rm -f service-to-remove
   ```

3. Clean up the .git directory:
   ```bash
   rm -rf .git/modules/service-to-remove
   ```

4. Commit the changes:
   ```bash
   git commit -m "Remove service-to-remove submodule"
   ```

## Best Practices

1. **Always pull the latest changes** before working on a project:
   ```bash
   git pull
   git submodule update --remote --merge
   ```

2. **Commit submodule changes first** before committing to the master repository

3. **Use branches** in submodules for feature development

4. **Document dependencies between services** in the master repository README

5. **Prefer HTTPS URLs** for submodules to allow easier cloning by others

## Troubleshooting

### "Fatal: transport 'file' not allowed"

This error occurs when trying to add a local directory as a submodule. Instead, add the GitHub URL:

```bash
git submodule add https://github.com/nifyacorp/service-name.git service-name
```

### Submodules Appear Empty

If a submodule directory is empty, you may need to initialize and update it:

```bash
git submodule init
git submodule update
```

### Changes in Submodule Not Recognized by Master Repository

After making changes in a submodule, you need to commit those changes and then update the master repository to point to the new commit:

```bash
# In the submodule directory
git add .
git commit -m "Make changes"
git push

# In the master repository
cd ..
git add service-name
git commit -m "Update service-name"
git push
```

### Option 2: Use GitHub CLI to clone multiple repositories

If you have the GitHub CLI installed, you can script cloning multiple repositories:

```bash
# Example script to clone all repositories
gh repo clone nifyacorp/Authentication-Service
gh repo clone nifyacorp/email-notification
gh repo clone nifyacorp/doga-parser
gh repo clone nifyacorp/boe-parser
gh repo clone nifyacorp/backend
gh repo clone nifyacorp/subscription-worker
```

### Option 3: For future projects, consider Git Submodules

For new projects where you want to track multiple repositories together, Git Submodules can be a good solution:

```bash
# Create a new master repository
mkdir project-master
cd project-master
git init

# Add each service repository as a submodule
git submodule add https://github.com/nifyacorp/service-name.git service-name
git submodule add https://github.com/nifyacorp/another-service.git another-service

# Commit the changes to the master repository
git commit -m "Add service submodules"
``` 