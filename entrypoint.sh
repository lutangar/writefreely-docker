#!/bin/sh

# Path to your ini file
INI_FILE="config.ini"

# Function to update ini file
update_ini() {
    section=$1
    key=$2
    value=$3

    # Escape special characters in the value
    value=$(echo "$value" | sed -e 's/[\/&]/\\&/g')

    # Use sed to set the value in the ini file
    sed -i "/^\[$section\]/,/^\[/ s/^\($key\s*=\s*\).*\$/\1$value/" "$INI_FILE"
}

# Print available environment variable names
echo "Available environment variables to configure the INI file:"

# Read the ini file and update values from environment variables
while IFS= read -r line; do
    # Skip empty lines and comments
    if [ -z "$line" ] || echo "$line" | grep -qE '^\s*#'; then
        continue
    fi

    # Check for section headers
    if echo "$line" | grep -qE '^\[(.*)\]$'; then
        section=$(echo "$line" | sed -nE 's/^\[(.*)\]$/\1/p')
        continue
    fi

    # Check for key-value pairs
    if echo "$line" | grep -qE '^[^=]+='; then
        key=$(echo "$line" | sed -nE 's/^([^=]+)\s*=.*/\1/p' | tr -d ' ')
        value=$(echo "$line" | sed -nE 's/^[^=]+\s*=\s*(.*)/\1/p')

        # Generate the environment variable name by converting key to uppercase and replacing dots with underscores
        env_var_name=$(echo "${section}_${key}" | tr '[:lower:]' '[:upper:]' | tr '.' '_')

        # Print the environment variable name
        echo "$env_var_name"

        # If the environment variable is set, update the ini file
        if [ -n "$(eval echo \$$env_var_name)" ]; then
            update_ini "$section" "$key" "$(eval echo \$$env_var_name)"
        fi
    fi
done < "$INI_FILE"

if [ "$INIT_DB" = "true" ]; then
    if [ ! -z "$DATABASE_FILENAME" ]; then
      mkdir -p "$(dirname "${DATABASE_FILENAME}")"
    fi

    echo "Initializing database with 'writefreely db init'"
    writefreely db init
fi

if [ "$GENERATE_KEYS" = "true" ]; then
    echo "Generating new keys with 'writefreely keys generate'"
    writefreely keys generate
fi

if [ "$CREATE_ADMIN" = "true" ]; then
    echo "Create admin user"
    writefreely user create --admin "$DATABASE_USERNAME":"$DATABASE_PASSWORD"
fi

exec "$@"