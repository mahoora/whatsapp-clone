import Message from '../models/Message.js';
import Chat from '../models/Chat.js';

export const getMessages = async (req, res) => {
  const { chatId } = req.params;
  const { page = 1, limit = 50 } = req.query;

  const messages = await Message.find({ chat: chatId })
    .sort({ createdAt: -1 })
    .skip((page - 1) * limit)
    .limit(Number(limit))
    .populate('sender', 'displayName phoneNumber photoURL');

  const total = await Message.countDocuments({ chat: chatId });

  res.json({ messages: messages.reverse(), total, page: Number(page) });
};

export const sendMessage = async (req, res) => {
  const { chatId, text, type, mediaURL } = req.body;

  const chat = await Chat.findOne({
    _id: chatId,
    participants: req.user._id,
  });
  if (!chat) return res.status(404).json({ error: 'Chat not found' });

  const message = await Message.create({
    chat: chatId,
    sender: req.user._id,
    text: text || '',
    type: type || 'text',
    mediaURL: mediaURL || '',
  });

  chat.lastMessage = {
    text: text || (type === 'image' ? 'Photo' : type === 'video' ? 'Video' : 'Media'),
    sender: req.user._id,
    sentAt: new Date(),
  };
  await chat.save();

  const populated = await Message.findById(message._id).populate(
    'sender',
    'displayName phoneNumber photoURL'
  );

  res.json({ message: populated });
};
