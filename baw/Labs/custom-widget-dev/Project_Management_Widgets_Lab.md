# Project Management Widgets Toolkit - Bob-Guided Lab

## Overview

This lab guides you through using **Bob** to create a complete **Project Management Widgets** toolkit from scratch. You'll learn to interact with Bob to create three custom widgets, package them into a TWX toolkit, and deploy to BAW.

**What You'll Build:**
1. **Task Card** - Display task information with status indicators
2. **Progress Tracker** - Visual progress bar with percentage display
3. **Status Badge** - Colored status indicators for workflow states

**Estimated Time:** 30-45 minutes

---

## Prerequisites

- IBM Business Automation Workflow (BAW) environment access
- Bob AI assistant configured with BAW modes BAW Coach Widget and BAW Package Manager
- BOB-BAW project with package_baw.py script
- Basic understanding of BAW concepts

---

## MCP Server Setup

Before starting the lab, you need to configure the **baw-admin MCP server** to enable Bob to communicate with your BAW environment for toolkit deployment.

### Step 1: Create MCP Configuration File

1. **Navigate to the `.bob` directory** in your project root
2. **Locate the `dummy_mcp.json` file** - This is a template with placeholder values
3. **Create a new file named `mcp.json`** in the same directory
4. **Copy the contents from `dummy_mcp.json` to `mcp.json`**

### Step 2: Configure BAW Server Credentials

Edit the `mcp.json` file and replace the placeholder values with your actual BAW server credentials:

**For this lab, you only need to configure the `baw-admin` server:**

```json
{
    "mcpServers": {
        "baw-admin": {
           "command": "npx",
            "args": [
                "-y",
                "github:MalekJabri/baw-admin-mcp-server-standalone",
                "baw-admin-mcp-server"
            ],
            "env": {
                "BAW_BASE_URL": "https://your-baw-server.example.com/bas/ops",
                "BAW_USERNAME": "your-username",
                "BAW_PASSWORD": "your-password",
                 "BAW_REJECT_UNAUTHORIZED": "false"
            },
            "alwaysAllow": [
                "get_install_status",
                "login"
            ]
        }
    }
}
```

**Replace these values:**
- `BAW_BASE_URL`: Your BAW server URL ending with `/bas/ops`
- `BAW_USERNAME`: Your BAW username
- `BAW_PASSWORD`: Your BAW password

**Note:** The `baw-services` server is only needed for the automated testing lab, not for this custom widget lab.

### Step 3: Verify MCP Server in Bob Settings

1. **Open Bob Settings**
2. **Navigate to MCP Servers section**
3. **Verify that `baw-admin` server is listed and active**
4. **Check that the server shows a green status indicator**

If the server is not active, restart Bob or check the configuration file for syntax errors.



---

## Creating and Deploying Custom Widgets Lab Instructions

### Part 1: TaskCard Widget Creation

**Initial Setup:**
- Ensure Bob is in BAW Coach Widget mode or instruct Bob: `Switch to BAW Coach Widget mode`


**Prompt to Bob:**

