#!/usr/bin/env bash
set -e

# Environment defaults
: "${POSTGRES_HOST:=tactical-postgres}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_USER:=tactical}"
: "${POSTGRES_PASS:=tactical}"
: "${POSTGRES_DB:=tacticalrmm}"
: "${REDIS_HOST:=tactical-redis}"

wait_for_postgres() {
    echo "Waiting for PostgreSQL..."
    until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -q 2>/dev/null || \
          timeout 1 bash -c "cat < /dev/null > /dev/tcp/${POSTGRES_HOST}/${POSTGRES_PORT}" 2>/dev/null; do
        sleep 2
    done
    echo "PostgreSQL is ready"
}

# If first arg is a flag or empty, assume we're running the default CMD
if [ -z "$1" ] || [ "${1#-}" != "$1" ]; then
    exec uvicorn --host 0.0.0.0 --port 8080 "tacticalrmm.asgi:application" "$@"
fi

case "$1" in
    uvicorn|celery|python)
        exec "$@"
        ;;
    backend)
        wait_for_postgres
        exec uvicorn --host 0.0.0.0 --port 8080 "tacticalrmm.asgi:application"
        ;;
    websockets)
        wait_for_postgres
        exec uvicorn --host 0.0.0.0 --port 8383 --forwarded-allow-ips='*' "tacticalrmm.asgi:application"
        ;;
    celery-worker)
        wait_for_postgres
        exec celery -A tacticalrmm worker --autoscale=20,2 -l info
        ;;
    celery-beat)
        wait_for_postgres
        rm -f "${TACTICAL_DIR}/api/celerybeat.pid"
        exec celery -A tacticalrmm beat -l info
        ;;
    migrate)
        wait_for_postgres
        exec python manage.py migrate --no-input
        ;;
    collectstatic)
        exec python manage.py collectstatic --no-input
        ;;
    shell)
        exec python manage.py shell
        ;;
    *)
        exec "$@"
        ;;
esac
