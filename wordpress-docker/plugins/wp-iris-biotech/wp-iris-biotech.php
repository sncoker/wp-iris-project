<?php
/**
 * Plugin Name: WP IRIS Biotech Products SEO Interface Demo
 * Plugin URI: https://github.com/sncoker
 * Description: Demo for WordPress IRIS Biotech Products SEO Interface
 * Version: 1.0.5
 * Author: Shawntelle Madison-Coker
 * Author URI: https://github.com/sncoker
 * Text Domain: wp-iris-control
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 */


// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

// Initialize products array
$products = array();

// Hook to add the admin menu page
add_action('admin_menu', 'wpl_add_admin_menu');

/**
 * Adds the admin menu page.
 */
function wpl_add_admin_menu() {
    add_menu_page(
        __('WP IRIS Biotech Interface', 'wp-iris-biotech'),
        __('WP IRIS BioTech Interface', 'wp-iris-biotech'),
        'manage_options',
        'wp-iris-biotech',
        'wpl_render_admin_page',
        'dashicons-update',
        20
    );

    // Add settings submenu
    add_submenu_page(
        'wp-iris-biotech',
        __('Settings', 'wp-iris-biotech'),
        __('Settings', 'wp-iris-biotech'),
        'manage_options',
        'wp-iris-biotech-settings',
        'wpl_render_settings_page'
    );

    //Add Help submenu
    add_submenu_page(
        'wp-iris-biotech',
        __('Help', 'wp-iris-biotech'),
        __('Help', 'wp-iris-biotech'),
        'manage_options',
        'wp-iris-biotech-help',
        'wpl_render_help_page'
    );
}

// Register settings
add_action('admin_init', 'wpl_register_settings');

function wpl_register_settings() {
    register_setting('wp_iris_biotech_settings', 'wp_iris_biotech_api_url');
}

/**
 * Renders the settings page.
 */
function wpl_render_settings_page() {
    if (!current_user_can('manage_options')) {
        wp_die(__('You do not have sufficient permissions to access this page.', 'wp-iris-biotech'));
    }

    // Handle form submission
    if (isset($_POST['submit']) && isset($_POST['wp_iris_biotech_api_url'])) {
        // Verify nonce
        if (!isset($_POST['wp_iris_biotech_nonce']) || !wp_verify_nonce($_POST['wp_iris_biotech_nonce'], 'wp_iris_biotech_settings')) {
            wp_die(__('Security check failed.', 'wp-iris-biotech'));
        }

        $api_url = trim($_POST['wp_iris_biotech_api_url']);
        
        // Validate URL
        if (empty($api_url)) {
            echo '<div class="notice notice-error"><p>' . esc_html__('API URL cannot be empty.', 'wp-iris-biotech') . '</p></div>';
        } elseif (!filter_var($api_url, FILTER_VALIDATE_URL)) {
            echo '<div class="notice notice-error"><p>' . esc_html__('Please enter a valid URL.', 'wp-iris-biotech') . '</p></div>';
        } else {
            // Save the URL
            $updated = update_option('wp_iris_biotech_api_url', $api_url);
            if ($updated) {
                echo '<div class="notice notice-success"><p>' . esc_html__('Settings saved successfully!', 'wp-iris-biotech') . '</p></div>';
            } else {
                echo '<div class="notice notice-warning"><p>' . esc_html__('Settings were not changed.', 'wp-iris-biotech') . '</p></div>';
            }
        }
    }

    // Get current URL with fallback to default
    $current_url = get_option('wp_iris_biotech_api_url', 'http://iris:52773/csp/wpapi/wp/biotech/products');
    ?>
    <div class="wrap">
        <h1><?php echo esc_html__('WP IRIS Biotech Interface Settings', 'wp-iris-biotech'); ?></h1>
        <form method="post" action="">
            <?php wp_nonce_field('wp_iris_biotech_settings', 'wp_iris_biotech_nonce'); ?>
            <table class="form-table">
                <tr>
                    <th scope="row">
                        <label for="wp_iris_biotech_api_url"><?php echo esc_html__('API URL', 'wp-iris-biotech'); ?></label>
                    </th>
                    <td>
                        <input type="url" 
                               name="wp_iris_biotech_api_url" 
                               id="wp_iris_biotech_api_url" 
                               value="<?php echo esc_attr($current_url); ?>" 
                               class="regular-text"
                               placeholder="http://iris:52773/csp/wpapi/wp/biotech/products"
                               required>
                        <p class="description">
                            <?php echo esc_html__('Enter the full URL for the IRIS API endpoint.', 'wp-iris-biotech'); ?>
                        </p>
                    </td>
                </tr>
            </table>
            <?php submit_button(); ?>
        </form>
    </div>
    <?php
}