```
Create a widget called "TaskCard" Use templates/EXAMPLETASKCARDWIDGET as a template for widget files and 
templates/EXAMPLETASKCARDBUSINESSOBJECT as a template for business object creation. 

Widget Name: TaskCard
Description: A comprehensive task management card with priority and status indicators

Card Structure:
- Header: Task title with priority badge
- Body: Description text with metadata (assignee, due date)
- Footer: Status badge with color coding
- Dual mode: Display mode (read-only) and Edit mode (editable fields)

Business Object (TaskData):
- title: String (required) - Task title
- description: String - Detailed task description
- assignee: String - Person assigned to the task
- dueDate: String - Task due date
- priority: String (default: "Medium") - Task priority level
- status: String (default: "Not Started") - Current task status

Configuration Options:
- showAssignee: Boolean (default: true) - Display assignee information
- showDueDate: Boolean (default: true) - Display due date information
- compactMode: Boolean (default: false) - Use compact display layout
- editable: Boolean (default: false) - Allow editing of task fields

Events:
- taskClicked: Fired when the task card is clicked
- taskUpdated: Fired when task data is modified in edit mode

Styling:
- Clean card design with subtle shadow (0 2px 4px rgba(0,0,0,0.1))
- Rounded corners (8px border-radius)
- Priority badge colors:
  - 🔵 Low: Blue (#2196f3)
  - 🟠 Medium: Orange (#ff9800)
  - 🔴 High: Red (#f44336)
- Status badge colors:
  - ⚪ Not Started: Gray (#9e9e9e)
  - 🔵 In Progress: Blue (#2196f3)
  - 🟢 Completed: Green (#4caf50)
  - 🟠 On Hold: Orange (#ff9800)
  - 🔴 Cancelled: Red (#f44336)
- Hover effect: Lift card with increased shadow
- Smooth transitions (0.3s ease) for all state changes
- Responsive padding and spacing
- Accessible design (role="button", tabindex="0", ARIA labels)

The widget should bind to a TaskData business object and support both display and edit modes with smooth transitions between states.

BAW Widget Folder Structure
widgets/
└── {WidgetName}/                    # Root widget folder (e.g., TaskCard)
    ├── widget/                      # Core widget implementation
    │   ├── config.json              # Widget metadata & configuration
    │   ├── Layout.html              # HTML structure with data bindings
    │   ├── InlineCSS.css            # Scoped styles for the widget
    │   └── inlineJavascript.js      # Widget behavior & event handling
    │
    ├── AdvancePreview/              # Preview for BAW Process Designer
    │   ├── Preview.html             # Static preview HTML
    │   └── Preview.js               # Preview initialization logic
    │
    └── README.md                    # Widget documentation

business-objects/generated/
└── {WidgetName}/                    # Business object definitions
    └── {BusinessObjectName}.json    # BO schema (e.g., TaskData.json)
```

**Expected Result:** Bob creates the complete Task Card widget with all files.

---

### Part 2: Create Progress Tracker Widget

**Initial Setup:**
- Ensure Bob is still in BAW Coach Widget mode or instruct Bob: `Switch to BAW Coach Widget mode`

**Prompt to Bob:**

```
Create a widget called "ProgressTracker" Use templates/EXAMPLETASKCARDWIDGET as a template for widget files and 
templates/EXAMPLETASKCARDBUSINESSOBJECT as a template for business object creation

Widget Name: ProgressTracker
Description: Animated horizontal progress bar with smooth transitions and real-time percentage display

Progress Bar Features:
• Animated horizontal progress bar with smooth transitions
• Percentage display showing real-time progress
• Color-coded states that change automatically:
  - 🔴 Red (0-49%): Low progress
  - 🟡 Yellow (50-74%): Moderate progress
  - 🟢 Green (75-100%): High progress
• Status messages ("Not started", "In progress...", "Complete")
• Shine effect overlay when animated
• Dual mode: Display mode (progress bar) and Edit mode (slider control)

Business Object (ProgressData):
- label: String (required) - Progress label text
- currentValue: Integer (default: 0) - Current progress value
- maxValue: Integer (default: 100) - Maximum progress value
- showPercentage: Boolean (default: true) - Display percentage indicator

Configuration Options:
- barColor: String (default: "#4caf50") - Color of the progress bar fill
- height: String (default: "24px") - Height of the progress bar
- animated: Boolean (default: true) - Enable smooth fill animation
- editable: Boolean (default: false) - Allow adjusting progress with slider

Events:
- progressChanged: Fired when progress value changes (in edit mode or programmatically)

Styling:
- Clean, modern progress bar design
- Background: Light gray (#e0e0e0)
- Progress fill: Configurable color with automatic color-coding:
  - Red (#f44336) for 0-49%
  - Yellow (#ff9800) for 50-74%
  - Green (#4caf50) for 75-100%
- Rounded corners (4px border-radius)
- Smooth transition animations (0.3s ease) for fill width and color changes
- Shine effect: Linear gradient overlay (rgba(255,255,255,0.3))
- Slider styling in edit mode with custom track matching bar height
- Responsive font sizes and spacing
- Accessible design (role="progressbar", aria-valuemin, aria-valuemax, aria-valuenow)
- Footer showing "currentValue / maxValue" format

The widget should bind to a ProgressData business object and automatically update colors based on progress percentage.

BAW Widget Folder Structure
widgets/
└── {WidgetName}/                    # Root widget folder (e.g., TaskCard)
    ├── widget/                      # Core widget implementation
    │   ├── config.json              # Widget metadata & configuration
    │   ├── Layout.html              # HTML structure with data bindings
    │   ├── InlineCSS.css            # Scoped styles for the widget
    │   └── inlineJavascript.js      # Widget behavior & event handling
    │
    ├── AdvancePreview/              # Preview for BAW Process Designer
    │   ├── Preview.html             # Static preview HTML
    │   └── Preview.js               # Preview initialization logic
    │
    └── README.md                    # Widget documentation

business-objects/generated/
└── {WidgetName}/                    # Business object definitions
    └── {BusinessObjectName}.json    # BO schema (e.g., TaskData.json)
```

