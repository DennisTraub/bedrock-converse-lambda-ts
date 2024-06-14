# Simple example of an AWS Lambda function to invoke an LLM on Amazon Bedrock

## Prerequisites

- Node.js and npm installed
- AWS CLI installed and configured

## Setup

**1. Clone the repository and navigate into the project directory:**
  ```bash
  git clone https://github.com/DennisTraub/bedrock-converse-lambda-ts.git
  cd bedrock-converse-lambda-ts
  ```

## Build the Lambda Function Code

**1. Install the necessary dependencies:**
  ```bash
  npm install
  ```

**2. Build the Lambda function code:**
  ```bash
  npm run build
  ```

## Package the Lambda Function

### Using zip

**1. Zip the Lambda function code:**
  ```bash
  zip -r function.zip .
  ```

### Using 7z

**1. Zip the Lambda function code with 7z:**
  ```bash
  7z a function.zip .
  ```

## Deploy the function to AWS Lambda

**1. Run the deployment script, :**
   ```bash
   ./deploy.sh
   ```

**2. Check the output of the deployment script and note down the function name**

## Test the Lambda function

**1. Invoke the Lambda function using the AWS CLI:**
  ```bash
  aws lambda invoke output.txt --function-name <your-function-name>
  ```

**2. Check the output:**
  ```bash
  cat output.txt
  ```