/**
 * Generate dynamic SEO meta tags
 */
function set_product_seo_meta() {
    global $products;
    
    if (!is_page('biotech-products')) {
        return;
    }
    
    // Ensure products array is initialized
    if (!isset($products) || !is_array($products)) {
        $products = array();
    }
    
    echo '<meta name="description" content="High-quality antibodies, ELISA kits, and recombinant proteins for research.">';
    // Add schema markup (JSON-LD) here
}
add_action('wp_head', 'set_product_seo_meta');

/**
 * Renders the admin page content.
 */
function wpl_render_admin_page() {
    // Check user capabilities
    if (!current_user_can('manage_options')) {
        wp_die(__('You do not have sufficient permissions to access this page.', 'wp-iris-biotech'));
    }

    // Handle SEO import actions
    if (isset($_POST['import_seo']) && check_admin_referer('wp_iris_biotech_import_seo', 'wp_iris_biotech_nonce')) {
        wpl_import_product_seo();
    } elseif (isset($_POST['clear_seo']) && check_admin_referer('wp_iris_biotech_clear_seo', 'wp_iris_biotech_nonce')) {
        wpl_clear_product_seo();
    }

    // Get the API URL from options with fallback
    $api_url = get_option('wp_iris_biotech_api_url', '');
    
    // Get last import date
    $last_import = get_option('wp_iris_biotech_last_import', '');
    $last_import_display = $last_import ? date('F j, Y g:i a', strtotime($last_import)) : 'Never';
    
    // Check if API URL is set and valid
    if (empty($api_url) || !filter_var($api_url, FILTER_VALIDATE_URL)) {
        echo '<div class="notice notice-warning"><p>';
        printf(
            /* translators: %s: Settings page URL */
            esc_html__('Please configure a valid API URL in the %s.', 'wp-iris-biotech'),
            '<a href="' . esc_url(admin_url('admin.php?page=wp-iris-biotech-settings')) . '">' . esc_html__('Settings', 'wp-iris-biotech') . '</a>'
        );
        echo '</p></div>';
        return;
    }

    // Fetch data from IRIS API with error handling
    $response = wp_remote_get($api_url, array(
        'timeout' => 15,
        'headers' => array(
            'Accept' => 'application/json'
        )
    ));

    if (is_wp_error($response)) {
        $error_message = $response->get_error_message();
        error_log('WP IRIS Biotech API Error: ' . $error_message);
        echo '<div class="error"><p>' . esc_html__('Error fetching products: ', 'wp-iris-biotech') . esc_html($error_message) . '</p></div>';
        return;
    }

    $body = wp_remote_retrieve_body($response);
    $products = json_decode($body, true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        $json_error = json_last_error_msg();
        error_log('WP IRIS Biotech JSON Error: ' . $json_error);
        echo '<div class="error"><p>' . esc_html__('Error parsing product data: ', 'wp-iris-biotech') . esc_html($json_error) . '</p></div>';
        return;
    }

    if (!is_array($products)) {
        $products = array();
        error_log('WP IRIS Biotech Warning: Products data is not an array');
    }
    ?>
    <div class="wrap">
        <h1><?php echo esc_html__('WP IRIS Biotech Products', 'wp-iris-biotech'); ?></h1>
        
        <!-- SEO Import Buttons -->
        <div class="seo-import-actions" style="margin: 20px 0; display: flex; align-items: center; gap: 20px;">
            <form method="post" action="">
                <?php wp_nonce_field('wp_iris_biotech_import_seo', 'wp_iris_biotech_nonce'); ?>
                <input type="submit" name="import_seo" class="button button-primary" value="<?php echo esc_attr__('Import Product Data into Yoast SEO', 'wp-iris-biotech'); ?>">
            </form>
            <form method="post" action="">
                <?php wp_nonce_field('wp_iris_biotech_clear_seo', 'wp_iris_biotech_nonce'); ?>
                <input type="submit" name="clear_seo" class="button button-secondary" value="<?php echo esc_attr__('Clear SEO Values', 'wp-iris-biotech'); ?>">
            </form>
            <div class="last-import-info" style="color: #666;">
                <?php 
                printf(
                    /* translators: %s: Last import date */
                    esc_html__('Last import: %s', 'wp-iris-biotech'),
                    '<strong>' . esc_html($last_import_display) . '</strong>'
                );
                ?>
            </div>
        </div>
        
        <!-- Display products in a filterable table -->
        <div class="product-filters" style="margin-top:10px;margin-bottom:10px;">
            <select id="application-filter">
                <option value=""><?php echo esc_html__('Filter by Application', 'wp-iris-biotech'); ?></option>
                <option value="ELISA"><?php echo esc_html__('ELISA', 'wp-iris-biotech'); ?></option>
                <option value="Western Blot"><?php echo esc_html__('Western Blot', 'wp-iris-biotech'); ?></option>
                <option value="Flow Cytometry"><?php echo esc_html__('Flow Cytometry', 'wp-iris-biotech'); ?></option>
                <option value="IHC"><?php echo esc_html__('IHC', 'wp-iris-biotech'); ?></option>
            </select>
        </div>
        
        <table id="product-table" class="wp-list-table widefat fixed striped">
            <thead>
                <tr>
                    <th><?php echo esc_html__('Product Name', 'wp-iris-biotech'); ?></th>
                    <th><?php echo esc_html__('Catalog Number', 'wp-iris-biotech'); ?></th>
                    <th><?php echo esc_html__('Target', 'wp-iris-biotech'); ?></th>
                    <th><?php echo esc_html__('Host Species', 'wp-iris-biotech'); ?></th>
                    <th><?php echo esc_html__('Applications', 'wp-iris-biotech'); ?></th>
                    <th><?php echo esc_html__('Product Class', 'wp-iris-biotech'); ?></th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($products as $product): 
                    // Skip invalid product entries
                    if (!isset($product['productName']) || !isset($product['catalogNumber'])) {
                        error_log('WP IRIS Biotech Warning: Invalid product data structure');
                        continue;
                    }

                    // Check if a page exists with this product name
                    $product_page = get_page_by_title($product['productName'], OBJECT, 'page');
                    $has_product_page = !empty($product_page) && $product_page->post_status === 'publish';
                ?>
                <tr>
                    <td>
                        <?php if ($has_product_page): ?>
                            <a href="<?php echo esc_url(get_permalink($product_page)); ?>">
                                <?php echo esc_html($product['productName']); ?>
                            </a>
                            <span class="dashicons dashicons-yes-alt" style="color: #46b450; vertical-align: middle;"></span>
                        <?php else: ?>
                            <?php echo esc_html($product['productName']); ?>
                            <span class="dashicons dashicons-dismiss" style="color: #dc3232; vertical-align: middle;"></span>
                        <?php endif; ?>
                    </td>
                    <td><?php echo esc_html($product['catalogNumber']); ?></td>
                    <td><?php echo esc_html($product['target'] ?? 'N/A'); ?></td>
                    <td><?php echo esc_html($product['hostSpecies'] ?? 'N/A'); ?></td>
                    <td><?php echo esc_html($product['applications'] ?? 'N/A'); ?></td>
                    <td><?php echo esc_html($product['productClass']['className'] ?? 'N/A'); ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>

    <!-- Add JavaScript for client-side filtering -->
    <script>
    document.getElementById('application-filter').addEventListener('change', (e) => {
        const filterValue = e.target.value.toLowerCase();
        Array.from(document.querySelectorAll('#product-table tbody tr')).forEach(row => {
            const appText = row.querySelector('td:nth-child(5)').textContent.toLowerCase();
            row.style.display = appText.includes(filterValue) ? '' : 'none';
        });
    });
    </script>
    <?php
}

