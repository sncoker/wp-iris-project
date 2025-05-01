<?php
/**
 * Plugin Name: WP IRIS Generator
 * Plugin URI: https://github.com/sncoker
 * Description: Generates IRIS class files from WordPress
 * Version: 1.0.2
 * Author: Shawntelle Madison-Coker
 * Author URI: https://github.com/sncoker
 * Text Domain: wp-iris-generator
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: wp-iris-generator
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class WPIRISGenerator {
    private static $instance = null;

    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct() {
        add_action( 'admin_menu', array($this, 'add_admin_menu') );
        add_action( 'admin_enqueue_scripts', array($this, 'enqueue_admin_scripts') );
        add_action( 'wp_ajax_generate_iris_class', array($this, 'generate_iris_class') );
    }

    public function add_admin_menu() {
        add_menu_page(
            'WP IRIS Generator',
            'WP IRIS Generator',
            'manage_options',
            'wp-iris-generator',
            array($this, 'render_admin_page'),
            'dashicons-editor-code',
            30
        );

        add_submenu_page(
            'wp-iris-generator',
            __('Help', 'wp-iris-generator'),
            __('Help', 'wp-iris-generator'),
            'manage_options',
            'wp-iris-generator-help',
            array($this, 'render_help_page')
        );
    }


     //Add Help submenu
  
    public function enqueue_admin_scripts($hook) {
        if ('toplevel_page_wp-iris-generator' !== $hook) {
            return;
        }
        wp_enqueue_style('wp-iris-generator', plugins_url('css/style.css', __FILE__));
        wp_enqueue_script('wp-iris-generator', plugins_url('js/script.js', __FILE__), array('jquery'), '1.0.0', true);
        wp_localize_script('wp-iris-generator', 'wpIrisGenerator', array(
            'ajaxurl' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('wp-iris-generator-nonce')
        ));
    }

    public function render_admin_page() {
        ?>
        <div class="wrap">
            <h1>WP IRIS Generator</h1>
            <p>Are you ready to build an interface to IRIS? Use this tool to create the folder and class file so you have a starting point to receive REST data.</p>
            <form id="iris-generator-form" method="post">
                <div class="form-group">
                    <label for="module-name">Module Name (e.g., Biotech, Fintech, SupplyChain) <span class="required">*</span>:</label>
                    <input type="text" id="module-name" name="module_name" required>
                    <p class="description">Module name must not contain hyphens (-), spaces, or special characters.</p>
                </div>
                <div class="form-group">
                    <label for="table-name">Table Name (e.g., Product, Transaction) <span class="required">*</span>:</label>
                    <input type="text" id="table-name" name="table_name" required>
                    <p class="description">Table name must not contain hyphens (-), spaces, or special characters.</p>
                </div>
                <div class="form-group">
                    <label for="table-description">Table Description:</label>
                    <textarea id="table-description" name="table_description" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="properties">Properties (one per line, format: name:type:description) <span class="required">*</span>:</label>
                    <textarea id="properties" name="properties" rows="5" placeholder="Name:String:Product name&#10;Price:Decimal:Product price" required></textarea>
                    <p class="description">Property names must not contain hyphens (-), spaces, or special characters.</p>
                </div>
                <button type="submit" class="button button-primary">Generate IRIS Class</button>
            </form>
            <style>
                .required {
                    color: #dc3232;
                    font-weight: bold;
                }
                .form-group {
                    margin-bottom: 20px;
                }
                .description {
                    color: #666;
                    font-style: italic;
                    margin-top: 5px;
                }
            </style>
        </div>
        <?php
    }

    /**
     * Renders the help page content.
     */
    public function render_help_page() {
        if (!current_user_can('manage_options')) {
            wp_die(__('You do not have sufficient permissions to access this page.', 'wp-iris-generator'));
        }
        ?>
        <div class="wrap">
            <h1><?php echo esc_html__('WP IRIS Generator Help', 'wp-iris-generator'); ?></h1>
            
            <div class="help-content" style="max-width: 800px;">
                <h2><?php echo esc_html__('Getting Started', 'wp-iris-generator'); ?></h2>
                <p><?php echo esc_html__('Knowing where to start when working with Objectscript and IRIS-based systems can be difficult. Use this tool as a starting point to create the class necessary to plugin into IRIS. You will need to have the WP Iris Framework installed on IRIS in order to receive data into WordPress', 'wp-iris-generator'); ?></p>

                <h3><?php echo esc_html__('Basic Setup', 'wp-iris-generator'); ?></h3>
                <ol>
                    <li><?php echo esc_html__('Configure the API URL in the Settings page', 'wp-iris-generator'); ?></li>
                    <li><?php echo esc_html__('Ensure your product pages exist in WordPress', 'wp-iris-generator'); ?></li>
                    <li><?php echo esc_html__('Use the Import button to update SEO data', 'wp-iris-generator'); ?></li>
                </ol>

                <h3><?php echo esc_html__('mySQL to IRIS Cheatsheet', 'wp-iris-generator'); ?></h3>
                <table class="widefat" style="width: 100%;">
                    <thead>
                        <tr>
                            <th><?php echo esc_html__('Data Type', 'wp-iris-generator'); ?></th>
                            <th><?php echo esc_html__('mySQL', 'wp-iris-generator'); ?></th>
                            <th><?php echo esc_html__('IRIS', 'wp-iris-generator'); ?></th>
                            <th><?php echo esc_html__('Example', 'wp-iris-generator'); ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><?php echo esc_html__('String', 'wp-iris-generator'); ?></td>
                            <td>VARCHAR, TEXT</td>
                            <td>%String</td>
                            <td><code>Property Name As %String;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Integer', 'wp-iris-generator'); ?></td>
                            <td>INT, BIGINT</td>
                            <td>%Integer</td>
                            <td><code>Property Age As %Integer;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Decimal', 'wp-iris-generator'); ?></td>
                            <td>DECIMAL, FLOAT</td>
                            <td>%Decimal</td>
                            <td><code>Property Price As %Decimal(SCALE = 2);</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Boolean', 'wp-iris-generator'); ?></td>
                            <td>BOOLEAN, TINYINT(1)</td>
                            <td>%Boolean</td>
                            <td><code>Property IsActive As %Boolean;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Date/Time', 'wp-iris-generator'); ?></td>
                            <td>DATETIME, TIMESTAMP</td>
                            <td>%TimeStamp</td>
                            <td><code>Property CreatedAt As %TimeStamp;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Binary Data', 'wp-iris-generator'); ?></td>
                            <td>BLOB, LONGBLOB</td>
                            <td>%Stream.GlobalBinary</td>
                            <td><code>Property ImageData As %Stream.GlobalBinary;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Enum', 'wp-iris-generator'); ?></td>
                            <td>ENUM</td>
                            <td>%String with VALUELIST</td>
                            <td><code>Property Status As %String(VALUELIST = ",Active,Inactive,Suspended");</code></td>
                        </tr>
                    </tbody>
                </table>

                <h3><?php echo esc_html__('Common Operations', 'wp-iris-generator'); ?></h3>
                <table class="widefat" style="width: 100%;">
                    <thead>
                        <tr>
                            <th><?php echo esc_html__('Operation', 'wp-iris-generator'); ?></th>
                            <th><?php echo esc_html__('mySQL', 'wp-iris-generator'); ?></th>
                            <th><?php echo esc_html__('IRIS', 'wp-iris-generator'); ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><?php echo esc_html__('Primary Key', 'wp-iris-generator'); ?></td>
                            <td>PRIMARY KEY</td>
                            <td><code>Property ID As %Integer [ Required, PrimaryKey ];</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Foreign Key', 'wp-iris-generator'); ?></td>
                            <td>FOREIGN KEY</td>
                            <td><code>Property Category As WordPressAPI.Framework.Category;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Index', 'wp-iris-generator'); ?></td>
                            <td>INDEX</td>
                            <td><code>Index NameIdx On Name;</code></td>
                        </tr>
                        <tr>
                            <td><?php echo esc_html__('Unique Constraint', 'wp-iris-generator'); ?></td>
                            <td>UNIQUE</td>
                            <td><code>Index EmailIdx On Email [ Unique ];</code></td>
                        </tr>
                    </tbody>
                </table>

                <h3><?php echo esc_html__('Best Practices', 'wp-iris-generator'); ?></h3>
                <ul>
                    <li><?php echo esc_html__('Always use proper data types that match your mySQL schema', 'wp-iris-generator'); ?></li>
                    <li><?php echo esc_html__('Define property descriptions using /// comments for better documentation', 'wp-iris-generator'); ?></li>
                    <li><?php echo esc_html__('Use appropriate indexes for frequently queried fields', 'wp-iris-generator'); ?></li>
                    <li><?php echo esc_html__('Consider using relationships (references) instead of foreign keys when possible', 'wp-iris-generator'); ?></li>
                    <li><?php echo esc_html__('Use %JSON.Adaptor for easy JSON serialization/deserialization', 'wp-iris-generator'); ?></li>
                </ul>

                <h3><?php echo esc_html__('Need More Help?', 'wp-iris-generator'); ?></h3>
                <p>
                    <?php 
                    printf(
                        /* translators: %s: Support email */
                        esc_html__('For additional assistance, please contact support at %s', 'wp-iris-generator'),
                        '<a href="mailto:support@example.com">support@example.com</a>'
                    );
                    ?>
                </p>
            </div>
        </div>
        <?php
    }

    public function generate_iris_class() {
        check_ajax_referer('wp-iris-generator-nonce', 'nonce');

        $module_name = sanitize_text_field($_POST['module_name']);
        $table_name = sanitize_text_field($_POST['table_name']);
        $table_description = sanitize_textarea_field($_POST['table_description']);
        $properties = array_map('trim', explode("\n", $_POST['properties']));

        // Validate required fields
        if (empty($module_name)) {
            wp_send_json_error(array(
                'message' => 'Module name is required.'
            ));
            return;
        }

        if (empty($table_name)) {
            wp_send_json_error(array(
                'message' => 'Table name is required.'
            ));
            return;
        }

        if (empty($properties) || (count($properties) === 1 && empty($properties[0]))) {
            wp_send_json_error(array(
                'message' => 'At least one property is required.'
            ));
            return;
        }

        // Validate module name
        if (preg_match('/[^a-zA-Z0-9]/', $module_name)) {
            wp_send_json_error(array(
                'message' => 'Module name cannot contain hyphens, spaces, or special characters. Use only letters and numbers.'
            ));
            return;
        }

        // Validate table name
        if (preg_match('/[^a-zA-Z0-9]/', $table_name)) {
            wp_send_json_error(array(
                'message' => 'Table name cannot contain hyphens, spaces, or special characters. Use only letters and numbers.'
            ));
            return;
        }

        // Validate property names
        foreach ($properties as $property) {
            if (empty($property)) continue;
            list($name, $type, $description) = explode(':', $property);
            if (preg_match('/[^a-zA-Z0-9]/', $name)) {
                wp_send_json_error(array(
                    'message' => 'Property name "' . $name . '" cannot contain hyphens, spaces, or special characters. Use only letters and numbers.'
                ));
                return;
            }
        }

        // Create the class content
        $class_content = $this->generate_class_content($module_name, $table_name, $table_description, $properties);

        // Create a temporary directory
        $temp_dir = wp_upload_dir()['basedir'] . '/wp-iris-generator-temp';
        wp_mkdir_p($temp_dir);

        // Create module directory
        $module_dir = $temp_dir . '/' . $module_name;
        wp_mkdir_p($module_dir);

        // Create the class file in the module directory
        $class_file = $module_dir . '/' . $table_name . '.cls';
        file_put_contents($class_file, $class_content);

        // Create a zip file
        $zip_file = $temp_dir . '/' . $module_name . '.zip';
        $zip = new ZipArchive();
        if ($zip->open($zip_file, ZipArchive::CREATE) === TRUE) {
            // Add the entire module directory to the zip
            $files = new RecursiveIteratorIterator(
                new RecursiveDirectoryIterator($module_dir),
                RecursiveIteratorIterator::LEAVES_ONLY
            );

            foreach ($files as $name => $file) {
                if (!$file->isDir()) {
                    $filePath = $file->getRealPath();
                    $relativePath = substr($filePath, strlen($module_dir) + 1);
                    $zip->addFile($filePath, $module_name . '/' . $relativePath);
                }
            }
            $zip->close();
        }

        // Send the file
        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="' . $module_name . '.zip"');
        header('Content-Length: ' . filesize($zip_file));
        readfile($zip_file);

        // Clean up
        $this->removeDirectory($temp_dir);

        wp_die();
    }

    private function removeDirectory($dir) {
        if (is_dir($dir)) {
            $objects = scandir($dir);
            foreach ($objects as $object) {
                if ($object != "." && $object != "..") {
                    if (is_dir($dir . "/" . $object)) {
                        $this->removeDirectory($dir . "/" . $object);
                    } else {
                        unlink($dir . "/" . $object);
                    }
                }
            }
            rmdir($dir);
        }
    }

    private function generate_class_content($module_name, $table_name, $table_description, $properties) {
        $content = "Class WordPressAPI.Framework." . $module_name . "." . $table_name . " Extends (%Persistent, %JSON.Adaptor, %Populate)\n{\n";
        
        // Add table description
        if (!empty($table_description)) {
            $content .= "/// " . $table_description . "\n";
        }
        
        // Add properties
        foreach ($properties as $property) {
            if (empty($property)) continue;
            list($name, $type, $description) = explode(':', $property);
            $content .= "\n/// " . $description . "\n";
            $content .= "Property " . $name . " As %String;\n";
        }
        
        // Add required methods
        $content .= "\nClassMethod List() As %DynamicObject\n{\n";
        $content .= "    set result = {\n";
        $content .= "        \"status\": (\"success\"),\n";
        $content .= "        \"data\": {\n";
        $content .= "            \"items\": [],\n";
        $content .= "            \"total\": 0\n";
        $content .= "        }\n";
        $content .= "    }\n";
        $content .= "    return result\n";
        $content .= "}\n\n";
        
        $content .= "ClassMethod GetById(id As %String) As %DynamicObject\n{\n";
        $content .= "    if '##class(" . $table_name . ").Exists(id) {\n";
        $content .= "        set result = {\n";
        $content .= "            \"status\": (\"error\"),\n";
        $content .= "            \"error\": (\"" . $table_name . " not found\")\n";
        $content .= "        }\n";
        $content .= "        return result\n";
        $content .= "    }\n\n";
        $content .= "    set result = {\n";
        $content .= "        \"status\": (\"success\"),\n";
        $content .= "        \"data\": {}\n";
        $content .= "    }\n";
        $content .= "    return result\n";
        $content .= "}\n\n";
        
        $content .= "ClassMethod Create(data As %DynamicObject) As %DynamicObject\n{\n";
        $content .= "    set result = {\n";
        $content .= "        \"status\": (\"success\"),\n";
        $content .= "        \"data\": {\n";
        $content .= "            \"id\": (\"new-id\"),\n";
        $content .= "            \"message\": (\"" . $table_name . " created successfully\")\n";
        $content .= "        }\n";
        $content .= "    }\n";
        $content .= "    return result\n";
        $content .= "}\n\n";
        
        $content .= "ClassMethod Update(id As %String, data As %DynamicObject) As %DynamicObject\n{\n";
        $content .= "    if '##class(" . $table_name . ").Exists(id) {\n";
        $content .= "        set result = {\n";
        $content .= "            \"status\": (\"error\"),\n";
        $content .= "            \"error\": (\"" . $table_name . " not found\")\n";
        $content .= "        }\n";
        $content .= "        return result\n";
        $content .= "    }\n\n";
        $content .= "    set result = {\n";
        $content .= "        \"status\": (\"success\"),\n";
        $content .= "        \"data\": {\n";
        $content .= "            \"id\": (id),\n";
        $content .= "            \"message\": (\"" . $table_name . " updated successfully\")\n";
        $content .= "        }\n";
        $content .= "    }\n";
        $content .= "    return result\n";
        $content .= "}\n\n";
        
        $content .= "}\n";
        
        return $content;
    }
}

// Initialize the plugin
WPIRISGenerator::get_instance();