from flask import Flask, request, jsonify
import os
import psycopg2
import requests
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# Configurar conexão com o PostgreSQL
conn = psycopg2.connect(
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT")
)

@app.route("/cadastrar", methods=["POST"])
def cadastrar():
    data = request.json

    # Validar dados (exemplo simples)
    if not data.get("nome") or not data.get("email") or not data.get("telefone"):
        return jsonify({"error": "Dados incompletos"}), 400

    try:
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO usuarios (nome, email, telefone) VALUES (%s, %s, %s)",
            (data["nome"], data["email"], data["telefone"])
        )
        conn.commit()
        cur.close()

        # Chamar a Function para enviar SMS
        response = requests.post(
            os.getenv("FUNCTION_URL"),
            json={
                "telefone": data["telefone"],
                "mensagem": "Cadastro realizado! Confira seu SMS."
            }
        )

        if response.status_code != 200:
            return jsonify({"error": "Falha ao enviar SMS"}), 500

        return jsonify({"status": "success"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)