/**
 * TaskCard Widget - Inline JavaScript
 * Handles widget initialization, data binding, event handling, and edit mode
 */

// Get the task data from BAW binding
var taskData = this.getData();

// Get configuration options
var showAssignee = this.getOption("showAssignee") !== false;
var showDueDate = this.getOption("showDueDate") !== false;
var compactMode = this.getOption("compactMode") === true;
var editable = this.getOption("editable") === true;

// Register event handling
this.registerEventHandlingFunction(this, "taskClicked");
this.registerEventHandlingFunction(this, "taskUpdated");

// Get DOM elements
var element = this.context.element;
var taskCard = element.querySelector('.task-card');

if (!taskCard) {
  console.error('TaskCard: Card element not found');
} else {
  var self = this;
  
  // Apply compact mode
  if (compactMode) {
    taskCard.setAttribute('data-compact', 'true');
  }

  // Set edit mode
  taskCard.setAttribute('data-editable', editable.toString());
  
  // Show/hide elements based on mode
  var displayElements = taskCard.querySelectorAll('[data-display-mode]');
  var editElements = taskCard.querySelectorAll('[data-edit-mode]');
  
  displayElements.forEach(function(el) {
    el.style.display = editable ? 'none' : '';
  });
  
  editElements.forEach(function(el) {
    el.style.display = editable ? '' : 'none';
  });

  // Update data bindings
  if (taskData) {
    // Update title
    var titleElement = taskCard.querySelector('.task-title');
    var titleInput = taskCard.querySelector('.task-title-input');
    if (titleElement && taskData.title) {
      titleElement.textContent = taskData.title;
    }
    if (titleInput) {
      titleInput.value = taskData.title || '';
    }

    // Update description
    var descElement = taskCard.querySelector('.task-description');
    var descInput = taskCard.querySelector('.task-description-input');
    if (descElement && taskData.description) {
      descElement.textContent = taskData.description;
    }
    if (descInput) {
      descInput.value = taskData.description || '';
    }

    // Update assignee
    var assigneeValue = taskCard.querySelector('.metadata-item [data-binding="taskData.assignee"][data-display-mode]');
    var assigneeInput = taskCard.querySelector('.metadata-item [data-binding="taskData.assignee"][data-edit-mode]');
    if (assigneeValue && taskData.assignee) {
      assigneeValue.textContent = taskData.assignee;
    }
    if (assigneeInput) {
      assigneeInput.value = taskData.assignee || '';
    }

    // Update due date
    var dueDateValue = taskCard.querySelector('.metadata-item [data-binding="taskData.dueDate"][data-display-mode]');
    var dueDateInput = taskCard.querySelector('.metadata-item [data-binding="taskData.dueDate"][data-edit-mode]');
    if (dueDateValue && taskData.dueDate) {
      dueDateValue.textContent = taskData.dueDate;
    }
    if (dueDateInput) {
      dueDateInput.value = taskData.dueDate || '';
    }

    // Update priority
    var priorityElements = taskCard.querySelectorAll('[data-binding="taskData.priority"][data-display-mode]');
    var prioritySelect = taskCard.querySelector('.priority-select');
    if (taskData.priority) {
      priorityElements.forEach(function(el) {
        el.textContent = taskData.priority;
      });
      var priorityBadge = taskCard.querySelector('.priority-badge');
      if (priorityBadge) {
        priorityBadge.setAttribute('data-priority-level', taskData.priority);
      }
    }
    if (prioritySelect) {
      prioritySelect.value = taskData.priority || 'Medium';
    }

    // Update status
    var statusElements = taskCard.querySelectorAll('[data-binding="taskData.status"][data-display-mode]');
    var statusSelect = taskCard.querySelector('.status-select');
    if (taskData.status) {
      statusElements.forEach(function(el) {
        el.textContent = taskData.status;
      });
      var statusBadge = taskCard.querySelector('.status-badge');
      if (statusBadge) {
        statusBadge.setAttribute('data-status-type', taskData.status);
      }
    }
    if (statusSelect) {
      statusSelect.value = taskData.status || 'Not Started';
    }
  }

  // Update visibility
  var assigneeItem = taskCard.querySelector('[data-show-if="config.showAssignee"]');
  if (assigneeItem) {
    assigneeItem.style.display = showAssignee ? 'flex' : 'none';
  }

  var dueDateItem = taskCard.querySelector('[data-show-if="config.showDueDate"]');
  if (dueDateItem) {
    dueDateItem.style.display = showDueDate ? 'flex' : 'none';
  }

  // Set up edit mode handlers
  if (editable) {
    // Helper function to update data and fire event
    function updateTaskData() {
      var updatedData = {
        title: titleInput ? titleInput.value : taskData.title,
        description: descInput ? descInput.value : taskData.description,
        assignee: assigneeInput ? assigneeInput.value : taskData.assignee,
        dueDate: dueDateInput ? dueDateInput.value : taskData.dueDate,
        priority: prioritySelect ? prioritySelect.value : taskData.priority,
        status: statusSelect ? statusSelect.value : taskData.status
      };
      
      self.setData(updatedData);
      self.fireEvent("taskUpdated");
    }

    // Add change listeners to all inputs
    if (titleInput) {
      titleInput.addEventListener('change', updateTaskData);
    }
    if (descInput) {
      descInput.addEventListener('change', updateTaskData);
    }
    if (assigneeInput) {
      assigneeInput.addEventListener('change', updateTaskData);
    }
    if (dueDateInput) {
      dueDateInput.addEventListener('change', updateTaskData);
    }
    if (prioritySelect) {
      prioritySelect.addEventListener('change', updateTaskData);
    }
    if (statusSelect) {
      statusSelect.addEventListener('change', updateTaskData);
    }
    
    // Prevent click event from firing when editing
    taskCard.removeAttribute('role');
    taskCard.removeAttribute('tabindex');
  } else {
    // Set up click handler for display mode
    taskCard.addEventListener('click', function(event) {
      self.fireEvent("taskClicked");
    });

    taskCard.addEventListener('keydown', function(event) {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        self.fireEvent("taskClicked");
      }
    });
  }
}

// Made with Bob
