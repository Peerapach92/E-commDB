# Persona Database

PostgreSQL schema and seed data for the Persona e-commerce demo.

## Build the image

```bash
docker build -t persona-db .
```

The image uses PostgreSQL 15. The included `init.sql` runs automatically when PostgreSQL initializes a new data directory. Existing database volumes are not reinitialized.

## Tables and demo data

The SQL creates the `users`, `products`, and `orders` tables and inserts the demo accounts and products. Configure the database with the `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB` environment variables supported by the official PostgreSQL image.

Demo credentials are listed in the main application README. Change demo credentials and secrets before using this application outside local development.
