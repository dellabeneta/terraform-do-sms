const twilio = require('twilio');

exports.main = async (args) => {
  // 1. Autentica na Twilio usando variáveis de ambiente
  const client = new twilio(
    args.TWILIO_ACCOUNT_SID,   // ID da conta Twilio (segredo)
    args.TWILIO_AUTH_TOKEN     // Token de autenticação (segredo)
  );

  try {
    // 2. Envia o SMS
    await client.messages.create({
      body: args.mensagem,      // Texto recebido do backend
      from: args.TWILIO_PHONE_NUMBER, // Número Twilio (ex: +123456789)
      to: args.telefone         // Número do usuário
    });

    // 3. Retorna sucesso
    return { status: 'success' };
  } catch (error) {
    // 4. Retorna erro (ex: número inválido)
    return { status: 'error', message: error.message };
  }
};