# writefreely-docker

This repository contains Docker and Docker Compose configurations for running __WriteFreely__, a minimalist, federated blogging platform.

## Getting started

Create a `.env` configuration file, base on one of the provided model:
```sh
cp .env.sqlite .env
```

Run one of the docker compose file:
```sh
docker compose up
```

Comment variables used for first run:
```sh
INIT_DB=true
GENERATE_KEYS=true
CREATE_ADMIN=true
```

Available environment variables are:
```sh
SERVER_HIDDEN_HOST
SERVER_PORT
SERVER_BIND
SERVER_TLS_CERT_PATH
SERVER_TLS_KEY_PATH
SERVER_AUTOCERT
SERVER_TEMPLATES_PARENT_DIR
SERVER_STATIC_PARENT_DIR
SERVER_PAGES_PARENT_DIR
SERVER_KEYS_PARENT_DIR
DATABASE_TYPE
DATABASE_FILENAME
DATABASE_USERNAME
DATABASE_PASSWORD
DATABASE_DATABASE
DATABASE_HOST
DATABASE_PORT
APP_SITE_NAME
APP_SITE_DESCRIPTION
APP_HOST
APP_THEME
APP_EDITOR
APP_DISABLE_JS
APP_WEBFONTS
APP_LANDING
APP_SIMPLE_NAV
APP_WF_MODESTY
APP_CHORUS
APP_DISABLE_DRAFTS
APP_SINGLE_USER
APP_OPEN_REGISTRATION
APP_MIN_USERNAME_LEN
APP_MAX_BLOGS
APP_FEDERATION
APP_PUBLIC_STATS
APP_PRIVATE
APP_LOCAL_TIMELINE
APP_USER_INVITES
APP_DEFAULT_VISIBILITY
```

## Utilities

Generate keys locally:
```sh
docker run --rm -v $(pwd)/keys:/var/lib/writefreely/keys/ myapp writefreely keys generate
```

Create an admin user:
```sh 
docker compose exec writefreely-web writefreely user create --admin admin:password
```

Create standard user:
```sh
docker compose exec writefreely-web writefreely user create username:password
```

### Customize

Copy `pages`, `static` and `templates` locally:
```sh
docker cp writefreely-web:/usr/share/writefreely/. .
```
And mount these folder back to :
- `/usr/share/writefreely/pages`
- `/usr/share/writefreely/static`
- `/usr/share/writefreely/templates`

## Examples
Test a __WriteFreely__ setup with `sqlite`:
```sh
docker compose --env-file .env.sqlite up
```

Test the `single_user` mode:
```sh
APP_SINGLE_USER=true docker compose --env-file .env.sqlite up
```

Test `mariadb` configuration:
```sh
docker compose up --build -f docker-compose.maria.yml --env-file .env.maria
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.