/**
 * Import product data into Yoast SEO
 * 
 * @return void
 */
function wpl_import_product_seo() {
    // Get the API URL
    $api_url = get_option('wp_iris_biotech_api_url');
    if (empty($api_url)) {
        return;
    }

    // Fetch product data
    $response = wp_remote_get($api_url, array(
        'timeout' => 15,
        'headers' => array(
            'Accept' => 'application/json'
        )
    ));

    if (is_wp_error($response)) {
        return;
    }

    $body = wp_remote_retrieve_body($response);
    $products = json_decode($body, true);

    if (!is_array($products)) {
        return;
    }

    // Loop through products and update SEO
    foreach ($products as $product) {
        if (!isset($product['productName'])) {
            continue;
        }

        // Find page with matching title
        $page = get_page_by_title($product['productName'], OBJECT, 'page');
        if ($page) {
            wpl_update_page_seo($page->ID, $product);
        }
    }

    // Update last import date
    update_option('wp_iris_biotech_last_import', current_time('mysql'));

    // Show success message
    add_action('admin_notices', function() {
        echo '<div class="notice notice-success"><p>' . esc_html__('Product SEO data imported successfully!', 'wp-iris-biotech') . '</p></div>';
    });
}

/**
 * Update SEO values for a specific page
 * 
 * @param int $page_id The ID of the page to update SEO for.
 * @param array $product The product data to use for SEO updates.
 * @return bool True if SEO update was attempted, false on critical failure.
 */
