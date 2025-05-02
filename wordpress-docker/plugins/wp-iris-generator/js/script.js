jQuery(document).ready(function($) {
    $('#iris-generator-form').on('submit', function(e) {
        e.preventDefault();

        // Show loading state
        const submitButton = $(this).find('button[type="submit"]');
        const originalText = submitButton.text();
        submitButton.prop('disabled', true).text('Generating...');

        // Collect form data
        const formData = {
            action: 'generate_iris_class',
            nonce: wpIrisGenerator.nonce,
            module_name: $('#module-name').val(),
            table_name: $('#table-name').val(),
            table_description: $('#table-description').val(),
            properties: $('#properties').val()
        };

        // Submit the form via AJAX
        $.ajax({
            url: wpIrisGenerator.ajaxurl,
            type: 'POST',
            data: formData,
            xhrFields: {
                responseType: 'blob'
            },
            success: function(response) {
                // Create a download link
                const blob = new Blob([response], { type: 'application/zip' });
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = formData.module_name + '.zip';
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                document.body.removeChild(a);

                // Show success message
                alert('IRIS class file generated successfully!');
            },
            error: function(xhr, status, error) {
                alert('Error generating IRIS class file: ' + error);
            },
            complete: function() {
                // Reset button state
                submitButton.prop('disabled', false).text(originalText);
            }
        });
    });

    // Add example text to properties field on focus
    $('#properties').on('focus', function() {
        if (!this.value) {
            this.value = 'Name:String:Product name\nPrice:Decimal:Product price\nDescription:String:Product description';
        }
    });
}); 