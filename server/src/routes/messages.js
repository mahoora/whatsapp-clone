import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { getMessages, sendMessage } from '../controllers/messageController.js';

const router = Router();

router.get('/:chatId', authenticate, getMessages);
router.post('/', authenticate, sendMessage);

export default router;