function wpl_update_page_seo($page_id, $product) {
    // Define opening words for randomization
    $opening_words = array(
        'Explore',
        'Discover',
        'Check out',
        'Learn about',
        'Examine',
        'Review'
    );

    $replace_ideal_words = array(
        'Ideal',
        'Perfect',
        'Great',
        'Excellent'
    );

    // Randomly select an opening word
    $opening_word = $opening_words[array_rand($opening_words)];

    //Randomly select an ideal word
    $ideal_word = $replace_ideal_words[array_rand($replace_ideal_words)];

    // Format product class names with "and" if multiple
    $product_classes = explode(',', $product['productClass']['className']);
    $formatted_classes = count($product_classes) > 1 
        ? implode(' and ', array_map('trim', $product_classes))
        : $product['productClass']['className'];

    // Create base meta description without "Learn more"
    $base_metadesc = sprintf(
        '%s our rigorously tested %s. %s for accurate %s. Derived from %s.',
        $opening_word,
        $product['productName'],
        $ideal_word,
        $formatted_classes,
        $product['hostSpecies']
    );

    // Add "Learn more" only if total length is under 150 characters to optimize for SEO
    $metadesc = (strlen($base_metadesc) + 11 <= 150) 
        ? $base_metadesc . ' Learn more.'
        : $base_metadesc;

    // Prepare SEO data based on product information
    $seo_data = array(
        'title' => sprintf(
            '%s',
            $product['productName']
        ),
        'metadesc' => $metadesc,
        'focuskw' => $product['productName'],
        'og_title' => $product['productName'],
        'og_desc' => sprintf(
            '%s - %s. Applications: %s',
            $product['productName'],
            $product['productClass']['className'],
            $product['applications']
        ),
        'noindex' => 0,
        'nofollow' => 0
    );

    // Call the reference function to save SEO data
    return wp_iris_save_yoast_seo_data($page_id, $seo_data);
}

