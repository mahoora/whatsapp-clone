import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { getChats, getOrCreateChat, createGroup } from '../controllers/chatController.js';

const router = Router();

router.get('/', authenticate, getChats);
router.post('/', authenticate, getOrCreateChat);
router.post('/group', authenticate, createGroup);

export default router;
