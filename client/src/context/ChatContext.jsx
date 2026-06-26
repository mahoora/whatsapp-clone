import { createContext, useContext, useState, useEffect, useCallback, useRef } from 'react';
import { getSocket } from '../services/socket';
import { api } from '../services/api';
import { useAuth } from './AuthContext';

const ChatContext = createContext(null);

export const ChatProvider = ({ children }) => {
  const { user } = useAuth();
  const [chats, setChats] = useState([]);
  const [activeChat, setActiveChat] = useState(null);
  const [messages, setMessages] = useState([]);
  const [onlineUsers, setOnlineUsers] = useState({});
  const [typingUsers, setTypingUsers] = useState({});
  const messagesEndRef = useRef(null);

  useEffect(() => {
    if (!user) return;
    api.chats.getAll().then(({ chats: chatList }) => setChats(chatList)).catch(console.error);
  }, [user]);

  useEffect(() => {
    const socket = getSocket();
    if (!socket) return;

    socket.on('message:new', ({ message, chatId: msgChatId }) => {
      if (activeChat?._id === msgChatId) {
        setMessages((prev) => [...prev, message]);
      }
      setChats((prev) => {
        const updated = [...prev];
        const idx = updated.findIndex((c) => c._id === msgChatId);
        if (idx !== -1) {
          updated[idx].lastMessage = {
            text: message.text || 'Media',
            sender: message.sender,
            sentAt: new Date(),
          };
          const [item] = updated.splice(idx, 1);
          updated.unshift(item);
        }
        return updated;
      });
    });

    socket.on('message:status', ({ messageId, status }) => {
      setMessages((prev) =>
        prev.map((m) => (m._id === messageId ? { ...m, status } : m))
      );
    });

    socket.on('user:online', ({ userId: uid, isOnline }) => {
      setOnlineUsers((prev) => ({ ...prev, [uid]: isOnline }));
    });

    socket.on('user:typing', ({ userId: uid, isTyping }) => {
      setTypingUsers((prev) => ({ ...prev, [uid]: isTyping }));
    });

    return () => {
      socket.off('message:new');
      socket.off('message:status');
      socket.off('user:online');
      socket.off('user:typing');
    };
  }, [activeChat]);

  const sendMessage = useCallback(async (chatId, text, type = 'text', mediaURL = '') => {
    const socket = getSocket();
    if (socket?.connected) {
      socket.emit('message:send', { chatId, text, type, mediaURL });
    } else {
      await api.messages.send({ chatId, text, type, mediaURL });
    }
  }, []);

  const markAsRead = useCallback((messageIds) => {
    const socket = getSocket();
    if (!socket || !activeChat) return;
    messageIds.forEach((messageId) => {
      socket.emit('message:read', { messageId, chatId: activeChat._id });
    });
  }, [activeChat]);

  const emitTyping = useCallback((isTyping) => {
    const socket = getSocket();
    if (!socket || !activeChat) return;
    socket.emit('user:typing', { chatId: activeChat._id, isTyping });
  }, [activeChat]);

  const loadMessages = useCallback(async (chatId, page = 1) => {
    const { messages: msgList } = await api.messages.get(chatId, page);
    setMessages(page === 1 ? msgList : (prev) => [...msgList, ...prev]);
    return msgList;
  }, []);

  const selectChat = useCallback(async (chat) => {
    setActiveChat(chat);
    setMessages([]);
    await loadMessages(chat._id);
  }, [loadMessages]);

  return (
    <ChatContext.Provider
      value={{
        chats, setChats, activeChat, selectChat, messages, sendMessage,
        loadMessages, markAsRead, emitTyping, onlineUsers, typingUsers,
        messagesEndRef, setMessages,
      }}
    >
      {children}
    </ChatContext.Provider>
  );
};

export const useChat = () => useContext(ChatContext);
