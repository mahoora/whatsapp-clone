import { verifyFirebaseToken } from '../config/firebase.js';
import User from '../models/User.js';
import Message from '../models/Message.js';
import Chat from '../models/Chat.js';

const onlineUsers = new Map();

export const setupSocket = (io) => {
  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth.token;
      if (!token) return next(new Error('No token'));

      const decoded = await verifyFirebaseToken(token);
      if (!decoded) return next(new Error('Invalid token'));

      const user = await User.findOne({ phoneNumber: decoded.phone_number });
      if (!user) return next(new Error('User not found'));

      socket.data.user = user;
      socket.data.uid = decoded.uid;
      next();
    } catch (err) {
      next(err);
    }
  });

  io.on('connection', async (socket) => {
    const user = socket.data.user;
    const userId = user._id.toString();

    onlineUsers.set(userId, socket.id);
    await User.findByIdAndUpdate(userId, { isOnline: true, lastSeen: new Date() });

    socket.join(userId);
    io.emit('user:online', { userId, isOnline: true });

    socket.on('message:send', async (data) => {
      try {
        const { chatId, text, type, mediaURL } = data;

        const chat = await Chat.findOne({ _id: chatId, participants: userId });
        if (!chat) return socket.emit('error', { message: 'Chat not found' });

        const message = await Message.create({
          chat: chatId,
          sender: userId,
          text: text || '',
          type: type || 'text',
          mediaURL: mediaURL || '',
        });

        chat.lastMessage = {
          text: text || 'Media',
          sender: userId,
          sentAt: new Date(),
        };
        await chat.save();

        const populated = await Message.findById(message._id).populate(
          'sender',
          'displayName phoneNumber photoURL'
        );

        chat.participants.forEach((pId) => {
          const pStr = pId.toString();
          if (onlineUsers.has(pStr)) {
            io.to(pStr).emit('message:new', { message: populated, chatId });
          }
        });

        await Message.findByIdAndUpdate(message._id, { status: 'delivered' });

        if (onlineUsers.has(userId)) {
          io.to(userId).emit('message:status', {
            messageId: message._id,
            status: 'delivered',
          });
        }
      } catch (err) {
        socket.emit('error', { message: err.message });
      }
    });

    socket.on('message:read', async ({ messageId, chatId }) => {
      try {
        const message = await Message.findById(messageId);
        if (message && !message.readBy.includes(userId)) {
          message.readBy.push(userId);
          message.status = 'read';
          await message.save();

          io.to(chatId).emit('message:status', {
            messageId,
            status: 'read',
            readBy: userId,
          });
        }
      } catch (err) {
        socket.emit('error', { message: err.message });
      }
    });

    socket.on('user:typing', ({ chatId, isTyping }) => {
      socket.to(chatId).emit('user:typing', {
        userId,
        chatId,
        isTyping,
      });
    });

    socket.on('disconnect', async () => {
      onlineUsers.delete(userId);
      await User.findByIdAndUpdate(userId, {
        isOnline: false,
        lastSeen: new Date(),
      });
      io.emit('user:online', { userId, isOnline: false });
    });
  });
};
