# NIFYA Project Workspace

This repository serves as a workspace index for all NIFYA services.

## Services

- [Authentication Service](./Authentication-Service) - User authentication and authorization
- [Email Notification](./email-notification) - Handles email notifications
- [DOGA Parser](./doga-parser) - Parses DOGA data
- [BOE Parser](./boe-parser) - Parses BOE data
- [Backend](./backend) - Main API backend
- [Notification Worker](./notification-worker) - Background notification processing

## Working with Independent Repositories

Each service directory is an independent repository with its own Git history. When working with these repositories, remember:

1. Each service directory is a standalone repository
2. Changes made in one service do not affect the others
3. Each service has its own version control, issues, and pull requests

## Best Practices for Managing Multiple Repositories

### Option 1: Clone repositories individually

```bash
# Clone each repository separately
git clone <repository-url> <directory-name>
```

### Option 2: Use GitHub CLI to clone multiple repositories

If you have the GitHub CLI installed, you can script cloning multiple repositories:

```bash
# Example script to clone all repositories
gh repo clone <username>/Authentication-Service
gh repo clone <username>/email-notification
gh repo clone <username>/doga-parser
gh repo clone <username>/boe-parser
gh repo clone <username>/backend
gh repo clone <username>/notification-worker
```

### Option 3: For future projects, consider Git Submodules

For new projects where you want to track multiple repositories together, Git Submodules can be a good solution:

```bash
# Create a new master repository
mkdir project-master
cd project-master
git init

# Add each service repository as a submodule
git submodule add <URL-to-repo1> repo1
git submodule add <URL-to-repo2> repo2

# Commit the changes to the master repository
git commit -m "Add service submodules"
```

## Service Architecture Overview

```
+-------------------+       +-------------------+
|                   |       |                   |
| Authentication    |<----->| Backend           |
| Service           |       | API               |
|                   |       |                   |
+-------------------+       +-------------------+
                                     ^
                                     |
                                     v
+-------------------+       +-------------------+
|                   |       |                   |
| DOGA Parser       |<----->| Notification      |
| BOE Parser        |       | Worker            |
|                   |       |                   |
+-------------------+       +-------------------+
                                     ^
                                     |
                                     v
                            +-------------------+
                            |                   |
                            | Email             |
                            | Notification      |
                            |                   |
                            +-------------------+
```

## Development Guidelines

1. **Consistent Versioning**: Use semantic versioning across all services
2. **Documentation**: Each service should have its own README.md with setup instructions
3. **Testing**: Include unit and integration tests for each service
4. **CI/CD**: Configure GitHub Actions workflows for each repository
5. **Dependency Management**: Keep track of dependencies between services 