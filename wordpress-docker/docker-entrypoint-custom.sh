#!/bin/bash
set -e

echo "Starting WordPress container..."

# Set WordPress path
WP_PATH="/var/www/html"

# Wait for DB to be ready
echo "Waiting for database to be ready..."
until wp db check --path="$WP_PATH" --allow-root; do
  echo "Database not ready yet. Waiting..."
  sleep 5
done

echo "Database is ready!"

# Check if WordPress is installed
if [ ! -f "$WP_PATH/wp-config.php" ]; then
  echo "WordPress not found. Downloading and installing..."
  
  # Download WordPress
  wp core download --path="$WP_PATH" --allow-root
  
  # Create wp-config.php
  wp config create --path="$WP_PATH" \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --allow-root
  
  # Import database dump if it exists
  if [ -f /tmp/wp-dump.sql ]; then
    echo "Importing database dump..."
    wp db import /tmp/wp-dump.sql --path="$WP_PATH" --allow-root
    
    # Configure permalinks
    echo "Configuring permalinks..."
    wp rewrite structure '/%postname%/' --path="$WP_PATH" --allow-root
    wp rewrite flush --hard --path="$WP_PATH" --allow-root
    
    # Ensure .htaccess exists and has correct permissions
    if [ ! -f "$WP_PATH/.htaccess" ]; then
      echo "Creating .htaccess file..."
      cat > "$WP_PATH/.htaccess" << 'EOL'
# BEGIN WordPress
# The directives (lines) between "BEGIN WordPress" and "END WordPress" are
# dynamically generated, and should only be modified via WordPress filters.
# Any changes to the directives between these markers will be overwritten.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOL
      chmod 644 "$WP_PATH/.htaccess"
    fi
  else
    echo "No database dump found at /tmp/wp-dump.sql"
    echo "Installing fresh WordPress..."
    wp core install --path="$WP_PATH" \
      --url="${WORDPRESS_URL:-http://localhost}" \
      --title="${WORDPRESS_TITLE:-WordPress Site}" \
      --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
      --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin}" \
      --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
      --skip-email \
      --allow-root
  fi
else
  echo "WordPress is already installed."
  
  # Check if database is empty and import dump if needed
  if ! wp db tables --path="$WP_PATH" --allow-root | grep -q "wp_posts"; then
    if [ -f /tmp/wp-dump.sql ]; then
      echo "Database is empty. Importing database dump..."
      wp db import /tmp/wp-dump.sql --path="$WP_PATH" --allow-root
      
      # Configure permalinks
      echo "Configuring permalinks..."
      wp rewrite structure '/%postname%/' --path="$WP_PATH" --allow-root
      wp rewrite flush --hard --path="$WP_PATH" --allow-root
      
      # Ensure .htaccess exists and has correct permissions
      if [ ! -f "$WP_PATH/.htaccess" ]; then
        echo "Creating .htaccess file..."
        cat > "$WP_PATH/.htaccess" << 'EOL'
# BEGIN WordPress
# The directives (lines) between "BEGIN WordPress" and "END WordPress" are
# dynamically generated, and should only be modified via WordPress filters.
# Any changes to the directives between these markers will be overwritten.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOL
        chmod 644 "$WP_PATH/.htaccess"
      fi
    else
      echo "Database is empty but no dump file found."
    fi
  else
    echo "Database already contains WordPress tables."
    
    # Configure permalinks
    echo "Configuring permalinks..."
    wp rewrite structure '/%postname%/' --path="$WP_PATH" --allow-root
    wp rewrite flush --hard --path="$WP_PATH" --allow-root
    
    # Ensure .htaccess exists and has correct permissions
    if [ ! -f "$WP_PATH/.htaccess" ]; then
      echo "Creating .htaccess file..."
      cat > "$WP_PATH/.htaccess" << 'EOL'
# BEGIN WordPress
# The directives (lines) between "BEGIN WordPress" and "END WordPress" are
# dynamically generated, and should only be modified via WordPress filters.
# Any changes to the directives between these markers will be overwritten.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOL
      chmod 644 "$WP_PATH/.htaccess"
    fi
  fi
fi

# Enable mod_rewrite in Apache
echo "Enabling mod_rewrite..."
a2enmod rewrite

echo "Starting Apache..."
exec docker-entrypoint.sh apache2-foreground