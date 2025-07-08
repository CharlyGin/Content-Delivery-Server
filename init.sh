#!/bin/sh

AVAILABLE="/etc/nginx/conf.d/sites-available"
ENABLED="/etc/nginx/conf.d/sites-enabled"

echo "HTTPS_ON: $HTTPS_ON"
echo "HTTP_ON: $HTTP_ON"
echo "SERVER_NAME: $SERVER_NAME"

echo "Updating server name"
sed -i "s|^server_name .*|server_name ${SERVER_NAME};|" /etc/nginx/nginxconfig.io/general.conf

if [ "$HTTPS_ON" = "true" ]; then
    echo "HTTPS is enabled."
    if [ ! -f "${ENABLED}/ssl.conf" ]; then
        echo "Enabling SSL config..."
        ln -s "${AVAILABLE}/ssl.conf" "${ENABLED}/ssl.conf"
    else
        echo "SSL config already enabled."
    fi

    if [ "$HTTP_ON" = "false" ]; then
        echo "Either HTTP is disabled, enabling redirect."
        if [ ! -f "${ENABLED}/redirect.conf" ]; then
            echo "Enabling redirect.conf..."
            ln -s "${AVAILABLE}/redirect.conf" "${ENABLED}/redirect.conf"
        else
            echo "redirect.conf already enabled."
        fi
    fi 
else
    echo "HTTPS is disabled."
    if [ -f "${ENABLED}/ssl.conf" ]; then
        echo "Removing SSL config..."
        rm -f "${ENABLED}/ssl.conf"
    fi

    echo "Redirect is disabled."
    if [ -f "${ENABLED}/redirect.conf" ]; then
        echo "Removing redirect.conf..."
        rm -f "${ENABLED}/redirect.conf"
    fi
fi

if [ "$HTTP_ON" = "true" ]; then
    echo "Both HTTP are enabled."
    if [ ! -f "${ENABLED}/site.conf" ]; then
        echo "Enabling site.conf..."
        ln -s "${AVAILABLE}/site.conf" "${ENABLED}/site.conf"
    else
        echo "site.conf already enabled."
    fi
else
    if [ -f "${ENABLED}/site.conf" ]; then
        echo "Removing site.conf..."
        rm -f "${ENABLED}/site.conf"
    fi
fi

echo "Starting nginx..."
nginx -g "daemon off;"
