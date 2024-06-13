FROM postgres:latest

ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=Database

COPY init.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

CMD [ "/docker-entrypoint-initdb.d/init.sh" ]