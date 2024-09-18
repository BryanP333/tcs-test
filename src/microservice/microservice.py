from flask import Flask, jsonify, request
import json

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify(status='healthy'), 200

@app.route('/DevOps', methods=['POST'])
def process_request():
    # Verificar que el método HTTP es POST
    if request.method != 'POST':
        return {
            'statusCode': 200,
            'body': json.dumps("ERROR")
        }

    # Verificar que el cuerpo de la solicitud está presente
    if not request.data:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Bad Request: Missing body'})
        }
    
    # El cuerpo puede estar en formato JSON escapado
    try:
        body = request.json
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Bad Request: Invalid JSON'})
        }
    
    # Obtener el valor del campo 'to'
    to = body.get('to')
    
    # Comprobar si el campo 'to' está presente
    if not to:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Bad Request: Missing "to" field'})
        }
    
    # Construir el mensaje de respuesta
    response_message = {
        'message': f'Hello {to}, your message will be sent'
    }
    
    return {
        'statusCode': 200,
        'body': json.dumps(response_message)
    }

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)