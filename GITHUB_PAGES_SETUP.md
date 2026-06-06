# GitHub Pages Setup Guide

## How to Enable GitHub Pages for Bob Week Website

Follow these step-by-step instructions to deploy your Bob Week website using GitHub Pages:

### Prerequisites
- You need **admin** or **write** access to the repository
- The website files (index.html, styles.css, script.js) must be committed to the repository

---

## Step-by-Step Instructions

### Step 1: Navigate to Repository Settings
1. Go to the repository: https://github.com/ibmcvsh/Bob-week
2. Click on the **"Settings"** tab (located in the top navigation bar, after "Insights")
   - If you don't see the Settings tab, you don't have the required permissions. Contact the repository owner.

### Step 2: Find Pages Section
1. In the left sidebar of Settings, scroll down to find **"Pages"** under the "Code and automation" section
2. Click on **"Pages"**

### Step 3: Configure GitHub Pages
1. Under **"Source"**, you'll see a dropdown that says "None"
2. Click the dropdown and select **"Deploy from a branch"**
3. Under **"Branch"**, select:
   - Branch: **main** (or master, depending on your default branch)
   - Folder: **/ (root)**
4. Click **"Save"**

### Step 4: Wait for Deployment
1. GitHub will start building your site (this takes 1-2 minutes)
2. Refresh the page after a minute
3. You'll see a message at the top: **"Your site is live at https://ibmcvsh.github.io/Bob-week/"**

### Step 5: Access Your Website
- Your website will be available at: **https://ibmcvsh.github.io/Bob-week/**
- It may take a few minutes for the site to be fully deployed

---

## Visual Guide

Here's what you're looking for:

```
Repository Navigation Bar:
[Code] [Issues] [Pull requests] [Actions] [Projects] [Security] [Insights] [Settings] ← Click here
```

```
Settings Sidebar (scroll down to find):
├── General
├── Access
│   ├── Collaborators
│   └── Moderation options
├── Code and automation
│   ├── Branches
│   ├── Tags
│   ├── Actions
│   ├── Webhooks
│   ├── Environments
│   └── Pages ← Click here
```

```
Pages Configuration:
┌─────────────────────────────────────────┐
│ GitHub Pages                             │
├─────────────────────────────────────────┤
│ Source                                   │
│ ┌─────────────────────────────────────┐ │
│ │ Deploy from a branch            ▼   │ │
│ └─────────────────────────────────────┘ │
│                                          │
│ Branch                                   │
│ ┌──────────┐  ┌──────────┐             │
│ │ main  ▼  │  │ /(root) ▼│  [Save]     │
│ └──────────┘  └──────────┘             │
└─────────────────────────────────────────┘
```

---

## Troubleshooting

### "I don't see the Settings tab"
- You need admin or write access to the repository
- Contact the repository owner (ibmcvsh organization admin) to grant you access

### "The site shows 404 error"
- Make sure `index.html` is in the root directory of the repository
- Wait a few minutes after enabling Pages for the site to build
- Check that the branch you selected has the website files

### "Changes aren't showing up"
- GitHub Pages caches content. It may take 5-10 minutes for changes to appear
- Try clearing your browser cache or using incognito mode
- You can force a rebuild by making a small commit (like updating README.md)

### "Custom domain setup"
If you want to use a custom domain:
1. In the Pages settings, find the "Custom domain" section
2. Enter your domain (e.g., bobweek.example.com)
3. Add the required DNS records at your domain provider
4. Wait for DNS propagation (can take up to 48 hours)

---

## Alternative: Using GitHub Actions

If you want more control over the deployment, you can use GitHub Actions:

1. Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./
```

2. Commit and push this file
3. The site will automatically deploy on every push to main

---

## Quick Reference

| Setting | Value |
|---------|-------|
| Repository | https://github.com/ibmcvsh/Bob-week |
| Settings URL | https://github.com/ibmcvsh/Bob-week/settings/pages |
| Source | Deploy from a branch |
| Branch | main |
| Folder | / (root) |
| Website URL | https://ibmcvsh.github.io/Bob-week/ |

---

## Need Help?

If you're still having trouble:
1. Check GitHub's official documentation: https://docs.github.com/en/pages
2. Contact the repository administrator for access
3. Verify all files are committed to the main branch

---

**Note**: The website files (index.html, styles.css, script.js, README.md) are already created and ready to deploy. You just need to enable GitHub Pages in the repository settings!