import User from '../models/User.js';

export const searchUsers = async (req, res) => {
  const { query } = req.query;
  if (!query) return res.json({ users: [] });

  const users = await User.find({
    _id: { $ne: req.user._id },
    $or: [
      { displayName: { $regex: query, $options: 'i' } },
      { phoneNumber: { $regex: query, $options: 'i' } },
    ],
  }).select('displayName phoneNumber photoURL about isOnline lastSeen');

  res.json({ users });
};

export const getContacts = async (req, res) => {
  const user = await User.findById(req.user._id).populate(
    'contacts',
    'displayName phoneNumber photoURL about isOnline lastSeen'
  );
  res.json({ contacts: user.contacts });
};

export const addContact = async (req, res) => {
  const { phoneNumber } = req.body;
  const contact = await User.findOne({ phoneNumber });
  if (!contact) return res.status(404).json({ error: 'User not found' });

  const user = await User.findById(req.user._id);
  if (!user.contacts.includes(contact._id)) {
    user.contacts.push(contact._id);
    await user.save();
  }

  res.json({ contact });
};
