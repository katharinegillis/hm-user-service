This is a simple user service that provides users for the Household Manager platform

## Usage: Sqlite

The user data is stored in a sqlite file at /data by default. Use a volume to persist that sqlite file to the host.

```yaml
services:
  user-service:
    image: kcordes/hm-user-service
    volumes:
      - ./.data:/data
```
