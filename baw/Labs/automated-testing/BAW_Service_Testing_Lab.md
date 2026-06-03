# BAW Service Testing with MCP and Skills - Hands-On Lab

## Lab Overview

### Introduction
This hands-on lab will cover automated testing of Business Automation Workflow (BAW) services using Bob's MCP (Model Context Protocol) integration and reusable skills. You'll learn to configure MCP servers, test services directly, and create comprehensive test skills.

### Prerequisites

Before starting this lab, you should have:

- IBM Business Automation Workflow v18.0+ with exposed REST services
- Access to a BAW environment with the LoanEligibility service
- BAW server credentials (username and password)

---

## Understanding the Technologies

### MCP (Model Context Protocol) Servers

**What is MCP?**

MCP (Model Context Protocol) is a standardized protocol that allows AI assistants like Bob to interact with external tools and services. MCP servers expose capabilities that Bob can use to perform actions beyond its built-in functionality.

**Key Concepts:**

- **MCP Server**: A service that exposes tools via the MCP protocol
- **MCP Tool**: A specific capability provided by an MCP server (e.g., calling a REST service)
- **Project-Level Configuration**: MCP servers configured specifically for your project
- **Global Configuration**: MCP servers available across all projects

### BAW Services MCP Server

The [IBM BAW MCP Server](https://github.com/ibmbpm/ibm-baw-mcp-server) is an IBM built and maintained server that provides access to IBM Business Automation Workflow REST services. It allows Bob to:

- Call BAW REST services directly
- Pass parameters and receive responses
- Handle authentication automatically
- Work with BAW business objects

### Bob Skills

**What are Skills?**

Skills are reusable YAML-based instructions that teach Bob how to perform complex, multi-step tasks. They're like recipes that Bob can follow repeatedly.

**Key Features:**

- **Reusable**: Write once, use many times
- **Structured**: Step-by-step instructions with clear objectives
- **Documented**: Self-documenting with descriptions and examples
- **Shareable**: Can be shared across teams and projects

**Skill Structure:**

```yaml
---
name: skill-name
description: What this skill does
---

Instructions for Bob to follow:

<Steps>
<Step>
First step description and actions
</Step>

<Step>
Second step description and actions
</Step>
</Steps>
```

### How They Work Together

```
┌─────────────────────────────────────────────────────────┐
│                    Your Request                          │
│         "Test the LoanEligibility service"              │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      Bob AI                              │
│  - Understands your request                             │
│  - Decides to use MCP tool or skill                     │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  MCP Server                              │
│  - Receives tool call from Bob                          │
│  - Calls BAW REST service                               │
│  - Returns response to Bob                              │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                 BAW Service                              │
│  - Processes request                                     │
│  - Returns business logic results                        │
└─────────────────────────────────────────────────────────┘
```

---

## Part 1: MCP Server Configuration

### Understanding Project-Level vs Global MCP

**Project-Level MCP Configuration:**
- Located in `.bob/mcp.json` in your project directory
- Only available when working in this project
- Ideal for project-specific services and tools
- Can include project-specific credentials and endpoints

**Global MCP Configuration:**
- Located in your user home directory
- Available across all projects
- Good for commonly used tools
- Shared credentials (use with caution)

**Best Practice**: Use project-level configuration for BAW services to keep credentials and endpoints project-specific.

### Step 1.1: Locating the project MCP config
There are two ways to add MCP servers to your project config file. The first is by editing the mcp.json file within your project's `.bob` directory. 

Directory Structure:
```
.bob/
├── mcp.json          # MCP server configuration
└── skills/           # Directory for reusable skills
    ├── skill.yaml
    └── skill.yaml
```

Alternatively you can navigate to the settings gear in the upper right hand corner of the Bob window.  

![Loaded Tools](/Labs/automated-testing/img/bob-settings.png) 

This will open Bob's settings menue where you can navigate to `MCP` followed by `Project MCPs`.  
Use your prefered method to navigate to the mcp.json file.

### Step 1.2: Connect to the IBM BAW MCP server

Here is the json defining the conenction to the BAW MCP server:
```json
{
    "mcpServers": {
        "baw-services": {
            "command":"uvx",
            "args":["--from","git+https://github.com/ibmbpm/ibm-baw-mcp-server.git","ibm-baw-mcp-server"],
            "env": {
                "ENDPOINT":"https://cpd-cp4ba.apps.itz-b1ednj.infra01-lb.wdc07.techzone.ibm.com/bas",
                "USERID":"usr",
                "PASSWORD":"password",
                "VERIFY_SSL":"false",
                "LOG_LEVEL":"INFO"
            },
            "alwaysAllow":["LA4_LoanEligibilityREST_LoanEligService"]
        }
    }
}
```
**Note:** If you connect to multiple servers you may have more than one server within the `mcpServers` object.  

Copy the connection config to your mcp.json and fill in the `PASSWORD` AND `USERID` fields with credentials provided to you by your instructors.

### Step 1.3: Understanding the BAW Services Configuration

Let's break down the `baw-services` configuration:

**Command and Arguments:**
```json
"command": "uvx",
"args": ["--from", "git+https://github.com/ibmbpm/ibm-baw-mcp-server.git", "ibm-baw-mcp-server"]
```

- `uvx`: Python tool runner (automatically installs and runs Python packages)
- `--from`: Specifies the package source
- `git+https://...`: Installs directly from GitHub repository
- `ibm-baw-mcp-server`: The package/command to run

**Environment Variables:**
```json
"env": {
  "ENDPOINT": "https://your-baw-server.com/bas",
  "USERID": "usr",
  "PASSWORD": "password",
  "VERIFY_SSL": "false",
  "LOG_LEVEL": "INFO"
}
```

- **ENDPOINT**: Base URL of your BAW server (without /rest)
- **USERID**: BAW username for authentication
- **PASSWORD**: BAW password
- **VERIFY_SSL**: Set to "false" for self-signed certificates
- **LOG_LEVEL**: Logging verbosity (DEBUG, INFO, WARNING, ERROR)

**Always Allow List:**
```json
"alwaysAllow": ["LA4_LoanEligibilityREST_LoanEligService"]
```

Tools in this list can be called without user confirmation by Bob, speeding up automated testing and reducing human in the loop interactions.

### Step 1.4: Verify MCP Server Connection

Now let's verify that Bob can connect to the BAW services MCP server. Navigate back to the MCP settings by clicking the gear icon in the upper right of the Bob Agent window.  <br>

**Verify:** The baw-services MCP server should be present and marked with a green dot representing a healthly connection.
![Valid MCP Connection](/Labs/automated-testing/img/valid-mcp.png)

To see the available tools in the baw-services server, click the coorisponding tile and locate the LoanEligibilityREST service. It should look like the below screenshot.
![Loaded Tools](/Labs/automated-testing/img/mcp-tools.png)

If you see an error, check:
- ✅ BAW server is accessible
- ✅ Credentials are correct
- ✅ ENDPOINT URL is correct (should end with `/bas`, not `/bas/rest`)
- ✅ Python and uvx are installed

---

## Part 2: Basic Service Testing

### Understanding the LoanEligibility Service

The LoanEligibility service evaluates loan applicants and is configured with the following input and outputs:

**Input Parameters:**
- `customerId` (integer): Unique customer identifier
- `monthlyIncome` (number): Customer's monthly income
- `creditScore` (integer): Credit score (300-850)
- `existingLiability` (number): Current debt obligations

**Outputs:**
- `eligibilityStatus` (string): "Eligible" or "Not Eligible"
- `eligibleAmount` (number): Maximum loan amount (if eligible)
- `riskCategory` (string): "Low" or "High" risk classification

### Step 2.1: Test with a High-Quality Applicant

Let's start with a straightforward test case - a high-quality applicant who should be eligible. <br>
*Switch Bob to 🛠️ Advanced Mode*

**Prompt to Bob:**
```
Use the baw-services MCP server to test the LoanEligibilityREST service with these parameters:
- customerId: 1001
- monthlyIncome: 15000
- creditScore: 800
- existingLiability: 2000

This represents a high-income customer with excellent credit.
```

**What Bob Will Do:**

1. Use the `use_mcp_tool` capability
2. Call `LA4_LoanEligibilityREST_LoanEligService`
3. Pass the parameters as JSON
4. Return the response

**Expected Response:**

```json
{
  "eligibilityStatus": "Eligible",
  "eligibleAmount": 300000.0,
  "riskCategory": "Low"
}
```

The response should look something like below:  
![Loan Service Call Good Applicant](/Labs/automated-testing/img/good-applicant.png)

### Step 2.2: Understanding the Response

Let's break down what the service returned:

**eligibilityStatus: "Eligible"**
- The customer meets the minimum requirements
- Primary factor: Credit score threshold

**eligibleAmount: 300000.0**
- Maximum loan amount the customer qualifies for
- Formula appears to be: `monthlyIncome × 20`
- Not adjusted for existing liability

**riskCategory: "Low"**
- Risk assessment based on credit score
- Binary classification: "Low" or "High"

### Step 2.3: Test an Ineligible Applicant

Now let's test with a customer who should be rejected. This time we will let bob decide the input parameters based only on our request.

**Prompt to Bob:**
```
Test the LoanEligibility service with a low credit score applicant.
```

**Expected Response:**

```json
{
  "eligibilityStatus": "Not Eligible",
  "eligibleAmount": null,
  "riskCategory": "High"
}
```

We can expect some variation here but your response might look like the following:
![Loan Service Call Bad Applicant](/Labs/automated-testing/img/bad-applicant.png)

**Analysis:**

- ❌ Customer is not eligible (due to a low credit score)
- ❌ No eligible amount (null)
- ⚠️ High risk classification

**Next:** Let's automate this testing with a reusable skill!

---

## Part 3: Creating a Reusable Skill

### Understanding Bob Skills

**Why Create Skills?**

Manual testing is great for exploration, but skills provide:

- **Repeatability**: Run the same tests consistently
- **Comprehensiveness**: Cover all scenarios systematically
- **Documentation**: Self-documenting test approach
- **Automation**: Execute high coverage tests with one command
- **Sharing**: Team members can use the same testing approach

### Step 3.1: Skill Structure Overview

A Bob skill consists of:

**Header:**
```yaml
---
name: skill-name
description: What this skill does
---
```

**Body:**
```
Instructions for Bob in natural language

<Steps>
<Step>
Detailed step 1
</Step>

<Step>
Detailed step 2
</Step>
</Steps>
```

**Key Points:**
- Written in YAML with markdown-style instructions
- Uses `<Steps>` and `<Step>` tags for structure
- Natural language instructions (not code)
- Can reference MCP tools, files, and other resources

### Step 3.2: Creating our skill

**Before entering your prompt:** Start a new task and ensure you are still in *🛠️ Advanced Mode*

To start, we will be relatively vague and let Bob decide what tests to include and how to write the skill. To ensure correct structure we can reference an existing skill template file called `code_review.yaml`.

**Prompt to Bob:**
```
Create a new Bob skill called test_loan_service to thoroughly test the LoanEligibilityREST service defined in the baw mcp server. Use the @/.bob/skills/code_review.yaml example skill as an example of how to properly format the skill.
```

**What Bob Will Do:**

Bob will:
- Read and understand the referenced skill template
- Determine what test cases should be included for 'thorough coverage'
- Author a new skill from scratch

### Step 3.3: Review the Generated Skill

Let's examine the skill Bob created, it should already be open in your code editor to view. 

**Key Sections to Review:**
The generated skill will not be the same every time but the following are some key areas to investigate.

**1. Skill Header:**
```yaml
---
name: test-loan-eligibility
description: * Description Here *
---
```

**2. Validation Step:**
*Example Implementation:*
```yaml
<Step>
Confirm the MCP prerequisites before testing:
- Verify the `baw-services` MCP server is available and connected
- Verify the `LA4_LoanEligibilityREST_LoanEligService` tool is present
- If the tool is unavailable, stop and report the MCP configuration issue clearly
</Step>
```

**3. Positive Scenarios:**
*Example Implementation:*
```yaml
<Step>
Test positive scenarios (eligible customers):
- High-income, excellent credit (e.g., customerId: 1001, monthlyIncome: 15000, creditScore: 800, existingLiability: 2000)
- Medium-income, good credit (e.g., customerId: 1002, monthlyIncome: 8000, creditScore: 720, existingLiability: 1500)
- Moderate-income, fair credit (e.g., customerId: 1003, monthlyIncome: 5000, creditScore: 680, existingLiability: 1000)
- Verify eligibilityStatus is "Eligible" or similar positive status
- Confirm eligibleAmount is calculated appropriately
- Check riskCategory classification
</Step>
```

**3. Negative Scenarios:**
*Example Implementation:*
```yaml
<Step>
Run negative and robustness tests:
- Try missing optional inputs one at a time when supported
- Try clearly unfavorable applicant data such as very low income or poor credit
- Try edge numeric values such as zero or near-zero income where appropriate
- Observe whether the service returns a valid business response or an error
- Record any unexpected failures, validation gaps, or ambiguous behavior
```

### Step 3.4: Run a testing cylce

Using the skill should be straightforward. Simply ask bob to complete some tests of the service.

**Prompt to Bob:**
```
Run a test of the loan eligibility service utilizing the test_loan_service skill
```

**What Happens:**

1. Bob reads the skill file
2. Follows each step sequentially
3. Calls the MCP tool for each test case
4. Collects and analyzes results
5. Generates a comprehensive report

Once all tests have finished running, be sure to review the tests run and their results. Be on the lookout for testing gaps and areas for change or improvement.

### Step 3.5: [Optional] Refining your skill

Some key benefits of skills are repeatability and customization. Now it's time to refine our testing skill, either manually or with Bob.

**Possible Approaches:**
- Get more specific: add details of tests you want included (both positive and negative)
- Do something with test results: save and export, have Bob interpret, etc
- Get more advanced: add in more complex functionality 

---

### Key Takeaways

**1. MCP Enables Service Integration**
- MCP servers bridge Bob and external services
- Project-level configuration keeps credentials secure
- Easy to add new services and tools

**2. Skills Provide Repeatability**
- Write once, run many times
- Consistent test approach
- Self-documenting
- Shareable across teams

**4. Automation Saves Time**
- Skill-based testing provides comprehensive coverage quickly
- Repeatable for regression testing
- Consistent, lightweight testing

---