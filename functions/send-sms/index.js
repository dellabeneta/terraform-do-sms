const twilio = require('twilio');

exports.main = async (args) => {
  const client = new twilio(
    args.TWILIO_ACCOUNT_SID,
    args.TWILIO_AUTH_TOKEN
  );

  try {
    await client.messages.create({
      body: args.mensagem,
      from: args.TWILIO_PHONE_NUMBER,
      to: args.telefone
    });
    return { status: 'success' };
  } catch (error) {
    return { status: 'error', message: error.message };
  }
};