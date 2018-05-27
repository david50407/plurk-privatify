# Plurk::Privatify

This script will help you to privatify your history plurks.

## Dependencies

I wrote this with some shell tools, we need these in our shell:

```
* bash
* base64
* date
* jq
* openssl (with -hmac support)
* sed
```

## Usage

Each script inside `apis/` folder is a single entrypoint of Plurk API.

I implemented the minimal plurk client that only support a little part of APIs and options.

### .env support

This tool support to load `.env` file located at project directory.

Just copy `.env.example` to `.env` and modify it with usage inside the comments.

### via cli options

Every API script supports environment override with these options:

```
               --app=token         OAuth App token
               --app-secret=secret OAuth App token secret
    -t token,  --token=token       OAuth token
    -s secret, --secret=secret     OAuth token secret
```

These will override environment variables inside `.env`

### APIs

For now, I only implements these APIs with some limited options (see each APIs' usage):

* `get-plurks.sh`: `/APP/Timeline/getPlurks`
* `plurk-edit.sh`: `/APP/Timeline/plurkEdit`

### Main.sh

There's a simple `main.sh` that you can use to privatify your all public plurks within latest 20 plurks from the timestamp you specified (or from now),
and it will print the next timestamp you can specify to continue privatify your older plurks from last privatify.

## TODOs

* [ ] Recognize API rate-limit error
* [ ] Self-authorize tools
* [ ] Auto-rolling privatify
