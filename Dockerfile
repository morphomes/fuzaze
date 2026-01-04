FROM nginx:alpine

# Copy the public folder you already built locally
COPY ./public /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]