/**
 * Saves custom SEO data to Yoast SEO meta fields for a specific post.
 * 
 * @param int $post_id The ID of the post to save SEO data for.
 * @param array $seo_data An associative array of SEO data.
 * @return bool True if data saving was attempted, false on critical failure.
 */
function wp_iris_save_yoast_seo_data(int $post_id, array $seo_data): bool {
    // 1. --- Basic Validation ---
    if ($post_id <= 0) {
        error_log('WP IRIS Biotech: Invalid Post ID provided: ' . $post_id);
        return false;
    }

    // Check if the post exists
    if (!get_post($post_id)) {
        error_log('WP IRIS Biotech: Post ID does not exist: ' . $post_id);
        return false;
    }

    // 2. --- Check if Yoast SEO is Active ---
    if (!function_exists('is_plugin_active')) {
        include_once(ABSPATH . 'wp-admin/includes/plugin.php');
    }

    if (!is_plugin_active('wordpress-seo/wp-seo.php') && !class_exists('WPSEO_Meta')) {
        error_log('WP IRIS Biotech: Yoast SEO plugin is not active. Cannot save SEO data for post ID: ' . $post_id);
        return false;
    }

    // 3. --- Define Key Mapping (Input Key => Yoast Meta Key) ---
    $key_map = [
        'title' => '_yoast_wpseo_title',
        'metadesc' => '_yoast_wpseo_metadesc',
        'focuskw' => '_yoast_wpseo_focuskw',
        'canonical' => '_yoast_wpseo_canonical',
        'og_title' => '_yoast_wpseo_opengraph-title',
        'og_desc' => '_yoast_wpseo_opengraph-description',
        'og_image' => '_yoast_wpseo_opengraph-image',
        'og_image_id' => '_yoast_wpseo_opengraph-image-id',
        'twitter_title' => '_yoast_wpseo_twitter-title',
        'twitter_desc' => '_yoast_wpseo_twitter-description',
        'twitter_image' => '_yoast_wpseo_twitter-image',
        'twitter_image_id' => '_yoast_wpseo_twitter-image-id',
        'noindex' => '_yoast_wpseo_meta-robots-noindex',
        'nofollow' => '_yoast_wpseo_meta-robots-nofollow',
    ];

    // 4. --- Iterate through Input Data, Sanitize, and Save ---
    foreach ($seo_data as $input_key => $value) {
        if (isset($key_map[$input_key])) {
            $meta_key = $key_map[$input_key];
            $sanitized_value = null;

            switch ($meta_key) {
                case '_yoast_wpseo_title':
                case '_yoast_wpseo_focuskw':
                case '_yoast_wpseo_opengraph-title':
                case '_yoast_wpseo_twitter-title':
                    $sanitized_value = sanitize_text_field($value);
                    break;

                case '_yoast_wpseo_metadesc':
                case '_yoast_wpseo_opengraph-description':
                case '_yoast_wpseo_twitter-description':
                    $sanitized_value = sanitize_textarea_field($value);
                    break;

                case '_yoast_wpseo_canonical':
                case '_yoast_wpseo_opengraph-image':
                case '_yoast_wpseo_twitter-image':
                    $sanitized_value = esc_url_raw($value);
                    break;

                case '_yoast_wpseo_opengraph-image-id':
                case '_yoast_wpseo_twitter-image-id':
                case '_yoast_wpseo_meta-robots-noindex':
                case '_yoast_wpseo_meta-robots-nofollow':
                    $sanitized_value = absint($value);
                    break;

                default:
                    $sanitized_value = sanitize_text_field($value);
                    break;
            }

            update_post_meta($post_id, $meta_key, $sanitized_value);
        }
    }

    // Clear Yoast's analysis cache
    if (class_exists('Yoast\WP\SEO\Actions\Indexation\Indexable_Post_Indexation_Action')) {
        try {
            YoastSEO()->classes->get(Yoast\WP\SEO\Actions\Indexation\Indexable_Post_Indexation_Action::class)->index($post_id);
        } catch (Exception $e) {
            error_log("WP IRIS Biotech: Yoast Indexation failed for post {$post_id}: " . $e->getMessage());
        }
    } elseif (class_exists('WPSEO_Meta')) {
        delete_post_meta($post_id, '_yoast_wpseo_linkdex');
    }

    return true;
}

