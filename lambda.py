import json
import boto3
from datetime import datetime

# Setup Bedrock and DynamoDB clients
bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-west-2')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ConversationHistory')

# Call Claude model
def call_claude(messages):
    prompt_config = {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 4096,
        "messages": messages,
        "temperature": 0.5,
        "top_k": 250,
        "top_p": 0.5,
    }
    body = json.dumps(prompt_config)
    modelId = "anthropic.claude-3-5-sonnet-20240620-v1:0"
    accept = "application/json"
    contentType = "application/json"
    
    response = bedrock_runtime.invoke_model(
        body=body, modelId=modelId, accept=accept, contentType=contentType
    )
    response_body = json.loads(response.get("body").read())
    return response_body['content'][0]['text']

# Fetch conversation history from DynamoDB
def get_conversation_history(user_id):
    response = table.query(
        KeyConditionExpression=boto3.dynamodb.conditions.Key('user_id').eq(user_id)
    )
    history = []
    for item in response['Items']:
        history.append({
            "role": item['role'],
            "content": item['content']
        })
    return history

# Save conversation history to DynamoDB
def save_conversation_history(user_id, role, content):
    table.put_item(
        Item={
            'user_id': user_id,
            'timestamp': str(datetime.now()),  # Sort key (unique)
            'role': role,
            'content': content
        }
    )

# Process user query and generate a response
def process_query(user_id, query):
    # Fetch the conversation history
    conversation_history = get_conversation_history(user_id)

    system_instruction = """
    Alışgidiş, popüler markalara ve sevilen ürünlere erişim sağlayan, kesintisiz ve güvenli bir alışveriş deneyimi sunan dijital bir alışveriş merkezidir. 
    Sadece "Alışgidiş Limiti" adı verilen benzersiz bir harcama limiti sunmakla kalmaz, aynı zamanda diğer güvenli ve kullanışlı ödeme seçenekleri de sağlar.
    Sen bu mağazanın sanal asistanı FingerBot'sun, senin görevin müşteriye yardımcı olmak ve sorularını yanıtlamak. 
    
    """
    # Add system instruction to the first user message if history is empty
    if not conversation_history:
        conversation_history.append({
            "role": "user",
            "content": system_instruction + "\n\nKullanıcı: " + query
        })
    else:
        conversation_history.append({
            "role": "user",
            "content": query
        })

    # Call Claude with the updated conversation history
    response = call_claude(conversation_history)
    
    # Save user query and bot response to DynamoDB
    save_conversation_history(user_id, "user", query)
    save_conversation_history(user_id, "assistant", response)
    
    return response

# Lambda handler function
def lambda_handler(event, context):
    user_id = event['user_id']
    user_query = event['query']
    
    # Generate a response
    response = process_query(user_id, user_query)
    
    return {
        'statusCode': 200,
        'body': json.dumps({'response': response})
    }