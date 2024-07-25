# syntax=docker/dockerfile:1.3
FROM python:3.12.4-alpine3.20 AS base



ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DOCKER_CONTENT_TRUST=1



FROM base as builder
WORKDIR /build
COPY requirements.txt /requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
  apk update --no-cache && \
  pip install --no-cache-dir --prefix=/build -r /requirements.txt



FROM base
WORKDIR /app
COPY --from=builder /build /usr/local
COPY . /app/
RUN addgroup python && \
  adduser -G python -S python && \
  chown -R python:python .
USER python
CMD [ "python", "app.py" ]
HEALTHCHECK CMD ["wget", "-q", "localhost:8080/api/v1/health/liveness"]
