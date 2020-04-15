[![Layers](https://images.microbadger.com/badges/image/edyan/satisfy.svg)](https://microbadger.com/images/edyan/satisfy "Get your own image badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/edyan/satisfy.svg)](https://hub.docker.com/r/edyan/satisfy/)
[![Build Status](https://travis-ci.com/edyan/docker-php.svg?branch=master)](https://travis-ci.com/edyan/docker-php)

## Satisfy (Satis) Server
Docker Hub: https://hub.docker.com/r/edyan/satisfy

Composer self-hosted server based on [Satisfy](https://github.com/ludofleury/satisfy).

## Setup
### Create parameters.yml locally
The default content is the following, adapt to your needs :
```yaml
parameters:
    secret: ThisTokenIsNotSoSecretChangeIt
    satis_filename: '%kernel.project_dir%/satis.json'
    satis_log_path: '%kernel.project_dir%/var/satis'
    admin.auth: false
    admin.users: null
    composer.home: '%kernel.project_dir%/var/composer'
    github.secret: null
    gitlab.secret: null
    gitlab.auto_add_repo: false
    gitlab.auto_add_repo_type: null
```

### Create satis.json locally
The default content is the following, adapt to your needs :
```yaml
{
  "name": "my/repository",
  "homepage": "http://packages.example.org",
  "repositories": [],
  "require-all": true
}
```

### HTTP Auth
To be able to connect to repositories with an HTTP auth,
mount a `.git-credentials` to `/home/www-data/.git-credentials` containing :
```json
https://username:Password@gitlab.domain.tld
```

### Run Image
```bash
# Start a container with parameters.yml, satis.json and composer/ mounted
docker run -p 8080:8080 \
    -v $(pwd)/.git-credentials:/home/www-data/.git-credentials \
    -v $(pwd)/satis.json:/app/satis.json \
    -v $(pwd)/parameters.yml:/app/config/parameters.yml \
    -v $(pwd)/composer:/app/var/composer \
    --rm \
    edyan/satisfy
```


### Do your first configuration
Enjoy http://127.0.0.1:8080 !
