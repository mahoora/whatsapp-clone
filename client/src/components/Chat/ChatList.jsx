import { useAuth } from '../../context/AuthContext';
import { useChat } from '../../context/ChatContext';
import Avatar from '../common/Avatar';

export default function ChatList({ chats }) {
  const { user } = useAuth();
  const { activeChat, selectChat, onlineUsers } = useChat();

  return (
    <div className="flex-1 overflow-y-auto">
      {chats.length === 0 && (
        <div className="text-center text-whatsapp-text-secondary mt-8 text-sm">
          No chats yet. Start a new conversation!
        </div>
      )}
      {chats.map((chat) => {
        const other = chat.participants?.find((p) => p._id !== user?._id);
        const name = chat.isGroup ? chat.groupName : other?.displayName || other?.phoneNumber || 'Unknown';
        const photo = chat.isGroup ? chat.groupPhoto : other?.photoURL;
        const isOnline = chat.isGroup ? false : onlineUsers[other?._id];
        const lastMsg = chat.lastMessage?.text || 'No messages yet';
        const time = chat.lastMessage?.sentAt ? new Date(chat.lastMessage.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '';

        return (
          <div
            key={chat._id}
            onClick={() => selectChat(chat)}
            className={`flex items-center px-4 py-3 cursor-pointer hover:bg-whatsapp-header/50 transition-colors ${activeChat?._id === chat._id ? 'bg-whatsapp-header' : ''}`}
          >
            <div className="relative mr-3">
              <Avatar src={photo} name={name} size={49} />
              {isOnline && <div className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 rounded-full border-2 border-whatsapp-sidebar"></div>}
            </div>
            <div className="flex-1 min-w-0 border-b border-whatsapp-separator pb-3">
              <div className="flex justify-between items-center">
                <span className="font-medium text-whatsapp-text text-base truncate">{name}</span>
                {time && <span className="text-whatsapp-text-secondary text-xs ml-2">{time}</span>}
              </div>
              <div className="flex items-center mt-0.5">
                <span className="text-whatsapp-text-secondary text-sm truncate">{lastMsg}</span>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}