/**
 * Clear SEO values for all product pages
 */
function wpl_clear_product_seo() {
    // Get the API URL
    $api_url = get_option('wp_iris_biotech_api_url');
    if (empty($api_url)) {
        add_action('admin_notices', function() {
            echo '<div class="notice notice-error"><p>' . esc_html__('API URL is not configured. Please set it in the settings page.', 'wp-iris-biotech') . '</p></div>';
        });
        return;
    }

    // Fetch product data
    $response = wp_remote_get($api_url, array(
        'timeout' => 15,
        'headers' => array(
            'Accept' => 'application/json'
        )
    ));

    if (is_wp_error($response)) {
        add_action('admin_notices', function() use ($response) {
            echo '<div class="notice notice-error"><p>' . esc_html__('Error fetching products: ', 'wp-iris-biotech') . esc_html($response->get_error_message()) . '</p></div>';
        });
        return;
    }

    $body = wp_remote_retrieve_body($response);
    $products = json_decode($body, true);

    if (!is_array($products)) {
        add_action('admin_notices', function() {
            echo '<div class="notice notice-error"><p>' . esc_html__('Invalid product data received from API.', 'wp-iris-biotech') . '</p></div>';
        });
        return;
    }

    $cleared_count = 0;
    $errors = array();

    // Define all Yoast SEO meta keys to clear
    $yoast_meta_keys = array(
        '_yoast_wpseo_title',
        '_yoast_wpseo_metadesc',
        '_yoast_wpseo_focuskw',
        '_yoast_wpseo_canonical',
        '_yoast_wpseo_opengraph-title',
        '_yoast_wpseo_opengraph-description',
        '_yoast_wpseo_opengraph-image',
        '_yoast_wpseo_opengraph-image-id',
        '_yoast_wpseo_twitter-title',
        '_yoast_wpseo_twitter-description',
        '_yoast_wpseo_twitter-image',
        '_yoast_wpseo_twitter-image-id',
        '_yoast_wpseo_meta-robots-noindex',
        '_yoast_wpseo_meta-robots-nofollow',
        '_yoast_wpseo_linkdex'
    );

    // Loop through products and clear SEO
    foreach ($products as $product) {
        if (!isset($product['productName'])) {
            continue;
        }

        // Find page with matching title
        $page = get_page_by_title($product['productName'], OBJECT, 'page');
        if ($page) {
            // Clear all Yoast SEO meta fields
            foreach ($yoast_meta_keys as $meta_key) {
                delete_post_meta($page->ID, $meta_key);
            }

            // Clear Yoast's analysis cache
            if (class_exists('Yoast\WP\SEO\Actions\Indexation\Indexable_Post_Indexation_Action')) {
                try {
                    YoastSEO()->classes->get(Yoast\WP\SEO\Actions\Indexation\Indexable_Post_Indexation_Action::class)->index($page->ID);
                } catch (Exception $e) {
                    $errors[] = sprintf(
                        /* translators: %1$s: Product name, %2$s: Error message */
                        esc_html__('Failed to clear cache for %1$s: %2$s', 'wp-iris-biotech'),
                        $product['productName'],
                        $e->getMessage()
                    );
                }
            }

            $cleared_count++;
        }
    }

    // Update last import date to empty
    update_option('wp_iris_biotech_last_import', '');

    // Show success/error messages
    add_action('admin_notices', function() use ($cleared_count, $errors) {
        if ($cleared_count > 0) {
            echo '<div class="notice notice-success"><p>';
            printf(
                /* translators: %d: Number of pages cleared */
                esc_html__('Successfully cleared SEO data for %d pages.', 'wp-iris-biotech'),
                $cleared_count
            );
            echo '</p></div>';
        }

        if (!empty($errors)) {
            echo '<div class="notice notice-warning"><p>';
            echo esc_html__('Some errors occurred while clearing SEO data:', 'wp-iris-biotech');
            echo '<ul style="margin-left: 20px;">';
            foreach ($errors as $error) {
                echo '<li>' . $error . '</li>';
            }
            echo '</ul>';
            echo '</p></div>';
        }
    });
}