**Expected Result:** Bob creates the complete Progress Tracker widget with all files.

---

### Part 3: Create Status Badge Widget

**Initial Setup:**
- Ensure Bob is still in BAW Coach Widget mode or instruct Bob: `Switch to BAW Coach Widget mode`

**Prompt to Bob:**

```
Create a widget called "StatusBadge" Use templates/EXAMPLETASKCARDWIDGET as a template for widget files and 
templates/EXAMPLETASKCARDBUSINESSOBJECT as a template for business object creation

Widget Name: StatusBadge
Description: Colored status indicator badge with icon and label

Badge Structure:
- Display mode: Inline badge with optional icon and label
- Edit mode: Dropdown selector for changing status
- Clickable and interactive
- Size variations (small, medium, large)

Business Object (StatusData):
- label: String (required) - Status label text
- status: String (default: "pending") - Status identifier
- icon: String (default: "●") - Icon character or symbol

Configuration Options:
- size: String (default: "medium", options: ["small", "medium", "large"]) - Badge size
- rounded: Boolean (default: true) - Use rounded corners
- showIcon: Boolean (default: true) - Display icon in badge
- editable: Boolean (default: false) - Allow changing status from dropdown

Events:
- statusClicked: Fired when status badge is clicked
- statusChanged: Fired when status is changed via dropdown in edit mode

Styling:
- Badge design with inline-flex layout
- Status colors with semantic meaning:
  - 🟢 active: Green (#4caf50) - Active/running state
  - 🟠 pending: Orange (#ff9800) - Waiting/pending state
  - ⚪ inactive: Gray (#9e9e9e) - Inactive/disabled state
  - 🔵 approved: Blue (#2196f3) - Approved state
  - 🔴 rejected: Red (#f44336) - Rejected/failed state
  - 🟣 on-hold: Purple (#9c27b0) - On hold state
- Size variations:
  - small: 0.75rem font, 4px padding, 12px height
  - medium: 0.875rem font, 6px 12px padding, 24px height
  - large: 1rem font, 8px 16px padding, 32px height
- Rounded corners when enabled (16px border-radius for pill shape)
- Icon and label spacing (4px gap)
- Hover effects: Scale up slightly (1.05) with opacity change (0.9)
- Smooth transitions (0.2s ease) for all state changes
- Dropdown styling in edit mode matching badge size and colors
- Accessible design (role="button", tabindex="0", ARIA labels)

The widget should bind to a StatusData business object and support multiple status types with automatic color coding.

BAW Widget Folder Structure
widgets/
└── {WidgetName}/                    # Root widget folder (e.g., TaskCard)
    ├── widget/                      # Core widget implementation
    │   ├── config.json              # Widget metadata & configuration
    │   ├── Layout.html              # HTML structure with data bindings
    │   ├── InlineCSS.css            # Scoped styles for the widget
    │   └── inlineJavascript.js      # Widget behavior & event handling
    │
    ├── AdvancePreview/              # Preview for BAW Process Designer
    │   ├── Preview.html             # Static preview HTML
    │   └── Preview.js               # Preview initialization logic
    │
    └── README.md                    # Widget documentation

business-objects/generated/
└── {WidgetName}/                    # Business object definitions
    └── {BusinessObjectName}.json    # BO schema (e.g., TaskData.json)
```

