FROM postgres:latest

ENV POSTGRES_PASSWORD=password
ENV POSTGRES_USER=docker
ENV POSTGRES_DB=database

COPY init.sh /docker-entrypoint-initdb.d/
COPY *.sql /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/init.sh

EXPOSE 5433

CMD [ "/docker-entrypoint-initdb.d/init.sh" ]