export default function SearchBar({ value, onChange }) {
  return (
    <div className="px-3 py-2 bg-whatsapp-sidebar">
      <div className="flex items-center bg-whatsapp-input rounded-lg px-3 py-2">
        <svg className="w-5 h-5 text-whatsapp-text-secondary mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <input
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder="Search or start new chat"
          className="bg-transparent outline-none text-whatsapp-text text-sm w-full placeholder-whatsapp-text-secondary"
        />
      </div>
    </div>
  );
}