**Expected Result:** Bob creates the complete Status Badge widget with all files.

---

### Part 4: Update Packaging Configuration

**Initial Setup:**
- Switch Bob mode to BAW Package Manager mode or instruct Bob: `Switch to BAW Package Manager mode`


**Prompt to Bob:**

```
Update the package_baw.py script to include the three new widgets:

Add these widget names to the WIDGET_NAMES list:
- TaskCard
- ProgressTracker
- StatusBadge

The script should now package all existing widgets plus these three new ones.

Next, update the toolkit configuration with a unique name and ID to avoid conflicts with other users:

1. Update toolkit.config.json with:
   - A unique toolkit name (include your initials, e.g., "Project Management Widgets - KZ")
   - A unique shortName (e.g., "PMW-KZ")
   - A new unique object ID (generate a new GUID in format: 2066.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)

2. Package all widgets including the three new Project Management widgets:
   - Run: python3 package_baw.py
   - Verify the TWX file is created in output/
   - Report the package size and contents
   - Confirm TaskCard, ProgressTracker, and StatusBadge are included

If there are any errors, fix them and repackage.
```

**Expected Result:** Bob updates package_baw.py to include the new widgets. Bob runs the packaging script and creates the TWX file with all widgets.

---

### Part 5: Deploy to BAW Server

**Initial Setup:**
- Ensure Bob mode is set to BAW Package Manager mode or instruct Bob: `Switch to BAW Package Manager mode`


**Prompt to Bob:**

```
Deploy the Custom Widgets toolkit to the BAW server:

1. Use the baw-admin MCP tool to install the toolkit
2. Upload the TWX file from output/Custom_Widgets_[version].twx
3. Monitor the installation status
4. Verify the toolkit appears in the BAW server

Report the deployment status and any issues encountered.
```

**Expected Result:** Bob deploys the toolkit to BAW and confirms successful installation.

---

## Testing Custom Widgets in BAW

### Step 1: Create a New Process Application
1. **Open BAW Business Automations Studio**
   - Navigate to your BAW server URL
   - Log in with your credentials

2. **Create a New Workflow**
   - Click **"+ Create"** → **"Workflow → Workflow Automation"**
   - Enter the following details:
     - **Name:** `Project Management Widgets Test`
     - **Acronym:** `PMWT`
     - **Description:** `Testing Project Management Widgets`
   - Click **"Create"**

---

### Step 2: Add Custom Widgets Toolkit as Dependency

1. **From the left sidebar menu, click on the "+" button**
   - Scroll down to the "Custom Widgets" section
   - Click on the most recent version of your Custom Widgets toolkit

2. **Verify Dependency**
   - Confirm "Custom Widgets" appears under the Toolkits list
   - Note the version number (should be whatever is the most recent)


---

### Step 3: Create a Test Coach

1. **Create New User Interface**
   - From the left sidebar menu, click on the **"+"** sign next to **"User Interface"**. Then select **"Client-side human service"**
   - Enter the following:
     - **Name:** `PM Widgets Test Coach`
   - Click **"Finish"**

2. **Set Up Coach Variables**
   - In the coach editor, click **"Variables"** tab
   - Add the following variables as Input Variables:

   **TaskCard Data:**
   ```
   Name: taskData
   Type: TaskData (from Custom Widgets)
   ```

   **ProgressTracker Data:**
   ```
   Name: progressData
   Type: ProgressData (from Custom Widgets)
   ```

   **StatusBadge Data:**
   ```
   Name: statusData
   Type: StatusData (from Custom Widgets)
   ```

