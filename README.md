## Quick reference

Docker Compose configuration for the KeeWeb usage via WebDav with Digest Authentication.

It has Apache Web Server under the hood.
There are three realms configured:
* Common
* Secure
* Critical

Divide your credentials into three layers of access and manage shared user access using them.

```
Notice: Balancer with SSL encryption is required.
```


## Usage

### Start bundle

Serve it on the server with:
```
docker-compose up -d
```

This example starts a WebDAV server on port 80. It can only be accessed with credential you'll make in the future steps.

### Secure WebDAV with SSL

We recommend you use a reverse proxy (eg, Caddy) to handle SSL certificates.

### Authenticate multiple clients

Run the following commands. (NB: The example realm is `Common`. To specify credential for different realms, you'll need to run `htdigest` again with required name (`Common`, `Secure`, `Critical`).)

```
htdigest ./data/httpd/user.passwd Common alice
htdigest ./data/httpd/user.passwd Common bob
```
