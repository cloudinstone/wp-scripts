#!/usr/bin/env bash

#WordPress Batch Plugin Installer WP-CLI
#Author DressPress

CONFIG_PATH=$(wp config path)
PLUGIN_PATH=$(wp plugin path)

#specify path to WordPress installation
WP_PATH="${CONFIG_PATH/\/wp-config.php}"

echo "WP_PATH:" $WP_PATH
echo "PLUGIN_PATH:" $PLUGIN_PATH

# exit;

#define array of plugin slugs to install
PLUGINS=(svg-support wordpress-importer wpsite-show-ids woocommerce query-monitor)

#loop through array, install and activate the plugin, ${PLUGINS[@]}
for PLUGIN in "${PLUGINS[@]}"; do
#check if plugin is installed, sets exit status to 1 if not found
    wp plugin is-installed $PLUGIN --allow-root

#install plugin if not present based on exit code value
    if [ $? -eq 1 ]; then
        wp plugin install $PLUGIN --activate --allow-root
    fi
done

wp theme install blocksy --activate --allow-root

# import sample products.
wp import "${PLUGIN_PATH}/woocommerce/sample-data/sample_products.xml" --authors=create

# WooCommerce: install pages. 
wp wc tool run install_pages --user=1

#Fix permissions in case you ran as root
# sudo chown -R www-data:www-data $WPPATH
# sudo find $WPPATH -type f -exec chmod 644 {} +
# sudo find $WPPATH -type d -exec chmod 755 {} +