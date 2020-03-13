# HoodSavy

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

To Use self-signed SSL in developement:

  1. run `openssl req -new -x509 -nodes -out dev.crt -keyout priv/cert/dev.key`
  2. visit `https://localhost:4001`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Deployment
### Building Release

1. Set version number

```
export RELEASE_VERSION=<release version>
```

2. Run these commands

```
docker build -f Dockerfile -t hood_savy --build-arg RELEASE_VERSION .
docker run --rm -v /tmp:/app/tmp hood_savy bash -c "cp release-$RELEASE_VERSION.tar /app/tmp/"
```

3. Find your relese in `/tmp`

### Create Your DB Instance

- Remember to write down Host, User, Password, DB

### Run Your Release

1. Copy release to server.

2. Run `sudo ./deploy.sh`

Below is a version of `./deploy.sh`.

```
#! /bin/bash

project_root="/srv/hood-savy"
new_release_dir=$(date +%G%m%d%H%M)
release_dir="${project_root}/versions/${new_release_dir}"

mkdir -p ${release_dir}

tar -C "${release_dir}" -xf release-0.1.0.tar

ln -sfn ${release_dir} ${project_root}/current

cp ${project_root}/current/hood-savy.service /lib/systemd/system/

chown -R app:app ${project_root}
systemctl daemon-reload
```

3. Create ENV configs

```
sudo touch /etc/hood-savy/environment
sudo echo -e "SECRET_KEY_BASE=<NEW KEY>" >> /etc/hood-savy/environment
sudo echo -e "DATABASE_URL=ecto://<DB User>:<DB PW>@<DB Host>/<Database>" >> /etc/hood-savy/environment
```

4. Start Service

```
sudo systemctl restart hood-savy
```

5. Forward PORT 80 to 4000

```
sudo iptables -A INPUT -p tcp --dport 4000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 4000 -m state --state NEW \
    -m hashlimit --hashlimit-name HTTP --hashlimit 5/minute \
    --hashlimit-burst 10 --hashlimit-mode srcip --hashlimit-htable-expire 300000 -j ACCEPT
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 4000
```

> Copied from https://www.cogini.com/blog/port-forwarding-with-iptables/

## Profit!!
