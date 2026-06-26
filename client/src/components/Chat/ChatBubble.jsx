export default function ChatBubble({ message, isOwn }) {
  const time = message.createdAt
    ? new Date(message.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    : '';

  const statusIcon = () => {
    if (!isOwn) return null;
    if (message.status === 'read') return '✓✓';
    if (message.status === 'delivered') return '✓✓';
    return '✓';
  };

  const statusColor = message.status === 'read' ? '#53BDEB' : '#8696A0';

  return (
    <div className={`flex mb-1 ${isOwn ? 'justify-end' : 'justify-start'}`}>
      <div
        className={`max-w-[65%] px-3 py-1.5 rounded-lg text-sm leading-relaxed ${
          isOwn
            ? 'bg-whatsapp-bubble-out text-white rounded-br-sm'
            : 'bg-whatsapp-bubble text-whatsapp-text rounded-bl-sm'
        }`}
      >
        {message.type === 'image' && message.mediaURL && (
          <img src={message.mediaURL} alt="media" className="max-w-full rounded mb-1" />
        )}
        {message.text && <p className="whitespace-pre-wrap break-words">{message.text}</p>}
        <div className={`flex items-center gap-1 mt-0.5 ${isOwn ? 'justify-end' : 'justify-start'}`}>
          <span className="text-[11px] text-whatsapp-text-secondary">{time}</span>
          {isOwn && (
            <span className="text-[11px]" style={{ color: statusColor }}>
              {statusIcon()}
            </span>
          )}
        </div>
      </div>
    </div>
  );
}
