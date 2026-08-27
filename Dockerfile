FROM nginx:alpine
RUN echo "CI/CD Demo Success" > /usr/share/nginx/html/index.html
EXPOSE 80
