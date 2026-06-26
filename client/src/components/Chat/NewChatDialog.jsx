import { useState } from 'react';
import { api } from '../../services/api';

export default function NewChatDialog({ onClose }) {
  const [phone, setPhone] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const formattedPhone = phone.startsWith('+') ? phone : `+${phone}`;
      await api.users.addContact(formattedPhone);
      const { chat } = await api.chats.getOrCreate(formattedPhone);
      onClose();
      window.location.reload();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/60 z-50 flex items-center justify-center" onClick={onClose}>
      <div className="bg-whatsapp-header rounded-lg p-6 w-full max-w-sm mx-4" onClick={(e) => e.stopPropagation()}>
        <h2 className="text-lg font-semibold mb-4">New Chat</h2>
        {error && <div className="bg-red-500/10 border border-red-500/50 text-red-400 p-2 rounded mb-3 text-sm">{error}</div>}
        <form onSubmit={handleSubmit}>
          <input
            type="tel"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            placeholder="+201234567890"
            className="w-full bg-whatsapp-input text-whatsapp-text p-3 rounded outline-none focus:ring-2 focus:ring-whatsapp-primary mb-4"
            required
          />
          <div className="flex gap-2 justify-end">
            <button type="button" onClick={onClose} className="px-4 py-2 text-whatsapp-text-secondary hover:text-whatsapp-text">
              Cancel
            </button>
            <button type="submit" disabled={loading} className="px-4 py-2 bg-whatsapp-primary text-white rounded hover:opacity-90 disabled:opacity-50">
              {loading ? 'Searching...' : 'Start Chat'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
