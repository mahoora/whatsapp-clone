import { useAuth } from '../../context/AuthContext';
import { useChat } from '../../context/ChatContext';
import Avatar from '../common/Avatar';

export default function ChatHeader() {
  const { user } = useAuth();
  const { activeChat, onlineUsers, typingUsers } = useChat();

  if (!activeChat) return null;

  const other = activeChat.participants?.find((p) => p._id !== user?._id);
  const name = activeChat.isGroup ? activeChat.groupName : other?.displayName || other?.phoneNumber || 'Unknown';
  const photo = activeChat.isGroup ? activeChat.groupPhoto : other?.photoURL;
  const isOnline = activeChat.isGroup ? false : onlineUsers[other?._id];
  const isTyping = typingUsers[other?._id];

  return (
    <div className="flex items-center px-4 py-2.5 bg-whatsapp-header">
      <Avatar src={photo} name={name} size={40} />
      <div className="ml-3 flex-1">
        <h2 className="text-whatsapp-text font-medium text-base">{name}</h2>
        <p className="text-whatsapp-text-secondary text-xs">
          {isTyping ? 'typing...' : isOnline ? 'online' : ''}
        </p>
      </div>
      <div className="flex items-center gap-4 text-whatsapp-text-secondary">
        <button className="hover:text-whatsapp-text" title="Video call">
          <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>
        </button>
        <button className="hover:text-whatsapp-text" title="Search">
          <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
        </button>
        <button className="hover:text-whatsapp-text" title="Menu">
          <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 5v.01M12 12v.01M12 19v.01" /></svg>
        </button>
      </div>
    </div>
  );
}
