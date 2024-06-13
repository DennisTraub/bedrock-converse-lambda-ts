#!/bin/bash

REGION=$(aws configure get region)}

POSTFIX=$(tr -dc 'a-z0-9' </dev/urandom | head -c 6)
FUNCTION_NAME="converse-test-${POSTFIX}"
ROLE_NAME="lambda-execution-role-for-${FUNCTION_NAME}"

TRUST_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

echo
echo "Creating IAM role..."
ROLE_RESPONSE=$(aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY" --output json)
ROLE_ARN=$(echo $ROLE_RESPONSE | grep -o '"Arn": "[^"]*' | grep -o '[^"]*$')

aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
echo "Attached AWSLambdaBasicExecutionRole policy to the role"

INLINE_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": "arn:aws:bedrock:*::foundation-model/*"
    }
  ]
}'

aws iam put-role-policy --role-name $ROLE_NAME --policy-name bedrock-invoke-permisssions --policy-document "$INLINE_POLICY"
echo "Attached inline policy for Bedrock to the role"
echo "Role '$ROLE_NAME created successfully."

echo
echo "Creating Lambda function in $REGION"

aws lambda create-function --function-name $FUNCTION_NAME \
  --runtime nodejs20.x --role $ROLE_ARN --timeout 30 \
  --handler converse.handler --zip-file fileb://function.zip

echo "Lambda function created successfully!"
echo "Name: $FUNCTION_NAME"
echo
echo "To invoke the function, use the following command:"
echo
echo "aws lambda invoke output.txt --function-name $FUNCTION_NAME"
