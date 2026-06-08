# Life Insurance and Annuities Process Creation - Bob-Guided Lab

## Overview

This lab guides you through using **Bob** to extract business processes and business objects from a business blueprint document, then package and deploy them to IBM Business Automation Workflow (BAW). You'll learn to interact with Bob's Blueprint Parser mode to automatically generate BPMN workflows and business object definitions from unstructured documents.

**What You'll Create:**
1. **Business Objects** - Structured data models for life insurance operations
2. **Business Processes** - BPMN workflows for policy and annuity management
3. **Process Package** - Importable ZIP file for BAW deployment

**Estimated Time:** 30-45 minutes

---

## Set Up


### Required VS Code Extensions

Before starting the lab, install these VS Code extension to visualize and validate the generated artifacts:
- **Markdown Preview Mermaid Support** - Allows you to visualize process flows directly in VS Code
- **Kogito Bundle** - Provides visual BPMN 2.0 editor, validates BPMN syntax and structure
- **Simple OpenAPI Viewer** - Renders OpenAPI specifications in a readable format

**How to install:**
1. Open VS Code Extensions panel (Ctrl+Shift+X / Cmd+Shift+X)
2. Search for the extension name
3. Click **Install**

### Import Life Insurance and Annuities Blueprint Document

1. Download the provided blueprint document: `LifeInsuranceAndAnnuities-2.pdf`
2. Drag and drop the PDF file into the folder Labs/process-creation/

**Note:** If you don't have the document, you can request it from your instructor.




---

## Lab Instructions

### Part 1: Parse Blueprint Document

**Initial Setup:**
- Ensure Bob is in BAW Blueprint Parser mode or instruct Bob: `Switch to BAW Blueprint Parser mode`
- Verify the blueprint document is located at: `Labs/process-creation/LifeInsuranceAndAnnuities-2.pdf`

**Prompt to Bob:**

```
Parse @/Labs/process-creation/LifeInsuranceAndAnnuities-2.pdf end to end for context `LifeInsuranceAndAnnuities`
and generate all supported Blueprint Parser artifacts.
This document contains processesfor annuity purchase, policy application and purchase, and policy replacement.
```

**What This Does:**
- Extracts text from the PDF document
- Identifies business entities and their properties
- Generates JSON business object definitions
- Creates OpenAPI specification for REST APIs
- Generates business object catalogs
- Produces a discovery report documenting decisions


---

### Part 2: Extract Business Processes

**Initial Setup:**
- Ensure Bob is still in BAW Blueprint Parser mode

**Prompt to Bob:**

```
Extract business processes from the LifeInsuranceAndAnnuities blueprint.
Identify and generate BPMN workflows for the following processes:
 (1) Policy Application and Purchase;
 (2) Policy Replacement;
 (3) Annuity Purchase.
```

**What This Does:**
- Analyzes the blueprint for workflow patterns
- Identifies process steps and decision points
- Generates BPMN configuration files
- Creates BPMN XML files in two formats:
  - IBM BAW format (with extensions)
  - Standard BPMN 2.0 format (for preview)
- Generates process catalogs



### Part 3: Validate Everything

**Initial Setup:**
- Ensure Bob is still in BAW Blueprint Parser mode

**Prompt to Bob:**

```
Perform complete analysis of the LifeInsuranceAndAnnuities blueprint.
```

**What This Does:**
- Validates business object structure and relationships
- Validates BPMN process definitions
- Checks for consistency between objects and processes
- Generates comprehensive analysis report
- Identifies any gaps or issues


---

### Part 4: Create Process Import Package


**Prompt to Bob:**

```
Create a zip file in output/ named LifeInsuranceAndAnnuities-ProcessApp.zip
containing the generated BPMN files.
```

**What This Does:**
- Creates a folder with all BPMN files
- Packages everything into a ZIP file that can be imported to BAW



---

## Importing Processes into BAW

### Step 1: Import BPMN Processes

1. **Open BAW Business Automations**
   - Navigate to your BAW server URL
   - Log in with your credentials
   - Navigate to **Business Automations** → **Workflow**

2. **Import a new Workflow**
   - Click **"Import"**
   - Drag and drop or browse for the zip file generated in the previous step: `output/LifeInsuranceAndAnnuities-ProcessApp.zip`
   - Click **"Import"**
   - Wait for the import to complete, then click **Done**

### Step 2: View the Imported Processes in BAW

1. Open the newly imported workflow
2. Navigate to the **Processes** tab
3. Click on the process to view its BPMN diagram


---

## Key Takeaways

**1. Blueprint Parser Automates Extraction**
- Transforms PDF documents into structured business objects and BPMN processes
- Generates 10+ business objects and multiple workflows in minutes vs. days of manual work
- Includes regulatory compliance checkpoints automatically
- Produces dual BPMN formats (IBM BAW + Standard BPMN 2.0)

**2. Structured Artifacts Enable Reusability**
- Context-based organization keeps related artifacts together
- Business objects use consistent namespace patterns
- BPMN configs are JSON-based and version-controllable
- OpenAPI specs document all business objects as REST APIs

**3. Automation Saves Time**
- Complete workflow (Parse → Extract → Validate → Package → Deploy) in 30-45 minutes
- Repeatable for different business domains
- Consistent artifact structure across projects
- Self-documenting through catalogs and reports
