# IBM Bob AI Copilot - Java Liberty Replatforming Lab Guide
## Simple Pharmacy Dashboard - WebSphere to Liberty Migration

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Java Modernization Workflow](#java-modernization-workflow)
4. [Step-by-Step Exercises](#step-by-step-exercises)
5. [Troubleshooting](#troubleshooting)
6. [Conclusion](#conclusion)

---

# Introduction

### What is This Application?

The **Simple Pharmacy Management System** is a web-based application designed to manage pharmacy operations including:
- **Prescriptions**: Create and validate patient prescriptions
- **Orders**: Process medication orders and payments
- **Medicines**: Manage medicine inventory
- **Dashboard**: Monitor pending prescriptions and orders

### What is Java Modernization?

Java Modernization is the process of upgrading legacy Java applications to modern versions and platforms. This typically involves:
- **Java Version Upgrade**: Moving from older Java versions (like Java 8) to newer LTS versions (like Java 21)
- **Application Server Migration**: Transitioning from traditional servers (like WebSphere) to lightweight runtimes (like Liberty)
- **Dependency Updates**: Modernizing libraries and frameworks to current, supported versions
- **Code Transformation**: Updating code patterns to leverage modern Java features

## About This Lab

In this lab, you'll use IBM Bob's **Java Modernization mode** to modernize a legacy pharmacy management application. The application currently runs on:
- **Application Server**: WebSphere Application Server (TWas)

You'll modernize it to:
- **Application Server**: Liberty Application Server

## Learning Objectives

By completing this lab, you will use Bob to:
- Walkthrough the Java Modernization workflow which invloves
   - Analyzing legacy Java applications
   - Executing automated modernization transformations
   - Verifying and testing modernized applications

---

# Prerequisites

## Required Software

Before starting this lab, ensure you have:

- **IBM Bob IDE** - Latest version installed and logged in
- **Java 8+** - JDK 8 or higher
- **Maven 3.6+** - Build automation tool

**Don't have these installed?** See the [automated installation scripts](../../GETTING_STARTED.md#-quick-start-5-minutes) in GETTING_STARTED.md to install all dependencies quickly.

**Switching to Java 8 (if needed):**

If you have multiple Java versions installed and need to switch to Java 8 for this lab:

```bash
# Using SDKMAN (if installed via automated script)
sdk use java 8.0.492-zulu

# Verify
java -version
```

---

# Java Modernization Workflow

## Overview of Bob's Java Modernization Mode

IBM Bob's Java Modernization mode follows a structured workflow:

* **Analyze**
   * Bob analyzes your Java project and allows you to select a modernization type (Liberty Replatforming or Java Upgrade)
* **Upgrade**
   * Bob performs agentic upgrade of your Java prohject accoridng to the selected modernization type
* **Validate**
   * Bob validates your project's migration

## Auto-Approval Settings
You can control what Bob does automatically:
- **Read**: Let Bob read files without asking
- **Write**: Let Bob modify files without asking
- **Execute**: Let Bob run commands without asking
- **Todo**: Let Bob create task lists without asking

**Tip for Users:** Start with only "Read" enabled until you're comfortable!

---

# Step-by-Step Exercises

## Exercise 1: Open the Project & Activate Java Modernization Mode


1. Launch your IDE with IBM Bob installed

2. Open the ```1_Java_Liberty_Replatforming``` project folder

3. If the Bob Chat window is not already open, select the Bob icon at the to the right of the search bar at the top of your IDE.

4. At the bottom of the chat, you'll see the current mode (e.g., "💻 Code" or "❓ Ask"). Click on the current mode name at the bottom of the chat.

5. Select "☕ Java Modernization" from the dropdown menu. You should now be in Java Modernization mode, ready to begin the modernization process. Java modernization Workflows should also be an option if you want to click into that workflow.

---

## Exercise 2: Initiate the Java Modernization workflow

### Objective
Have Bob use the Java Modernization worklfow to analyze your current application, use a migration plan to upgrade the application, and validate the application post-upgrade.

### Steps

1. **Start the Workflow**
   
   * In the Bob chat window, you will see the **Java Modernization** workflow under **Workflows**. Selcet the **Start** button on the workflow to have Bob begin the Java modernization flow.

2. **Analyze**

   * **1.1 Analyze Java Project**
      
      Copy and Paste into the Project Path where your folder is located:
      ```
      bobathon/Bobathon/labs/lab1-java-liberty-replatforming/snapA-java-liberty-replatforming
      ```

   * **1.2 Select Java modernization type**
   
      Select **Liberty Replatforming** for modernization type. Toggle **Git Flow** off.

3. **Upgrade**

   a. **Liberty Replatforming**
   
   * **2.0 Run Liberty Modernization Analysis**

      Provide the path to the Application modernization Accelerator Deployment Plan ZIP file (**simple-pharmacy.war_migrationPlan.zip**) and select **Analyze Liberty Migration**. Bob will analyze the plan and create a Todo List for modernization.

   * **2.1 Run Liberty Re-Platforming recipes**

      Click **Run Recipes** to upgrade your Java code for Liberty


   * **2.2 Perform agentic upgrade**

      Bob will proceed with the upgrade task involving several subtasks. Bob will create a to do list(s) and complete tasks agentically, while also allowing user intervention and approvals.


3. **Validate**

   Select the option for Bob to Validate and/or Deploy your application

4. **Optional: Run the application**
   Prompt Bob to run the Simple Pharmacy application. Follow the URL the Bob provides to view the UI of the local application.


---

# Troubleshooting

## Issue 1: Maven Not Found After Installation

**Symptom:**
```
mvn: command not found
```

**Solution:**
1. Verify SDKMAN! installation: `sdk version`
2. Reinstall Maven: `sdk install maven`
3. **Restart your IDE/Bob completely**
4. Open new terminal and verify: `mvn --version`


## Issue 2: Bob Can't Read Project Files

**Symptom:**
Bob says "I cannot access that file" or "File not found"

**Solution:**
1. Verify you're in the correct directory
2. Check file permissions: `ls -la`
3. Ensure Bob has read access to the workspace
4. Try referencing files with `@filename` syntax

## Issue 3: Error: Unable to access jarfile when providing AMA zip file path in Liberty Modernization

**Symptom:**
```
Error: Unable to access jarfile /Applications/IBM Bob.app/Contents/Resources/app/extensions/bob-code/assets/jars/ta-jam-2.2.1.jar
```

**Solution:**
1. Create a ```jars``` folder in your Bob application folder, in your Applications folder(```/Applications/IBM Bob.app/Contents/Resources/app/extensions/bob-code/assets```)
2. Add the ```ta-jam-2.2.1.jar``` and ```prompt-lib-2.2.0.jar``` files using the following file structure
   ```
   ├── jars/
   │   └── prompt-lib/
   │       ├── prompt-lib-2.2.0.jar/
   │   └── ta-jam-2.2.1.jar
   ```
3. Close and restart Bob

   **Caution:** Make sure Bob is not running from /Volumes (mounted .dmg). Move the IBM BoB app to the /Applications folder and run it from there; otherwise it will not be allowed to create folders or place .jar files.

## Issue 4: Outdated bash Version on MacOS

If you run into problems regarding Mac having an old version of bash, you can install a newer version of bash using Homebrew:

**Solution:**
```bash
brew install bash

# Now run modified install command
curl -s "https://get.sdkman.io" | /opt/homebrew/bin/bash # or wherever you have the new version of bash installed
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

---
## Getting Help

### During the Lab
1. **Check Troubleshooting Section** - Most common issues are covered
2. **Ask Bob** - Bob can help explain errors and suggest fixes
3. **Ask Your Instructor** - Don't hesitate to raise your hand
4. **Collaborate** - Discuss with classmates 

---

# Conclusion

Congratulations! You've completed the Java Modernization lab. You should now be able to:

✅ Set up prerequisites (SDKMAN!, Maven)  
✅ Use Bob's Java Modernization mode to analyze and upgrade the Pharmacy application and validate its modeernization

---