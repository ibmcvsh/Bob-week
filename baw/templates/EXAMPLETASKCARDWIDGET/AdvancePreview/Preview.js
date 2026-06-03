// Preview.js for TaskCard widget
// Plain JavaScript implementation for BAW Process Designer preview

(function() {
    // Sample task data for preview
    var previewData = {
        title: "Sample Task Title",
        description: "This is a sample task description that shows how the task card will appear in the designer.",
        assignee: "John Doe",
        dueDate: "2026-06-15",
        priority: "Medium",
        status: "In Progress"
    };
    
    // Initialize preview when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initPreview);
    } else {
        initPreview();
    }
    
    function initPreview() {
        // Preview initialization logic
        console.log('TaskCard preview initialized with data:', previewData);
    }
})();

// Made with Bob
