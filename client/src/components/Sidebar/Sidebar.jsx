import { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useChat } from '../../context/ChatContext';
import SidebarHeader from './SidebarHeader';
import SearchBar from './SearchBar';
import ChatList from '../Chat/ChatList';

export default function Sidebar() {
  const { user } = useAuth();
  const { chats } = useChat();
  const [search, setSearch] = useState('');

  const filteredChats = chats.filter((chat) => {
    if (!search) return true;
    const other = chat.participants?.find((p) => p._id !== user?._id);
    const name = chat.isGroup ? chat.groupName : other?.displayName || other?.phoneNumber;
    return name?.toLowerCase().includes(search.toLowerCase());
  });

  return (
    <div className="h-full flex flex-col bg-whatsapp-sidebar">
      <SidebarHeader />
      <SearchBar value={search} onChange={setSearch} />
      <ChatList chats={filteredChats} />
    </div>
  );
}
