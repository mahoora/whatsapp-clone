import { useState } from 'react';
import Sidebar from '../components/Sidebar/Sidebar';
import ChatArea from '../components/Chat/ChatArea';
import WelcomeScreen from '../components/Chat/WelcomeScreen';
import { useChat } from '../context/ChatContext';

export default function Home() {
  const { activeChat } = useChat();
  const [sidebarOpen, setSidebarOpen] = useState(true);

  return (
    <div className="h-screen flex bg-whatsapp-dark">
      <div className={`${sidebarOpen ? 'w-[420px] min-w-[350px]' : 'w-0'} transition-all duration-300 border-r border-whatsapp-separator`}>
        <Sidebar />
      </div>
      <div className="flex-1">
        {activeChat ? <ChatArea /> : <WelcomeScreen />}
      </div>
    </div>
  );
}
