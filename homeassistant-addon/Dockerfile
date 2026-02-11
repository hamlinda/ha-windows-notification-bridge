ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements
RUN apk add --no-cache \
    python3 \
    py3-pip

# Copy app files
COPY app /app
COPY run.sh /

# Install Python requirements
RUN pip3 install --no-cache-dir -r /app/requirements.txt

# Make run script executable
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]