---

### Step 4: Add Widgets to Canvas

#### 4.1 Add TaskCard Widget

1. **Drag Widget to Canvas**
   - Open your Coach Canvas Page (Coach drop down → Coach)
   - From the left hand side bar, under **Toolkits** → **Custom Widgets** → **User Interface** → **TaskCard**
   - Drag **"TaskCard"** widget onto the canvas

2. **Configure Widget Properties**
   - Select the TaskCard widget
   - In the **General** tab:
     - Under **Behavior**  → **Binding**: Bind to `taskData` variable
   - In the **Configuration** tab:
     - Check **Editable**

#### 4.2 Add Progress Tracker Widget

1. **Drag Widget to Canvas**
   - Open your Coach Canvas Page (Coach drop down → Coach)
   - From the left hand side bar, under **Toolkits** → **Custom Widgets** → **User Interface** → **ProgressTracker**
   - Drag **"ProgressTracjer"** widget onto the canvas

2. **Configure Widget Properties**
   - Select the ProgressTracker widget
   - In the **General** tab:
     - Under **Behavior**  → **Binding**: Bind to `progressData` variable
   - In the **Configuration** tab:
     - Check **Animated**
     - Check **Editable**

### 4.3 Add Status Badge Widget

1. **Drag Widget to Canvas**
   - Open your Coach Canvas Page (Coach drop down → Coach)
   - From the left hand side bar, under **Toolkits** → **Custom Widgets** → **User Interface** → **StatusBadge**
   - Drag **"StatusBadge"** widget onto the canvas

2. **Configure Widget Properties**
   - Select the ProgressTracker widget
   - In the **General** tab:
     - Under **Behavior**  → **Binding**: Bind to `statusData` variable
   - In the **Configuration** tab:
     - Set **Size** to 'large'
     - Check **Editable**
---

### Step 5: Add pre-script to fill in default data
1. Navigate to the **Diagram** tab in your **UI** page
2. Click on the **Pre-Script** tab
3. Add the following code to the pre-script section:

```
tw.local.taskData = {
  title: "Implement User Authentication",
  description: "Add OAuth 2.0 authentication to the application with support for Google and Microsoft providers",
  assignee: "John Smith",
  dueDate: "2026-06-15",
  priority: "High",
  status: "In Progress"
};
tw.local.progressData = {
  label: "Project Completion",
  currentValue: 45,
  maxValue: 100,
  showPercentage: true
};
tw.local.statusData = {
  label: "Approved",
  status: "approved",
  icon: "✓"
};
```

---

### Step 6: Test your UI Coach
1. Click the Checkbox icon at the top right to save.
2. Click Run.

---
#### **Congratulations!** You have just completed the Custom Widget Development lab with Bob!
---
## Key Takeaways

**1. Bob Accelerates Widget Development**
- Creates complete widget structure (config, HTML, CSS, JS) from detailed prompts
- Generates matching business objects automatically
- Includes AdvancePreview files for BAW Process Designer
- Reduces widget creation time from hours to minutes

**2. Template-Based Approach Ensures Consistency**
- EXAMPLETASKCARDWIDGET provides proven widget structure
- EXAMPLETASKCARDBUSINESSOBJECT ensures proper business object format
- Consistent file organization across all widgets
- Reusable patterns for future widget development

**3. MCP Enables Seamless Deployment**
- baw-admin MCP server bridges Bob and BAW environments
- Automated packaging with package_baw.py script
- One-command deployment to BAW server
- Real-time installation status monitoring

**4. Structured Workflow Saves Time**
- Create → Package → Deploy workflow in 30-45 minutes
- Automatic widget detection and configuration updates
- Business object registration with BAW class IDs
- Repeatable process for any custom widget toolkit
