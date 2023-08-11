FROM python:3.11.4-alpine
LABEL maintainer="catnip-ads-auto.herokuapp.com"

ENV PYTHONUNBUFFERED 1

# Copy requirements.txt file and install dependencies
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Create a non-root user for running the application
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV="true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Add the virtual environment's bin directory to the PATH
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user