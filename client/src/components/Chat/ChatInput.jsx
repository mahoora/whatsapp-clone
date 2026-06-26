import { useState, useRef } from 'react';
import { useChat } from '../../context/ChatContext';

export default function ChatInput() {
  const [text, setText] = useState('');
  const inputRef = useRef(null);
  const { activeChat, sendMessage, emitTyping } = useChat();
  const typingTimeout = useRef(null);

  const handleChange = (e) => {
    setText(e.target.value);
    emitTyping(true);
    clearTimeout(typingTimeout.current);
    typingTimeout.current = setTimeout(() => emitTyping(false), 1000);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!text.trim() || !activeChat) return;
    await sendMessage(activeChat._id, text.trim());
    setText('');
    emitTyping(false);
    inputRef.current?.focus();
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit(e);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="flex items-center gap-2 px-4 py-2 bg-whatsapp-header">
      <button type="button" className="text-whatsapp-text-secondary hover:text-whatsapp-text p-1" title="Emoji">
        <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      </button>
      <button type="button" className="text-whatsapp-text-secondary hover:text-whatsapp-text p-1" title="Attach">
        <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" /></svg>
      </button>
      <div className="flex-1">
        <input
          ref={inputRef}
          type="text"
          value={text}
          onChange={handleChange}
          onKeyDown={handleKeyDown}
          placeholder="Type a message"
          className="w-full bg-whatsapp-input text-whatsapp-text rounded-lg px-4 py-2.5 outline-none text-sm placeholder-whatsapp-text-secondary"
        />
      </div>
      <button
        type="submit"
        disabled={!text.trim()}
        className={`p-2 rounded-full ${text.trim() ? 'bg-whatsapp-primary text-white' : 'text-whatsapp-text-secondary'} disabled:cursor-not-allowed`}
        title="Send"
      >
        <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" /></svg>
      </button>
    </form>
  );
}
