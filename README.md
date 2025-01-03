# imgs-registry

## Run

```sh
docker compose up -d
```

## Backup

```sh
./scripts/backup.sh
```

## Restore

```sh
./scripts/backup.sh restore name_of_backup_archive
```

## Certificates

I use self singed certificate. To generate new certificate:

```sh
dotenv -f .env run -- openssl req -x509 \
-keyout certs/ssl.key \
-out certs/ssl.crt \
-nodes \
-days 365 \
-newkey rsa:2048 \
-extensions req_ext \
-config openssl.cnf
```

To check the certificate

```sh
openssl x509 -in certs/ssl.crt -text -noout
```

Make sure all clients trust this certificate
