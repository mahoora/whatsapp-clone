import Chat from '../models/Chat.js';
import User from '../models/User.js';

export const getChats = async (req, res) => {
  const chats = await Chat.find({
    participants: req.user._id,
  })
    .populate('participants', 'displayName phoneNumber photoURL isOnline')
    .populate('lastMessage.sender', 'displayName')
    .sort({ 'lastMessage.sentAt': -1, updatedAt: -1 });

  res.json({ chats });
};

export const getOrCreateChat = async (req, res) => {
  const { participantId } = req.body;
  if (!participantId) return res.status(400).json({ error: 'participantId required' });

  const participant = await User.findById(participantId);
  if (!participant) return res.status(404).json({ error: 'User not found' });

  const existingChat = await Chat.findOne({
    isGroup: false,
    participants: { $all: [req.user._id, participant._id], $size: 2 },
  }).populate('participants', 'displayName phoneNumber photoURL isOnline');

  if (existingChat) return res.json({ chat: existingChat });

  const chat = await Chat.create({
    participants: [req.user._id, participant._id],
  });

  const populated = await Chat.findById(chat._id).populate(
    'participants',
    'displayName phoneNumber photoURL isOnline'
  );

  res.json({ chat: populated });
};

export const createGroup = async (req, res) => {
  const { groupName, participants } = req.body;

  const chat = await Chat.create({
    participants: [req.user._id, ...participants],
    isGroup: true,
    groupName,
    groupAdmin: req.user._id,
  });

  const populated = await Chat.findById(chat._id).populate(
    'participants',
    'displayName phoneNumber photoURL isOnline'
  );

  res.json({ chat: populated });
};
