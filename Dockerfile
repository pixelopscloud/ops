# Use Node.js LTS version
FROM node:20

# Create app directory
WORKDIR /usr/src/app

# Copy package.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD ["npm", "start"]

