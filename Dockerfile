# # Use the official Node.js image.
# FROM node:14

# # Create and change to the app directory.
# WORKDIR /usr/src/app

# # Copy application dependency manifests to the container image.
# COPY package*.json ./

# # Install production dependencies.
# RUN npm install --production

# # Copy local code to the container image.
# COPY . .

# # Run the web service on container startup.
# CMD [ "node", "index.js" ]

# # Expose the port the app runs on
# EXPOSE 3000


FROM node:12.2.0-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]