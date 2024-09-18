import json
import jwt
import requests
from jwt.algorithms import RSAAlgorithm

def lambda_handler(event, context):
    api_key = '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c'
    headers = event.get('headers', {})
    
    # Validar la API Key
    if headers.get('X-Parse-REST-API-Key') != api_key:
        return generate_policy('user', 'Deny', event['methodArn'])
    
    # Validar el JWT
    token = headers.get('X-JWT-KWY')
    if not token:
        return generate_policy('user', 'Deny', event['methodArn'])
    
    try:
        # Obtener el JWKS
        jwks_url = "https://cognito-idp.us-west-2.amazonaws.com/us-west-2_iczTFqxkL/.well-known/jwks.json"
        jwks = requests.get(jwks_url).json()
        print(json.dumps(jwks))
        
        # Extraer la clave pública
        public_key = RSAAlgorithm.from_jwk(json.dumps(jwks['keys'][0]))
        
        # Decodificar el token
        decoded_token = jwt.decode(token, public_key, algorithms=['RS256'], audience='4amm53b62bm4d0httvqempmrb8')
        
    except jwt.ExpiredSignatureError:
        return generate_policy('user', 'Deny', event['methodArn'])
    except jwt.InvalidTokenError:
        return generate_policy('user', 'Deny', event['methodArn'])
    
    return generate_policy('user', 'Allow', event['methodArn'])

def generate_policy(principal_id, effect, resource):
    auth_response = {}
    auth_response['principalId'] = principal_id
    
    if effect and resource:
        policy_document = {
            'Version': '2012-10-17',
            'Statement': [{
                'Action': 'execute-api:Invoke',
                'Effect': effect,
                'Resource': resource
            }]
        }
        auth_response['policyDocument'] = policy_document
    
    return auth_response