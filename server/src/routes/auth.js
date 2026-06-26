import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { login, getProfile, updateProfile } from '../controllers/authController.js';

const router = Router();

router.post('/login', authenticate, login);
router.get('/profile', authenticate, getProfile);
router.put('/profile', authenticate, updateProfile);

export default router;
