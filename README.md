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

## Building Release

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
