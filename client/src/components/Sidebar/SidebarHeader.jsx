import { useState } from 'react';
import { auth } from '../../services/firebase';
import { useAuth } from '../../context/AuthContext';
import { disconnectSocket } from '../../services/socket';
import NewChatDialog from '../Chat/NewChatDialog';

export default function SidebarHeader() {
  const { user, setUser } = useAuth();
  const [showMenu, setShowMenu] = useState(false);
  const [showNewChat, setShowNewChat] = useState(false);

  const handleLogout = async () => {
    disconnectSocket();
    setUser(null);
    await auth.signOut();
  };

  return (
    <>
      <div className="flex items-center justify-between px-4 py-3 bg-whatsapp-header">
        <div className="w-10 h-10 rounded-full bg-whatsapp-primary flex items-center justify-center text-white font-bold text-sm cursor-pointer" onClick={() => setShowMenu(!showMenu)}>
          {user?.displayName?.charAt(0)?.toUpperCase() || '?'}
        </div>
        <div className="flex items-center gap-4">
          <button className="text-whatsapp-text-secondary hover:text-whatsapp-text" onClick={() => setShowNewChat(true)} title="New chat">
            <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" /></svg>
          </button>
          <div className="relative">
            <button className="text-whatsapp-text-secondary hover:text-whatsapp-text" onClick={() => setShowMenu(!showMenu)} title="Menu">
              <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 5v.01M12 12v.01M12 19v.01" /></svg>
            </button>
            {showMenu && (
              <div className="absolute right-0 top-full mt-1 bg-whatsapp-header shadow-lg rounded-lg py-1 z-50 w-48">
                <button onClick={handleLogout} className="w-full text-left px-4 py-2 hover:bg-whatsapp-input text-sm text-whatsapp-text">
                  Log out
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
      {showNewChat && <NewChatDialog onClose={() => setShowNewChat(false)} />}
    </>
  );
}
