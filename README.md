# autofirma-docker: Image with Firefox and AutoFirma

## Requirements

- Ubuntu Desktop 20.04
- `docker` and `python3`

## Initial Setup

Install dependencies and build `autofirma` Docker image:

```
sudo apt-get install docker.io python3
make
```

Export client certificate from host Firefox to `~/Desktop/cert.pfx` (password
protected):

- Visit: [about:preferences#privacy]()
- [View Certificates...] > [Your Certificates]
- Select certificate.
- Click on [Backup...]
- Save to: `~/Desktop/cert.pfx`
- Choose password.
- Click on [OK].

Run AutoFirma-enabled Firefox using Docker image:
```
./firefox-autofirma setup ~/Desktop/cert.pfx
```

Import client certificate:

- Visit: [about:preferences#privacy]()
- [View Certificates...] > [Your Certificates] > [Import...]
- Select: `/home/cert.pfx`
- Enter password.
- Click on [OK].

Test `AutoFirma` using test page:

- Click on [Firmar].
- Choose certificate using `AutoFirma`.
- Success Message: `Se ha realizado la firma`.

## Run AutoFirma-enabled Firefox

After the initial setup, the following command can be used to launch the
Autofirma-enabled Firefox:

```
./firefox-autofirma run [URL]
```

Notes:
- Firefox will be executed in a container as the current user.
- Firefox profiles are persisted in the `~/.config/firefox-autofirma/home` host
  directory.
