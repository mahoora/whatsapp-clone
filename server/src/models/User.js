import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  phoneNumber: { type: String, required: true, unique: true },
  displayName: { type: String, default: '' },
  photoURL: { type: String, default: '' },
  about: { type: String, default: 'Hey there! I am using Whats Maher' },
  contacts: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  isOnline: { type: Boolean, default: false },
  lastSeen: { type: Date, default: Date.now },
  fcmToken: { type: String, default: '' },
}, { timestamps: true });

export default mongoose.model('User', userSchema);
