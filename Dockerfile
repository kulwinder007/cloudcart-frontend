# Step 1: Build the React app
FROM node:16 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./ 

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . . 

# Build the React app
RUN npm run build

# Step 2: Serve the React app using Nginx
FROM nginx:alpine

# Copy the custom nginx.conf to the correct location
COPY nginx.conf /etc/nginx/nginx.conf

# Change permissions of nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

# Copy the build folder from the previous stage to the Nginx HTML folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 (since Nginx listening on port 80)
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
