import { verifyFirebaseToken } from '../config/firebase.js';
import User from '../models/User.js';

export const authenticate = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split('Bearer ')[1];
    if (!token) return res.status(401).json({ error: 'No token provided' });

    const decoded = await verifyFirebaseToken(token);
    if (!decoded) return res.status(401).json({ error: 'Invalid token' });

    let user = await User.findOne({ phoneNumber: decoded.phone_number });
    if (!user) {
      user = await User.create({
        phoneNumber: decoded.phone_number,
        displayName: decoded.displayName || decoded.phone_number,
        photoURL: decoded.picture || '',
      });
    }

    req.user = user;
    req.uid = decoded.uid;
    next();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
