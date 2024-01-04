# Schedule backup
Backup database service using backup gem, whenever gem, and docker.

## Configuration
In ```app.env``` file: copy content in ```app.env.example``` to the file and update it.

## Update to your database url
```DATABASE_URL=postgres://username:password@localhost:5432/app_development```

## Run back up every day
```BACKUP_PERIOD=1```

## If your storage type is AWS3, uncomment below and update change_me
```
STORAGE_TYPE=AWS3
AWS_ACCESS_KEY_ID=change_me
AWS_SECRET_ACCESS_KEY=change_me
AWS_REGION=change_me
AWS_NAME_OF_DB_BUCKET=change_me
AWS_PATH_TO_DB_BACKUP=change_me
```
## Start service
```docker-compose up -d```

So your database will be backup every day.