/**
 * Renders the help page content.
 */
function wpl_render_help_page() {
    if (!current_user_can('manage_options')) {
        wp_die(__('You do not have sufficient permissions to access this page.', 'wp-iris-biotech'));
    }
    ?>
    <div class="wrap">
        <h1><?php echo esc_html__('WP IRIS Biotech Help', 'wp-iris-biotech'); ?></h1>
        
        <div class="help-content" style="max-width: 800px;">
            <h2><?php echo esc_html__('Getting Started', 'wp-iris-biotech'); ?></h2>
            <p><?php echo esc_html__('Welcome to the WP IRIS Biotech plugin help section. This guide will help you understand and use the plugin effectively.', 'wp-iris-biotech'); ?></p>

            <h3><?php echo esc_html__('Basic Setup', 'wp-iris-biotech'); ?></h3>
            <ol>
                <li><?php echo esc_html__('Configure the API URL in the Settings page', 'wp-iris-biotech'); ?></li>
                <li><?php echo esc_html__('Ensure your product pages exist in WordPress', 'wp-iris-biotech'); ?></li>
                <li><?php echo esc_html__('Use the Import button to update SEO data', 'wp-iris-biotech'); ?></li>
            </ol>

            <h3><?php echo esc_html__('SEO Features', 'wp-iris-biotech'); ?></h3>
            <ul>
                <li><?php echo esc_html__('Automatically generates optimized meta descriptions', 'wp-iris-biotech'); ?></li>
                <li><?php echo esc_html__('Creates SEO-friendly titles', 'wp-iris-biotech'); ?></li>
                <li><?php echo esc_html__('Updates OpenGraph data for social sharing', 'wp-iris-biotech'); ?></li>
            </ul>

            <h3><?php echo esc_html__('Troubleshooting', 'wp-iris-biotech'); ?></h3>
            <div class="notice notice-info">
                <p><?php echo esc_html__('If you encounter any issues:', 'wp-iris-biotech'); ?></p>
                <ul style="margin-left: 20px;">
                    <li><?php echo esc_html__('Check that the API URL is correct and accessible', 'wp-iris-biotech'); ?></li>
                    <li><?php echo esc_html__('Verify that product pages exist with matching titles', 'wp-iris-biotech'); ?></li>
                    <li><?php echo esc_html__('Ensure Yoast SEO plugin is active', 'wp-iris-biotech'); ?></li>
                </ul>
            </div>

            <h3><?php echo esc_html__('Need More Help?', 'wp-iris-biotech'); ?></h3>
            <p>
                <?php 
                printf(
                    /* translators: %s: Support email */
                    esc_html__('For additional assistance, please contact support at %s', 'wp-iris-biotech'),
                    '<a href="mailto:support@example.com">support@example.com</a>'
                );
                ?>
            </p>
        </div>
    </div>
    <?php
}


