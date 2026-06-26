export default function Avatar({ src, name = '?', size = 40 }) {
  if (src) {
    return (
      <img
        src={src}
        alt={name}
        className="rounded-full object-cover"
        style={{ width: size, height: size }}
      />
    );
  }

  const colors = ['#00A884', '#5B61C4', '#CD5C5C', '#E67E22', '#2ECC71', '#E74C3C', '#3498DB', '#9B59B6'];
  const charCode = name.charCodeAt(0) || 0;
  const bgColor = colors[charCode % colors.length];
  const fontSize = Math.floor(size * 0.45);

  return (
    <div
      className="rounded-full flex items-center justify-center text-white font-semibold"
      style={{ width: size, height: size, backgroundColor: bgColor, fontSize }}
    >
      {name.charAt(0).toUpperCase()}
    </div>
  );
}
