FROM node:18-alpine3.17 as build
WORKDIR /app
COPY . /app
RUN npm install
RUN npm run build

FROM ubuntu
RUN apt-get update 
RUN apt-get install apache2 -y
RUN apt-get install apache2-utils -y 
RUN apt clean 
RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
COPY --from=build /app/dist /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]