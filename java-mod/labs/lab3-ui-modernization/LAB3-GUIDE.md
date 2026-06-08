# IBM Bob AI Copilot - Frontend Modernization Lab Guide
## Simple Pharmacy Dashboard - Struts to Angular Migration

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Frontend Migration with Bob's Advanced Mode](#frontend-migration-with-bobs-advanced-mode)
4. [Step-by-Step Exercises](#step-by-step-exercises)
5. [Troubleshooting](#troubleshooting)
6. [Conclusion](#conclusion)

---

# Introduction

### What is Frontend Modernization?

Frontend Modernization is the process of upgrading or migrating frontend applications to modern frameworks and patterns. This typically involves:
- **Framework Migration**: Moving from one framework (like Struts) to another (like Angular)
- **Architecture Updates**: Implementing modern patterns and best practices
- **Dependency Updates**: Modernizing libraries and tooling to current versions
- **Code Transformation**: Adapting components, services, and state management to the new framework

## About This Lab

In this lab, you'll use IBM Bob's **Advanced mode** to migrate a pharmacy management application's frontend from Struts to Angular. The application currently uses:
- **Frontend Framework**: Struts

You'll migrate it to:
- **Frontend Framework**: Angular 19 (standalone components)


## Learning Objectives

By completing this lab, you will learn how to use Bob's Advanced mode to:
- Analyze existing Struts applications and plan migrations
- Create Angular project structure with modern patterns
- Migrate Struts components to Angular standalone components
- Test and validate the migrated application

---

# Prerequisites

## Required Software

Before starting this lab, ensure you have:

- **IBM Bob IDE** - Latest version installed and logged in with **Advanced mode** access
- **Java 21** - JDK 21 LTS (for backend API)
- **Maven 3.6+** - Build automation tool (for backend API)
- **Node.js 18+** - JavaScript runtime
- **Angular CLI** - Angular development tools

**Don't have these installed?** See the [automated installation scripts](../../GETTING_STARTED.md#-quick-start-5-minutes) in GETTING_STARTED.md to install all dependencies quickly.

**Switching to Java 21 (if needed):**

If you have multiple Java versions installed and need to switch to Java 21:

```bash
# Using SDKMAN (if installed via automated script)
sdk use java 21-tem

# Verify
java -version
```

**To access Advanced mode:**
1. Open Bob's chat interface
2. Click on the current mode indicator at the bottom
3. Select "🚀 Advanced" from the mode dropdown
4. Confirm you want to switch to Advanced mode

---

# Frontend Migration with Bob's Advanced Mode

## Overview of Bob's Advanced Mode for Frontend Migration

IBM Bob's Advanced mode provides powerful capabilities for framework migrations:

### Key Features for Migration:
1. **Intelligent Analysis**: Bob can analyze the Struts codebase, examining component structure, state management, routing, API integration, and styling approaches. This comprehensive analysis provides insight into the application's architecture for the migration task.

2. **Migration Planning**: Bob creates a detailed migration plan that maps Struts components to Angular equivalents and designs service architecture, routing strategy, and dependency management. The plan also includes a comprehensive testing approach to ensure successful migration.

3. **Automated Code Generation**: Bob generates Angular code including standalone components with TypeScript, services with RxJS observables, and models/interfaces. It also creates routing configuration and module setup for the complete application structure.

4. **Iterative Refinement**: Bob works with you to reeview generated code, make adjustments based on your feedback, and debug any issues or errors

---

# Step-by-Step Exercises

1. **Open Bob Chat Interface**
   - If the Bob Chat window is not already open, click the Bob icon in your IDE's sidebar

2. **Switch to Bob's Advanced Mode**
   - Click on the current mode name at the bottom of the chat
   - Select "🚀 Advanced" from the dropdown menu
   - Confirm the mode switch if prompted

3. **Use Bob to initiate migration**
   
   In Bob's chat, type:
   ```
   I want to migrate this Struts application to utilize an Angular framework. Help me execute this migration. Create the frontend UI.
   ```

4. Bob will walk you through and complete the migration process, allowing you to approve tasks. Along the way, you can and should prompt Bob with specific questions or requests to guide the migration process. These can include:
   - Asking Bob to troubleshoot errors
   - Requesting specific code changes
   - Asking for clarification on migration steps
etc.


5. **Use Bob for testing**

   Once the application the is migrated to Angular, if not already suggested to do so, ask Bob to test the application by running it with the prompt:
   ```
   Help me run the migrated Angular application
   ```


### Expected Outcome
- Fully functional Angular application
- All features working correctly
- Optimized performance
- Clean, maintainable code
- Complete documentation

---

# Troubleshooting

## Issue 1: API Request Failed

**Symptom:**
```
{"apiProtocol":"openai"}
```

**Solution:**
Select "Retry" in the Bob chat window

---

## Issue 2: Backend Connection Issues

**Symptom:**
The Angular frontend cannot connect to the backend API. You may see errors like:
- `HTTP Error: Connection refused`
- `Failed to load resource: net::ERR_CONNECTION_REFUSED`
- `CORS policy error`
- API calls returning 404 or timeout errors

**Root Cause:**
The Angular application is configured to connect to `http://localhost:9081/simple-pharmacy.war/api` in the `pharmacy-api.service.ts` file, but the backend server may not be running on this port or path.

**Solutions:**

### Solution A: Verify Backend Server is Running

1. **Check if the Liberty server is running:**
   ```bash
   # Navigate to the backend directory
   cd Bobathon/labs/lab3-ui-modernization/snapC-ui-mod
   
   # Check if Maven/Liberty server is running
   mvn liberty:status
   ```

2. **Start the backend server if not running:**
   ```bash
   # Start the Liberty server
   mvn liberty:run
   ```
   
   Wait until you see a message indicating the server has started successfully (typically shows "server is ready to run a smarter planet").

3. **Verify the backend is accessible:**
   Open a browser or use curl to test:
   ```bash
   curl http://localhost:9081/simple-pharmacy.war/api/dashboard
   ```
   
   You should receive a JSON response with dashboard data.

### Solution B: Update Frontend API Configuration

If your backend is running on a different port or path, update the API URL in the Angular service:

1. **Open the pharmacy API service file:**
   ```
   Bobathon/labs/lab3-ui-modernization/snapC-ui-mod/src/main/frontend/src/app/services/pharmacy-api.service.ts
   ```

2. **Update the `apiUrl` property (line 53):**
   ```typescript
   // Change from:
   private apiUrl = 'http://localhost:9081/simple-pharmacy.war/api';
   
   // To match your backend configuration, for example:
   private apiUrl = 'http://localhost:9080/simple-pharmacy/api';
   // or
   private apiUrl = 'http://localhost:8080/api';
   ```

3. **Restart the Angular development server:**
   ```bash
   # Stop the current server (Ctrl+C)
   # Then restart
   cd src/main/frontend
   npm start
   ```

### Solution C: Configure CORS (if needed)

If you see CORS-related errors, ensure the backend CORS filter is properly configured:

1. **Verify CORS filter exists:**
   Check `src/main/java/com/pharmacy/api/CorsFilter.java`

2. **Ensure CORS headers allow your frontend origin:**
   The filter should include:
   ```java
   response.setHeader("Access-Control-Allow-Origin", "*");
   response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
   response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
   ```

3. **Restart the backend server** after any CORS configuration changes.

### Solution D: Use Angular Proxy Configuration (Alternative)

If you want to avoid CORS issues during development, configure an Angular proxy:

1. **Create a proxy configuration file:**
   Create `src/main/frontend/proxy.conf.json`:
   ```json
   {
     "/api": {
       "target": "http://localhost:9081/simple-pharmacy.war",
       "secure": false,
       "changeOrigin": true
     }
   }
   ```

2. **Update the API service to use relative URLs:**
   In `pharmacy-api.service.ts`:
   ```typescript
   private apiUrl = '/api';
   ```

3. **Start Angular with proxy:**
   ```bash
   ng serve --proxy-config proxy.conf.json
   ```

### Verification Steps

After applying any solution:

1. **Check browser console** (F12) for any remaining errors
2. **Test API endpoints** by navigating through the application
3. **Verify data loads** on the dashboard, medicines, prescriptions, and orders pages

---

## Getting Help

### During the Lab
1. **Ask Bob** - Bob can help explain errors and suggest fixes
2. **Ask Your Instructor** - Don't hesitate to raise your hand
3. **Collaborate** - Discuss with classmates

### Bob-Specific Tips
- Be specific in your requests to Bob
- Provide error messages in full
- Ask Bob to explain its reasoning
- Request step-by-step guidance for complex tasks
- Use Bob to review code before testing

---

# Conclusion

Congratulations! You've completed the Frontend Modernization lab using Bob's Advanced mode. You should now be able to:

Use Bob's Advanced mode for complex migration tasks including  
   ✅ Analyzing Struts applications and creating migration plans  
   ✅ Migrating Struts components to Angular standalone components  
   ✅ Testing and validating migrated applications  

## Key Takeaways

1. **Bob's Advanced Mode** provides powerful capabilities for framework migrations
2. **Structured Approach** - Following a phased migration plan ensures success
3. **Component Mapping** - Understanding how Struts patterns translate to Angular
4. **TypeScript Benefits** - Strong typing catches errors early
5. **Angular Ecosystem** - Material Design and RxJS provide robust solutions

## Next Steps (Optional)

> **Note:** The following activities are optional and can be explored if you have additional time or want to deepen your understanding of the concepts covered in this lab.

Consider exploring the following tasks using Bob:

1. **Performance Optimization**
   
   Ask Bob:
   ```
   Optimize the Angular application
   ```

2. **Code Quality Review**
   
   Ask Bob:
   ```
   Review the migrated code for:
   - Angular style guide compliance
   - Proper error handling
   - Code organization
   - Documentation completeness
   ```

3. **Create Migration Summary**
   
   Ask Bob:
   ```
   Create a MIGRATION_SUMMARY.md document that includes:
   - What was migrated
   - Key architectural changes
   - New features or improvements
   - Known issues or limitations
   - Next steps or recommendations
   ```

---

**Thank you for completing this lab!** You've successfully used IBM Bob to migrate a Struts application to Angular. This experience demonstrates how Bob can accelerate complex modernization projects while maintaining code quality and best practices.
