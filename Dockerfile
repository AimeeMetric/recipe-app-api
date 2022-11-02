FROM python:3.9-alpine3.13
# LABEL maintainer="aimee@metrictreelabs.com"

ENV PYTHONUNBUFFERED 1

# COPY ./app /app
COPY . /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

# create venv:
# ENV VIRTUAL_ENV=/app/venv
# RUN python3 -m venv $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
COPY requirements.txt /tmp/requirements.txt
COPY requirements.dev.txt /tmp/requirements.dev.txt

RUN /usr/local/bin/python -m pip install --upgrade pip
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps build-base postgresql-dev musl-dev

RUN pip install -r /tmp/requirements.txt
# RUN pip install -r requirements.dev.txt
RUN if [ "$DEV" = "true" ] ; then pip install -r /tmp/requirements.dev.txt ;  fi
RUN rm -rf /tmp
RUN apk del .tmp-build-deps

# Create the user
# by using the -D option, 
# the user is created
#  without a password.
RUN adduser -D django-user
USER django-user

