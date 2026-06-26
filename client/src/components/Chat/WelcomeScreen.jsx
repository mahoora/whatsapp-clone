export default function WelcomeScreen() {
  return (
    <div className="h-full flex flex-col items-center justify-center bg-whatsapp-dark text-center px-4">
      <div className="w-24 h-24 rounded-full bg-whatsapp-primary/20 flex items-center justify-center mb-6">
        <svg className="w-12 h-12 text-whatsapp-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
        </svg>
      </div>
      <h1 className="text-3xl font-light text-whatsapp-text mb-2">Whats Maher</h1>
      <p className="text-whatsapp-text-secondary text-sm max-w-md">
        Send and receive messages instantly. Select a chat or start a new conversation.
      </p>
      <div className="mt-8 border-t border-whatsapp-separator pt-8 w-64">
        <p className="text-whatsapp-text-secondary text-xs">
          Your messages are end-to-end encrypted
        </p>
      </div>
    </div>
  );
}
