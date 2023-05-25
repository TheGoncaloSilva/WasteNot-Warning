FROM node:14

# make the 'app' folder the current working directory
WORKDIR /front

# install simple http server for serving static content
RUN npm install -g http-server

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
#RUN npm run build

ARG NODE_ENV=dev

# Check if build argument is 'production'
RUN if [ "$NODE_ENV" = "prod" ]; then \
        npm run build;  \
    fi

EXPOSE 8080
#CMD [ "http-server", "dist" ]