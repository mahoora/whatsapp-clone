import { useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useChat } from '../../context/ChatContext';
import ChatHeader from './ChatHeader';
import ChatBubble from './ChatBubble';
import ChatInput from './ChatInput';

export default function ChatArea() {
  const { user } = useAuth();
  const { activeChat, messages, messagesEndRef, markAsRead } = useChat();

  useEffect(() => {
    if (messages.length > 0 && activeChat) {
      const unreadIds = messages
        .filter((m) => m.status !== 'read' && m.sender?._id !== user?._id)
        .map((m) => m._id);
      if (unreadIds.length > 0) markAsRead(unreadIds);
    }
  }, [messages, activeChat, user, markAsRead]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, messagesEndRef]);

  return (
    <div className="h-full flex flex-col bg-[#0B141A]">
      <ChatHeader />
      <div className="flex-1 overflow-y-auto px-4 py-2 bg-[#0B141A] bg-opacity-95" style={{
        backgroundImage: "url('data:image/svg+xml,%3Csvg width=\\'60\\' height=\\'60\\' viewBox=\\'0 0 60 60\\' xmlns=\\'http://www.w3.org/2000/svg\\'%3E%3Cg fill=\\'none\\' fill-rule=\\'evenodd\\'%3E%3Cg fill=\\'%23111B21\\' fill-opacity=\\'0.4\\'%3E%3Cpath d=\\'M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z\\'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E')",
      }}>
        {messages.map((msg) => (
          <ChatBubble key={msg._id} message={msg} isOwn={msg.sender?._id === user?._id} />
        ))}
        <div ref={messagesEndRef} />
      </div>
      <ChatInput />
    </div>
  );
}
